import Data.Ratio
import Data.List (intercalate)

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

-- list of ratios within 50 cents for a given semitone
lstRatios :: Integer -> [(Rational, Integer)]
lstRatios n' = [(p2r xs, round . centsdiff n $ xs)
               | xs <- candidates,
               (<50) . abs . centsdiff n $ xs]
    where n = fromInteger n'
          candidates = [[e2, e3, e5]| e2 <- range 2, e3 <- range 3, e5 <- range 5]
          range n = [0..(ceiling . (*10) . logBase n $ 2)]

-- format a single approximation: "≒ 135/256 (-8 cents)"
fmtApprox :: (Rational, Integer) -> String
fmtApprox (r, c) = "≒ " ++ show (numerator r) ++ "/" ++ show (denominator r)
                    ++ " (" ++ showSigned c ++ " cents)"
    where showSigned x | x >= 0    = "+" ++ show x
                       | otherwise = show x

-- format a line: "+3 semitone\t≒ 75/64 (-25 cents)\t≒ 625/512 (+45 cents)"
fmtLine :: Integer -> String
fmtLine n = showSigned n ++ " semitone\t"
            ++ intercalate "\t" (map fmtApprox (lstRatios n))
    where showSigned x | x >= 0    = "+" ++ show x
                       | otherwise = show x

-- main
main :: IO ()
main = mapM_ (putStrLn . fmtLine) [-11..11]

