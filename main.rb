#!/usr/bin/env ruby

# Author: Daniel Tralamazza <tralamazza@gmail.com>

require 'optparse'

$LOAD_PATH << './lib'

require 'game.rb'
require 'player.rb'
require 'iocontrol.rb'
require 'tblcontrol.rb'


# default options
options = {
  :decks => 4,
  :players => 1,
  :allowsurrender => true,
  :money => 1000.0,
  :split_limit => 4,
  :dealer_stands_on => 17
}

# command line option parsing
OptionParser.new do |opts|
  opts.on("-d", "--decks NUM", Integer, "Number of decks") { |d|
    options[:decks] = d
  }
  opts.on("-p", "--players NUM", Integer, "Number of players") { |p|
    options[:players] = p
  }
  opts.on("-m", "--money FLOAT", Float, "Starting money") { |m|
    options[:money] = m
  }
  opts.on("-l", "--split_limit NUM", Integer, "Maximum number of splits") { |l|
    options[:split_limit] = l
  }
  opts.on("-s", "--allow-surrender OPT", [:yes, :no], "Allow surrender [yes, no]") { |s|
    options[:allowsurrender] = s == :yes
  }
  opts.on("-o", "--stands_on NUM", Integer, "Dealer stands on") { |o|
    options[:dealer_stands_on] = o
  }
end.parse!

# creates the game
game = Game.new(options)

# player creation loop (inform name)
options[:players].times { |i|
  p "Player's name ?"
  player = Player.new(gets.chomp, options[:money])
  game.put_player(player, IOController.new)
}
player = Player.new("Robot", options[:money])
game.put_player(player, TableController.new)

# start the game
game.run
