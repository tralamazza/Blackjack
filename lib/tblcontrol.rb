require 'const.rb'
require 'basic.rb'

class TableController
  include Basic

  TABLE_MAP = {
    H => [HIT],
    S => [STAND],
    P => [SPLIT],
    Dh => [ DOUBLE, HIT ],
    Ds => [ DOUBLE, STAND ],
    Rh => [ SURRENDER, HIT ],
    Rs => [ SURRENDER, STAND ],
  }

  def initialize
    @stats = {
      "win" => 0,
      "loss" => 0,
      "draw" => 0,
      "top profit" => 0
    }
  end

  def bet(player)
    p player.to_s
    return player.money > 9 ? 10 : player.money # XXX make this smarter
  end

  # return an action based on our basic table
  def make_decision(choices, player, hand, dealers_1st_card)
    row = nil
    if hand.is_pair? then
      row = PAIR[CARD_VALUE[hand[0]]]
    elsif hand.is_soft?
      row = SOFT[hand.value]
    end
    if row.nil? then
      row = HARD[hand.value]
    end
    if row.nil? then
      return STAND # default
    else
      tbl_decision = row[ CARD_VALUE[dealers_1st_card] - 2 ]
      decision = TABLE_MAP[tbl_decision] & choices
      return decision[0] || STAND
    end
  end

  def on_player_join(player)
  end

  def on_player_quit(player, reason)
    s = ""
    @stats.each_pair { |k,v| s += "\t#{k}= #{v}\n" }
    puts "#{player}, Statistics: \n#{s}"
  end

  def on_hand_changed(player_str, hand)
  end

  def on_player_win(player, hand)
    @stats["top profit"] = player.money if @stats["top profit"] < player.money
    @stats["win"] += 1
  end

  def on_player_draw(player, hand)
    @stats["draw"] += 1
  end

  def on_player_loss(player, hand)
    @stats["loss"] += 1
  end
end
