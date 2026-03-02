import Data.Ratio
import Data.List (intercalate)
import System.Environment (getArgs)

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

-- exponent range for a given prime base
exponentRange :: Integer -> [Integer]
exponentRange base = [0..(ceiling . (*10) . logBase (fromInteger base) $ (2 :: Double))]

-- list of ratios within threshold cents for a given semitone
lstRatios :: [Integer] -> Double -> Integer -> [(Rational, Integer)]
lstRatios usePrimes threshold n' =
    [(p2r xs, round . centsdiff n $ xs)
    | xs <- candidates,
    (<threshold) . abs . centsdiff n $ xs]
    where n = fromInteger n'
          candidates = sequence (map exponentRange usePrimes)

-- format a single approximation: "≒ 135/256 (-8 cents)"
fmtApprox :: (Rational, Integer) -> String
fmtApprox (r, c) = "≒ " ++ show (numerator r) ++ "/" ++ show (denominator r)
                    ++ " (" ++ showSigned c ++ " cents)"
    where showSigned x | x >= 0    = "+" ++ show x
                       | otherwise = show x

-- format a line: "+3 semitone\t≒ 75/64 (-25 cents)\t≒ 625/512 (+45 cents)"
fmtLine :: [Integer] -> Double -> Integer -> String
fmtLine usePrimes threshold n =
    showSigned n ++ " semitone\t"
    ++ intercalate "\t" (map fmtApprox (lstRatios usePrimes threshold n))
    where showSigned x | x >= 0    = "+" ++ show x
                       | otherwise = show x

-- parse command line arguments
parseArgs :: [String] -> ([Integer], Double)
parseArgs args = (parsePrimes args, parseThreshold args)
    where
        parsePrimes ("--primes":val:_) = map read (splitOn ',' val)
        parsePrimes (_:rest) = parsePrimes rest
        parsePrimes [] = [2, 3, 5]

        parseThreshold ("--threshold":val:_) = read val
        parseThreshold (_:rest) = parseThreshold rest
        parseThreshold [] = 50

        splitOn _ [] = []
        splitOn sep str = let (w, rest) = break (== sep) str
                          in w : case rest of
                                     [] -> []
                                     (_:xs) -> splitOn sep xs

-- main
main :: IO ()
main = do
    args <- getArgs
    let (usePrimes, threshold) = parseArgs args
    mapM_ (putStrLn . fmtLine usePrimes threshold) [-11..11]
