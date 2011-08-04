#!/usr/bin/env ruby

PLAYERS = 1
DECKS = 4

CARD_FACE = [
  "2s", "3s", "4s", "5s", "6s", "7s", "8s", "9s", "10s", "Js", "Qs", "Ks", "As",
  "2h", "3h", "4h", "5h", "6h", "7h", "8h", "9h", "10h", "Jh", "Qh", "Kh", "Ah",
  "2d", "3d", "4d", "5d", "6d", "7d", "8d", "9d", "10d", "Jd", "Qd", "Kd", "Ad",
  "2c", "3c", "4c", "5c", "6c", "7c", "8c", "9c", "10c", "Jc", "Qc", "Kc", "Ac"
]

CARD_VALUE = {
  "2s" => 2, "3s" => 3, "4s" => 4, "5s" => 5, "6s" => 6, "7s" => 7, "8s" => 8, "9s" => 9, "10s" => 10, "Js" => 10, "Qs" => 10, "Ks" => 10, "As" => 11,
  "2h" => 2, "3h" => 3, "4h" => 4, "5h" => 5, "6h" => 6, "7h" => 7, "8h" => 8, "9h" => 9, "10h" => 10, "Jh" => 10, "Qh" => 10, "Kh" => 10, "Ah" => 11,
  "2d" => 2, "3d" => 3, "4d" => 4, "5d" => 5, "6d" => 6, "7d" => 7, "8d" => 8, "9d" => 9, "10d" => 10, "Jd" => 10, "Qd" => 10, "Kd" => 10, "Ad" => 11,
  "2c" => 2, "3c" => 3, "4c" => 4, "5c" => 5, "6c" => 6, "7c" => 7, "8c" => 8, "9c" => 9, "10c" => 10, "Jc" => 10, "Qc" => 10, "Kc" => 10, "Ac" => 11
}

$dealer = []

$shoe = []
DECKS.times { |i| $shoe.concat(CARD_FACE) }

$players = []
PLAYERS.times { |i|
  $players.push({
    :name => "P#{i}",
    :money => 1000,
    :cards => [],
    :bet => 0
  })
}


def player_quit(pl, reason)
  $players.delete(pl)
  p "#{pl[:name]} left the table. #{reason}"
end

def is_blackjack(cards)
  return (cards.length == 2 &&
    (CARD_VALUE[cards[0]] + CARD_VALUE[cards[1]]) == 21) ? 1 : 0
end

def hand(cards)
  return (hand_values(cards).delete_if { |i| i > 21 }).last
end

def hand_values(cards)
  aces = s = 0
  cards.each { |c|
    if (c[0] == 65) then
      aces += 1
    else
      s += CARD_VALUE[c]
    end
  }
  rslt = []
  if (aces > 0) then
    (aces + 1).times { |i| rslt.push( s + (i * 11) + ((aces - i) * 1) ) }
  else
    rslt.push(s)
  end
  return rslt
end

def begin_turn
  $shoe.shuffle!

  $players.each do |pl|
    if (pl[:money] == 0) then
      player_quit(pl, "Player is broke!")
      next
    end

    begin
      p "[#{pl[:name]}] Place a (integer) bet or type any char to quit. $ #{pl[:money]}"
      pl[:bet] = Integer(gets.chomp)
      pl[:money] -= pl[:bet]
    rescue
      player_quit(pl, "Player chose to quit.")
      break
    end while (pl[:bet] <= 0 || pl[:bet] > pl[:money])
  end
  return !$players.empty?
end

def draw(cards)
  c = $shoe.shift
  cards.push(c)
  return c
end

def deal
  count = $players.length * 2
  count.times do |i|
    pl = $players[i % $players.length]
    draw(pl[:cards])
    draw($dealer) if (i == $players.length - 1)
  end
  draw($dealer)
end

def play
  p "Dealer's hand = #{$dealer.first}, _"
  $players.each do |pl|
    loop {
      hands = hand_values(pl[:cards])
      p "[#{pl[:name]}] hand = #{pl[:cards].join(', ')} | value(s): #{hands.join(', ')}"
      hands.delete_if {|i| i > 21 }
      if (hands.empty?) then
        p "Busted!"
        break
      end
      choices = { "H" => "(h)it", "S" => "(s)tand" }
      choices["D"] = "(d)ouble" if ((pl[:cards].length == 2) && (pl[:bet] >= pl[:money]))
      begin
        p choices.values.join(", ");
        move = gets.chomp.upcase()
      end while !choices[move]

      case move
        when "H"
          draw(pl[:cards])
        when "S"
          break
        when "D":
          pl[:money] -= bet
          draw(pl[:cards])
          break
      end
    }
  end
  begin
    hands = hand_values($dealer)
    p "Dealer's hand = #{$dealer.join(', ')} | values(s): #{hands.join(', ')}"
    hands.delete_if { |i| i > 16 }
    draw($dealer) unless hands.empty?
  end while !hands.empty?
  dealers_hand = [ is_blackjack($dealer), hand($dealer) || 1 ]
  $players.each do |pl|
    players_hand = [ is_blackjack(pl[:cards]), hand(pl[:cards]) || 0 ]
    case players_hand <=> dealers_hand
    when 1
      p "player wins"
      pl[:money] += pl[:bet] * 2
      pl[:money] += pl[:bet] if players_hand[0] == 1
    when 0
      p "push"
      pl[:money] += pl[:bet]
    when -1
      p "dealer wins"
    end
    pl[:bet] = 0
  end
end

def collect
  $shoe.concat($dealer.slice!(0 .. $dealer.length))
  $players.each do |pl|
    $shoe.concat(pl[:cards].slice!(0 .. pl[:cards].length))
  end
end

### MAIN ###

while begin_turn do
  deal
  play
  collect
end
p "Game over"
