import Data.Ratio

-- given e.g. [e2,e3,e5] this function returns 3^^e3 * 5^^e5 / 2^^e2
p2r :: [Integer] -> Rational
p2r xs = p2r' 1 primes xs
    where primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
          p2r' v [] _ = error "Too long list" -- if prime list became empty, xs is too long
          p2r' v _ [] = v
          p2r' v (p:ps) (x:xs) = p2r' (v * (exp p x)) ps xs
              where exp 2 x = (1 % 2) ^^ x
                    exp p x = (p % 1) ^^ x

-- given n (semitone) and list [e2, e3, e5] it compares n and 3^^e3 * 5^^e5 / 2^^e2
centsdiff :: Double -> [Integer] -> Double
centsdiff n xs = (*100) . (+(-n)) . (*12) . logBase 2 . fromRational . p2r $ xs

-- list of ratios
lstRatios :: Integer -> [(Rational, String)]
lstRatios n' = [(p2r xs, str_cents xs) 
               | xs <- candidates, 
               (<50) . abs . centsdiff n $ xs] -- if within 50 cent, xs is the candidate
    where n = fromInteger n'
          candidates = [[e2, e3, e5]| e2 <- range 2, e3 <- range 3, e5 <- range 5]
          range n = [0..(ceiling . (*10) . logBase n $ 2)]
          str_cents = (++" cents") . show . round . centsdiff n 

-- main
main = sequence $ map (print . lstRatios) [-11..11]

