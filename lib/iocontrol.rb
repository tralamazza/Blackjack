require 'const.rb'

# The IOController specialization asks the user for input using the command line terminal
class IOController
  # choice strings for the menu
  CHOICE_MENU = {
    HIT => "(h)it",
    STAND => "(s)tand",
    SPLIT => "s(p)lit",
    DOUBLE => "(d)ouble",
    SURRENDER => "s(u)rrender"
  }

  # maps chars to choice options
  CHOICE_MAP = {
    "H" => HIT,
    "S" => STAND,
    "P" => SPLIT,
    "D" => DOUBLE,
    "U" => SURRENDER
  }

  # asks the user to supply a bet (integer) or quits otherwise
  def bet(player)
    begin
      p "#{player}, please place a bet or type any char to quit."
      return Integer(gets.chomp)
    rescue
      raise "chose to quit."
    end
  end

  # this method receives a list of possible choices (actions) and asks the user which one it should return
#  def make_decision(choices, player_str, hand_str, dealers_1st_card)
  def make_decision(choices, player, hand, dealers_1st_card)
    p "Dealer's hand = #{dealers_1st_card}, _"
    p "#{player}, #{hand}"
    menu = []
    choices.each { |c| menu << CHOICE_MENU[c] }
    loop {
      p menu.join(', ') # prints menu
      decision = gets.chomp.upcase # read from cmd
      dmap = CHOICE_MAP[decision]
      next if dmap.nil? # a valid choice ?
      return dmap unless choices.index(dmap).nil? # in choices ?
    }
  end

  # event fired once player joins the game
  def on_player_join(player)
    p "#{player}, joins the game"
  end

  # event signaling the player has left the game
  def on_player_quit(player, reason)
    p "#{player}, quits: #{reason}"
  end

  # show players hand
  def on_hand_changed(player_str, hand)
    p "#{player_str}, #{hand}"
  end

  # player won
  def on_player_win(player, hand)
    p "#{player} won#{" w/ a blacjack!" if hand.is_blackjack?} #{hand}"
  end

  # player tied
  def on_player_draw(player, hand)
    p "#{player} tied #{hand}"
  end

  # player lost
  def on_player_loss(player, hand)
    p "#{player} lost #{hand}"
  end
end
