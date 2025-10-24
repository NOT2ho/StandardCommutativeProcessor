{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
import Data.Tree
import Data.Set as S (Set, take, partition, size, elemAt, fromList, map, toList)
import qualified Data.List as L (partition, take, map)
import Data.Char
------------------------------------------------------


main :: IO ()
main = pure ()

type N = Int

s :: N -> N
s = (+ 1)

o :: N -> N
o x = 0

ini :: N -> N -> ([N] -> N)
ini n i l = if length l == n then  l !! (i+1) else error "your fault"

prec ::  [N] -> ([N] -> N) -> ([N] -> N) -> N
prec x' p c = let (xs,x) = (init x', last x') in
    if x == 0 then p xs
    else c (xs ++ [x-1] ++ [prec (xs ++ [x-1]) p c])

mrec :: [N] -> ([N] -> N) -> N
mrec x p = let mu y = if p (x ++ [y]) == 0 then y
                    else mu (y+1)
            in mu 0

comp :: ([N] -> N) -> [[N] -> N] -> ([N] -> N)
comp f cs x = f (($ x) <$> cs)


-----------------------------------------------------------------

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