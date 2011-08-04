require('strategy')

module Basic
  include Strategy
#                   Dealer's hand
#           2   3   4   5   6   7   8   9   10  A
  HARD = {
    5  => [ H,  H,  H,  H,  H,  H,  H,  H,  H,  H ],
    6  => [ H,  H,  H,  H,  H,  H,  H,  H,  H,  H ],
    7  => [ H,  H,  H,  H,  H,  H,  H,  H,  H,  H ],
    8  => [ H,  H,  H,  H,  H,  H,  H,  H,  H,  H ],
    9  => [ H,  Dh, Dh, Dh, Dh, H,  H,  H,  H,  H ],
    10 => [ Dh, Dh, Dh, Dh, Dh, Dh, Dh, Dh, H,  H ],
    11 => [ Dh, Dh, Dh, Dh, Dh, Dh, Dh, Dh, Dh, H ],
    12 => [ H,  H,  S,  S,  S,  H,  H,  H,  H,  H ],
    13 => [ S,  S,  S,  S,  S,  H,  H,  H,  H,  H ],
    14 => [ S,  S,  S,  S,  S,  H,  H,  H,  H,  H ],
    15 => [ S,  S,  S,  S,  S,  H,  H,  H,  Rs, H ],
    16 => [ S,  S,  S,  S,  S,  H,  H,  Rs, Rs, Rs ],
    17 => [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S ],
    18 => [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S ],
    19 => [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S ],
    20 => [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S ]
  }
#           2   3   4   5   6   7   8   9   10  A
  SOFT = {
    13 => [ H,  H,  H,  Dh, Dh, H,  H,  H,  H,  H ],
    14 => [ H,  H,  H,  Dh, Dh, H,  H,  H,  H,  H ],
    15 => [ H,  H,  Dh, Dh, Dh, H,  H,  H,  H,  H ],
    15 => [ H,  H,  Dh, Dh, Dh, H,  H,  H,  H,  H ],
    16 => [ H,  Dh, Dh, Dh, Dh, H,  H,  H,  H,  H ],
    17 => [ H,  Ds, Ds, Ds, Ds, H,  H,  H,  H,  H ],
    18 => [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S ],
    19 => [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S ]
  }
#           2   3   4   5   6   7   8   9   10  A
  PAIR = {
    2  => [ P,  P,  P,  P,  P,  P,  H,  H,  H,  H ],
    3  => [ P,  P,  P,  P,  P,  P,  H,  H,  H,  H ],
    4  => [ H,  H,  H,  P,  P,  H,  H,  H,  H,  H ],
    5  => [ Dh, Dh, Dh, Dh, Dh, Dh, Dh, Dh, H,  H ],
    6  => [ P,  P,  P,  P,  P,  H,  H,  H,  H,  H ],
    7  => [ P,  P,  P,  P,  P,  P,  H,  H,  H,  H ],
    8  => [ P,  P,  P,  P,  P,  P,  P,  P,  P,  P ],
    9  => [ P,  P,  P,  P,  P,  S,  P,  P,  S,  S ],
    10 => [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S ],
    11 => [ P,  P,  P,  P,  P,  P,  P,  P,  P,  P ]
  }
end
