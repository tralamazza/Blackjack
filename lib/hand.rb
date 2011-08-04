require 'const.rb'

# Blackjack hand class which manipulates an array of cards
class Hand
  # ctor
  def initialize
    @cards = []
  end

  # split the hand and returns a new Hand
  def split
    nh = Hand.new # new hand
    nh.add_card(@cards.pop) # remove from this hand and add to the new one
    return nh
  end

  # adds a card, see CARD_FACE for valid cards
  def add_card(card)
    if card.nil? then
      raise "WTF"
    end
    @cards << card
    return card # avoid returning the array
  end

  # returns a copy of the card array
  def cards_dup
    return @cards.dup
  end

  # returns the number of cards
  def size
    return @cards.length
  end

  # returns the card at position i
  def [](i)
    return @cards[i]
  end

  # returns true if the hand is a blackjack, i.e. an ace + ten/face card
  def is_blackjack?
    return (@cards.length == 2 &&
      (CARD_VALUE[@cards[0]] + CARD_VALUE[@cards[1]]) == 21)
  end

  # returns true if this hand is a (value) pair
  def is_pair?
    return @cards.length == 2 && (CARD_VALUE[@cards[0]] == CARD_VALUE[@cards[1]])
  end
  
  # returns true if this hand has an Ace that can be used as 1 or 11
  def is_soft?
    v = values.delete_if { |i| i > 21 }
    return v.length > 1
  end

  # returns true if this hand has at least one Ace
  def has_ace?
    @cards.each { |c| return true if c[0] == 65 }
    return false
  end

  # returns an array of computed hand values
  # e.g cards [ "J", "2" ] returns [ 12 ]
  #     cards [ "A", "2" ] returns [ 3, 13 ]
  #     cards [ "A", "A", "2" ] returns [ 4, 14, 24 ]
  def values
    n_aces = sum = 0 # number of aces, non ace cards sum
    @cards.each { |c|
      # counts the ace or sums the card value
      (c[0] == 65) ? n_aces += 1 : sum += CARD_VALUE[c]
    }
    arr_v = []
    if (n_aces > 0) then
      # if we have an ace, compute all possible hand values (soft, hard)
      (n_aces + 1).times { |i| arr_v << sum + (10 * i) + n_aces }
    else
      arr_v << sum # no aces, just the sum
    end
    return arr_v
  end

  # returns the best possible value (largest value < 22) for this hand or nil if busted
  def value
    return values.delete_if { |i| i > 21 }.last
  end

  # returns true if all possible values are over 21
  def busted?
    return value.nil?
  end

  # to string
  def to_s
    "hand { #{@cards.join(', ')} } values [ #{values.join(', ')} ]"
  end
end
