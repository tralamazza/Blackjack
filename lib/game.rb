require 'const.rb'
require 'hand.rb'
require 'iocontrol.rb'

# As the main class, Game controls all players which are associated with 
# a controller class. Controllers return player decisions which are validated
# by the Game.
class Game
  attr_reader :options

  # ctor(options)
  def initialize(options)
    @dealers_hand = Hand.new # dealers hand
    @options = options
    @shoe = [] # all our cards (from N decks)
    @scrap = []
    @players = {} # players index their controller
  end

  # adds a player and its controller (IOController by default)
  def put_player(player, controller = IOController.new)
    @players[player] = controller
    controller.on_player_join(player.dup.freeze)
  end

  # removes a player and notifies its controller
  def delete_player(player, reason = '')
    if @players.has_key?(player) then
      @players.delete(player).on_player_quit(player.dup.freeze, reason)
    end
  end

  # returns dealers first card (the one faced up)
  def dealers_first_card
    return @dealers_hand[0]
  end

  # This method will finish once all players have left the table
  def run
    # populate our shoe with N decks
    @options[:decks].times { |i| @shoe.concat(CARD_FACE) }
    # game loop
    loop {
      bet_phase # first phase
      break if @players.empty? # break the loop when there are no more players
      deal_phase # deal all cards
      play_phase # player make their decisions
      result_phase # winners and losers
      collect_phase # collect all cards
    }
  end

  private

  # draws a card from the shoe and adds it to a hand
  def draw(hand)
    if @shoe.empty? then # shoe is empty ?
      @shoe.concat(@scrap.shuffle) # refill and shuffle
      @scrap.clear # clear our scrap pile
    end
    hand.add_card(@shoe.shift)
  end

  # players place their bets
  def bet_phase
    @players.each_pair { |player, control|
      if player.money == 0 then # is the player broke ?
        delete_player(player, "#{player.name} has no money!")
        next
      end

      begin
        begin
          bet = control.bet(player.dup.freeze) # ask controller
        end until player.place_bet(bet)
      rescue => e
        delete_player(player, e.message) # remove player
      end
    }
  end

  # cards are dealt clockwise starting left of the dealer
  def deal_phase
    deal_count = @players.length * 2
    deal_count.times { |i|
      player = @players.keys[i % @players.length] # cycle players
      draw(player.main_hand) # player draws a card
      draw(@dealers_hand) if (i == @players.length - 1) # dealer
    }
    draw(@dealers_hand) # dealer draws its last (hidden) card
  end

  # players make decisions for each hand
  def play_phase
    # loop all players
    @players.each_pair do |player, control|
      # loop all players hand
      player.hands.each do |hand|
        while !hand.busted? do # break if we go over 21
          # add available choices
          choices = [] # choice array
          if hand.size == 2 then # only first hands can split, double or surrender
            # A split needs 2 cards of the same value, enough money to bet and not over the resplit limit
            choices << SPLIT if hand.is_pair? && player.can_afford?(hand) &&
              player.hands.length <= @options[:split_limit]
            choices << DOUBLE if player.can_afford?(hand) # can we afford the bet ?
            choices << SURRENDER if @options[:allow_surrender]
          end
          choices.concat([ HIT, STAND ]) # add standard choices
          decision = control.make_decision(choices, player.dup.freeze, hand.dup.freeze, dealers_first_card)
          # throw an error if the controller tries to trick us
          throw "Invalid decision!" if choices.index(decision).nil? 
          case decision
          when SPLIT
            new_hand = player.split_hand(hand) # split the hand in two
            draw(new_hand) # draw a card for the new hand
            control.on_hand_changed(player.to_s, new_hand.dup.freeze)
            draw(hand) # draw a card for the original hand
          when DOUBLE
            player.place_bet(player.bet_for(hand), hand) # doubles the bet
            draw(hand) # draws a card
            break # and stands
          when SURRENDER
            player.surrender(hand)
            break # break the loop
          when HIT
            draw(hand)
          when STAND
            break # break the loop
          end
        end
        control.on_hand_changed(player.to_s, hand.dup.freeze)
      end
    end
  end

  # dealer draws if necessary, sort winners and losers
  def result_phase
    # dealer will draw until it busts or goes over a limit
    dhv = @dealers_hand.value
    while !dhv.nil? && dhv < @options[:dealer_stands_on] do
      draw(@dealers_hand)
      dhv = @dealers_hand.value
    end
    # value to compare [ blackjack value, hand value (1 if busted) ]
    dealer_cmp = [ @dealers_hand.is_blackjack? ? 1 : 0, dhv || 1 ]
    @players.each_pair do |player, control| # for each player
      control.on_hand_changed("Dealer", @dealers_hand.dup.freeze)
      player.hands.each do |hand| # for each hand
        case dealer_cmp <=> [ hand.is_blackjack? ? 1 : 0, hand.value || 0 ]
        when -1
          # player won (blackjacks pays 3:2)
          player.pay_bet(hand, (hand.is_blackjack? ? 1.5 : 1))
          control.on_player_win(player.dup.freeze, hand.dup.freeze)
        when 0
          # tied score, just get the money back
          player.pay_bet(hand, 0)
          control.on_player_draw(player.dup.freeze, hand.dup.freeze)
        when 1
          # dealer won
          control.on_player_loss(player.dup.freeze, hand.dup.freeze)
        end
      end
    end
  end

  # all cards are returned to the shoe
  def collect_phase
    @players.each_key { |player| @shoe.concat(player.reset_hands) }
    @shoe.concat(@dealers_hand.cards_dup)
    @dealers_hand = Hand.new
  end
end
