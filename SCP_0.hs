{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}


module SCP_0 (scp_0) where

import Data.Tree
import Data.Set as S (Set, take, partition, size, elemAt, fromList, map, toList)
import qualified Data.List as L (partition, take, map)
import Data.Char
import Control.Monad


------------------------------------------------------


main :: IO ()
main = do
        putStrLn "welcome to the scp-0 world"
        forever scpi
    
scpi :: IO ()
scpi =  do 
            putStr "code: "
            code <- getLine
            putStr "param number: "
            num <- read <$> getLine
            param <- inputList num []
            putStrLn $ "num: " ++ show (scp_0 code $ reverse param)

inputList :: Int -> [Integer] -> IO [Integer]
inputList i l = do 
    if i == 0 then return l
    else do
        putStr "enter number: "
        n <- getLine 
        inputList (i-1) (read n:l)

----------------initial functions, primitive recursion, mu recursion, composition --------------


type N = Integer

s :: ([N] -> N)
s x = if length x == 1 then head x + 1 else error "your fault"

o :: ([N] -> N)
o = const 0

ini :: N -> N -> ([N] -> N)
ini n i l = if length l == fromIntegral n 
                then fromIntegral (l !! (fromInteger i-1)) 
                else error"you wrong"
-- i think index will be small..



prec :: ([N] -> N) -> ([N] -> N) ->  ([N] -> N)
prec= prec'
    where
        prec' :: ([N] -> N) -> ([N] -> N) -> [N] -> N
        prec' p' c' x' =
            let (xs,x) = (init x', last x') in
            if x == 0 then p' xs
            else c' (xs ++ [x-1] ++ [prec' p' c' (xs ++ [x-1])])

mrec :: ([N] -> N) ->  ([N] -> N)
mrec  = mrec'
    where
        mrec' ::([N] -> N) -> [N] -> N
        mrec' p x = let mu y = if p (x ++ [y]) == 0 then y
                            else mu (y+1)
                    in mu 0

comp :: ([N] -> N) -> [[N] -> N] -> ([N] -> N)
comp f cs x = f (($ x) <$> cs)



-------------------eval-----------------------------


scp_0 :: String -> ([N] -> N)
scp_0 s = let (ROOT pt) = parseTree s
            in eval pt


eval :: Node -> ([N] -> N)
eval n = case n of
    COMP g cs -> comp (eval g) (L.map eval cs)
    PREC g c -> prec (eval g) (eval c)
    MU c -> mrec (eval c)
    O -> o
    S -> s
    I n i -> ini n i


-------------------------parser----------------------

data Node
    = COMP Node [Node]
    | PREC Node Node
    | MU Node
    | ROOT Node
    | O
    | S
    | I N N
    deriving (Show)


parseTree :: String -> Node
parseTree = subparseTree . fromList . parser
    where
        subparseTree :: Set [String] -> Node
        subparseTree set = let (root, es) = S.partition (\x -> drop 1 x == ["root"]) set
                        in if size root == 1 then ROOT (nodes (head $ elemAt 0 root) $ toList es)
                            else error $ "why #root >1: "++ show root


        nodes :: String -> [[String]] -> Node
        nodes fname s= let (fs, others) = L.partition (\x -> head x == fname) s
                            in case fs of
                                [f1,f2]     | f1 !! 1 == "PREC0" && f2 !! 1 == "PREC1"
                                                -> PREC (nodes (f1 !! 2) others) (nodes (f2 !! 2) others)
                                            | f2 !! 1 == "PREC0" &&  f1 !! 1 == "PREC1"
                                                -> PREC (nodes (f2 !! 2) others) (nodes (f1 !! 2) others)
                                            | otherwise -> error $ "your primitive recursion wrong: " ++ show fs

                                [f] | f !! 1 == "COMP" -> COMP (nodes (f !! 2) others) (L.map (`nodes` others) $ drop 3 f)
                                    | f !! 1 == "MU" -> MU (nodes (f!! 2) others)

                                _
                                    | fname == "O" -> O
                                    | fname == "S" -> S
                                    | head fname == 'I' ->
                                        let (fn:ame) = fname
                                        in let (n, i) = span (/=',') ame
                                            in I (read n) (read $ drop 1 i)
                                    | otherwise -> error (show (fname, s, fs, others))

parser :: String -> [[String]]
parser s = L.map subparser (words s)
        where
        subparser :: String -> [String]
        subparser s = let (fname, s') = span ((||) <$> isDigit <*> isLower) s
                    in let (nodetype, s'') = break ((||) <$> isDigit <*> isAlpha) s'
                    in fname : node nodetype s''
                        where node t strs
                                | t == "" = []
                                | t == ">" = "COMP": initial (takeWhile (/='.') strs)++ composition (drop 1 $ dropWhile (/='.') strs)
                                | t == "|>" = "PREC0" : initial strs
                                | t == "|+>" = "PREC1" : initial strs
                                | t == "<" = "MU" : initial strs
                                | t == ":" = ["root"]
                                | otherwise = error ("what is "++ t)

        initial :: [Char] -> [String]
        initial (c:cs)
            | (c:cs) == "O" = ["O"]
            | (c:cs) == "S" = ["S"]
            | c == 'I' = ["I" ++ projection cs]
            | all ((||) <$> isDigit <*> isLower) (c:cs) = [c:cs]
            | otherwise = error $ (c:cs) ++ " is not initial function or function name"
        initial [] = []

        projection :: [Char] -> [Char]
        projection cs =
            let (sup,n,sub,i) = (L.take 1 cs, takeWhile ((||) <$> isDigit <*> isLower) (drop 1 cs), L.take 1 $ dropWhile (/='_') cs, tail $ dropWhile (/='_') cs )
                in if sup == "^" && all isDigit n && sub == "_" && all isDigit i
                                    then
                                        let (n', i') = (read n :: Int, read i :: Int)
                                        in
                                            if n' >= i' && n' > 0 && i' > 0
                                            then  n++ "," ++i
                                            else error $  "your index wrong: " ++ "i= " ++ i ++ ", n= " ++ n
                                    else error ("what is "++ cs)

        composition :: [Char] -> [String]
        composition str = let (s1, s2) = span (/=',') str
                        in if s1 /= [] then initial s1 ++ composition (drop 1 s2)
                                        else []