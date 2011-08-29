# The BlackJack experiment

By default the `main.rb` will create 1 human player and one 1 robot player.

Run the game:

    ./main.rb

Get some command line help/parameters:

    ./main.rb --help

Test our robot and get some (gnuplot) graph out of it !

    ./main.rb -p 0 | sed '/Robot/,$d' | gnuplot -p -e "plot '-' with lines title 'money' "

![blackjack_robot.png](http://i.imgur.com/LVT5om.jpg)

## Future ideas

* Card counting robot :-)
* Casino variants (zillions)
