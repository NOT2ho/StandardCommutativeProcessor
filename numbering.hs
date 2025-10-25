{-# LANGUAGE ParallelListComp #-}

module Numbering(conaturalizer, main) where

import Data.Bifunctor
import System.Directory
import System.FilePath
import Distribution.Compat.Prelude(readMaybe)

numbering :: IO ()
numbering = main

main :: IO ()
main = do
    currentDir <- getCurrentDirectory
    putStr "input file name(default: numbering.hs): "
    filename <- getLine
    let fileloc = if filename /= [] then currentDir </> filename else currentDir </> "numbering.hs"
    file <- readFile fileloc
    putStr "output file name(default: output.txt): "
    filename' <- getLine
    let output =  if null filename' then  currentDir </> "output" ++ ".txt" else currentDir </> filename'
    putStr "0 to naturalize, else to else: "
    what <- inputNum 2
    putStrLn "... "
    if what == 0 then do
            putStrLn "to number: "
            print (factorize (naturalizer file) )
            writeFile output $ show (naturalizer file)
        else do
            putStrLn "to string: "
            writeFile output $ conaturalizer (read file:: Integer)

inputNum :: Int -> IO Int
inputNum n = do
    str <- getLine
    case readMaybe str ::Maybe Int of
        Just i -> return i
        nothing -> putStrLn "int." >> inputNum n

productizer :: String -> [(Integer, Char)]
productizer (c:cs) =
    let rec i (c:cs) = if null cs then [(i , c)]
            else (i, c): rec (i+1) cs
        in rec 0 cs

coproductizer :: [(Integer, Char)] -> String
coproductizer = map snd

productizerCoded :: String -> [(Integer, Integer)]
productizerCoded = map (second code) .  productizer

coproductizerCoded :: [(Integer, Integer)] -> String
coproductizerCoded is = let prdt = map (second de) is
                        in coproductizer prdt

conaturalizer :: Integer -> String
conaturalizer = coproductizerCoded . factorize

naturalizer :: String -> Integer
naturalizer s = product [x ^ i | x <- primes | i <- map code s ]

primes :: [Integer]
primes = 2: 3: sieve (tail primes) [5,7..]
 where
  sieve (p:ps) xs = h ++ sieve ps [x | x <- t, x `rem` p /= 0]
                  where (h,~(_:t)) = span (< p*p) xs

factorize :: Integer -> [(Integer, Integer)]
factorize num =
    let divide i n = if n == 1 then []
                        else let ith = (primes !! fromInteger i)
                        in (i, empowerer n ith) : divide (i+1) (n `div` (ith ^ empowerer n ith))
        in divide 0 num

empowerer :: Integer -> Integer -> Integer
empowerer i p = let rec j i = if i `mod` p /= 0 then j else rec (j+1) (i `div` p) :: Integer
                    in rec 0 i

symbols :: [Char]
symbols =",.+IO|S:<> 1234567890qwertyuiopasdfghjklzxcvbnm[]"

de :: Integer -> Char
de i = if fromIntegral i < length symbols then symbols !! fromIntegral i
    else error "your number wrong"

code :: Char -> Integer
code c = let mu i
               | de i == c = i
               | fromInteger i == 0 = error "your char wrong"
               | otherwise = mu (i-1)
            in mu (fromIntegral (length symbols) -1)

