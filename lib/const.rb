# card contants
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

# blackjack decision constant
SPLIT = :split
DOUBLE = :double
SURRENDER = :surrender
HIT = :hit
STAND = :stand
