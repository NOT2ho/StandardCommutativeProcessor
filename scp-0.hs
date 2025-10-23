{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
import Data.Char
{-# HLINT ignore "Use camelCase" #-}
import Data.Tree

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
comp f cs x = f ( ($ x) <$> cs)


-----------------------------------------------------------------

data Node
    = COMP [Node]
    | PREC (Node, Node)
    | MU Node
    | ROOT Node
    | O
    | S
    | I (N, N)


parser :: String -> [[String]]
parser s = map subparser (words s)

subparser :: String -> [String]
subparser s = let (fname, s') = span ((||) <$> isDigit <*> isLower) s
            in let (nodetype, s'') = break ((||) <$> isDigit <*> isAlpha) s'
            in fname : node nodetype s''
                where node t strs
                        | t == "" = []
                        | t == ">" = "comp": initial (takeWhile (/='.') strs)++ composition (drop 1 $ dropWhile (/='.') strs)
                        | t == "|>" = "prec0" : initial strs
                        | t == "|+>" = "prec1" : initial strs
                        | t == "<" = "mu" : initial strs
                        | t == ":" = ["root"]
                        | otherwise = error ("what is "++ t)

initial :: [Char] -> [String]
initial (c:cs)
    | (c:cs) == "O" = ["O"]
    | (c:cs) == "S" = ["S"]
    | c == 'I' = ["I" , projection cs]
    | all ((||) <$> isDigit <*> isLower) (c:cs) = [c:cs]
    | otherwise = error $ (c:cs) ++ " is not initial function or function name"
initial [] = []

projection :: [Char] -> [Char]
projection [sup,n,sub,i] = if sup == '^' && isDigit n && sub == '_' && isDigit i
                            then
                                let (n', i') = (read [n] :: Int, read [i] :: Int)
                                in
                                    if n' >= i' && n' > 0 && i' > 0
                                    then [sup,n,sub,i]
                                    else error $  "your index wrong: " ++ "i= " ++ [i] ++ ", n= " ++ [n]
                            else error ("what is "++ [sup,n,sub,i])
projection str = error $ "your projection wrong: " ++ str

composition :: [Char] -> [String]
composition str = let (s1, s2) = span (/=',') str
                in if s1 /= [] then initial s1 ++ composition (drop 1 s2)
                                else []