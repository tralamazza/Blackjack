# This class represents a player with N hands (in case of split)
# Each player has a name and some amount of money for placing bets
class Player
  attr_reader :name, :money, :hands

  # ctor(player name, available money)
  def initialize(name, money)
    @name = name
    @money = money
    @hands = [ Hand.new ]
    @bets = {}
    @surrended = {}
  end

  # returns the first (usually only) hand
  def main_hand
    return @hands[0]
  end

  # split a hand (owned by the player)
  def split_hand(hand)
    newhand = hand.split
    @hands << newhand # append to our hands
    place_bet(bet_for(hand), newhand)
    return newhand
  end

  # returns true if the player can bet the amount corresponding to a hand
  def can_afford?(hand)
    return valid_bet?(bet_for(hand))
  end

  # returns the current bet value for a hand
  def bet_for(hand)
    return @bets[hand]
  end

  # place a bet, i.e. adds bet to a specific hand owned by this player
  def place_bet(bet, hand = main_hand)
    if valid_bet?(bet) then
      @money -= bet # deduce from money
      @bets.has_key?(hand) ? @bets[hand] += bet : @bets[hand] = bet
      return true
    else
      return false
    end
  end

  # recover 50% of the original bet
  def surrender(hand)
    @money += (bet_for(hand) / 2)
    @surrended[hand] = true
  end

  # increments the total money according to a hand's bet and a win ratio (bj 3:2, win 1:1)
  def pay_bet(hand, ratio)
    return if @surrended[hand]
    bet = bet_for(hand)
    @money += bet + (bet * ratio)
  end

  # returns an array with all cards from all hands
  # @hands is cleared after calling this method
  def reset_hands
    allcards = []
    @hands.each { |h| h.size.times { |i| allcards << h[i] } }
    @hands = [ Hand.new ]
    @bets.clear 
    @surrended.clear
    return allcards# flat array of cards
  end

  # to string
  def to_s
    "#{@name} ($#{@money})"
  end

  private

  def valid_bet?(bet)
    return bet > 0 && bet <= @money
  end
end
