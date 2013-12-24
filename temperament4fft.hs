import Data.Ratio

p2r :: [Integer] -> Rational
p2r = p2r' 1 primes
    where primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
          p2r' v [] _ = error "Too long list"
          p2r' v _ [] = v
          p2r' v (p:ps) (x:xs) = p2r' (v * (exp p x)) ps xs
              where exp 2 x = (1 % 2) ^^ x
                    exp p x = (p % 1) ^^ x

centsdiff :: Double -> [Integer] -> Double
centsdiff n = (*100) . (+(-n)) . (*12) . logBase 2 . fromRational . p2r

lstRatios :: Integer -> [(Rational, String)]
lstRatios n' = [(p2r xs, str_cents xs) 
               | xs <- candidates, 
               (<50) . abs . centsdiff n $ xs]
    where n = fromInteger n'
          candidates = [[e2, e3, e5]| e2 <- range 2, e3 <- range 3, e5 <- range 5]
          range n = [0..(ceiling . (*10) . logBase n $ 2)]
          str_cents = (++" cents") . show . round . centsdiff n 

main = sequence $ map (print . lstRatios) [-11..11]

