{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}


module SCP_0 (scp_0, main) where

import Data.Tree
import Data.Set as S (Set, take, partition, size, elemAt, fromList, map, toList)
import qualified Data.List as L (partition, take, map)
import Data.Char
import Control.Monad
import Data.List (find)
import Data.Either (fromLeft, isLeft, rights, lefts, fromRight)
import Distribution.Compat.Prelude (readMaybe)
import Text.Read (readEither)
import System.IO


-----------------------io-------------------------------


main :: IO ()
main = do
        hSetBuffering stdin NoBuffering
        hSetBuffering stdout NoBuffering
        putStrLn "scpi 0.0.1 https://github.com/NOT2ho/StandardCommutativeProcessor \nwelcome to the scp-0 world. scpi will run forever"
        forever scpi

scpiParser :: String -> (String, Maybe [Integer])
scpiParser s = let c = takeWhile (/= '[') s
                in let d = dropWhile (/= '[') s
                in (c,readMaybe d)

scpi :: IO ()
scpi =  do
            putStr "scpi> "
            code' <- getLine
            let (code, param) = scpiParser code'
            case param of
                Just p -> either print  (putStrLn . ("USER ERROR: "++) ) $ scp_0 code p
                Nothing -> putStrLn "input parse error"
            -- either (\x -> putStrLn $ "num: " ++  show (x $ reverse param)) (\x -> putStrLn $ "USER ERROR: "++ x) (scp_0 code)

inputNum :: IO Integer
inputNum = do
        str <- getLine
        case readMaybe str ::Maybe Integer of
            Just i -> if i < 1 then putStrLn "out of index try again" >> inputNum else return i
            nothing -> putStrLn "?" >> inputNum


inputList :: Integer -> [Integer] -> IO [Integer]
inputList i l = do
    if i == 0 then return l
    else do
        putStr "enter number: "
        n <- getLine
        if read n >= 0 then inputList (i-1) (read n:l)
        else putStrLn "enter a natural number: " >> inputList i l

----------------initial functions, primitive recursion, mu recursion, composition --------------


type N = Integer
type F = ([N] -> Either N String)

s :: F
s x = if length x == 1 then Left (head x + 1) else Right ("your fault (S is 1-ary function, you tried " ++ show (length x) ++ "-ary")

o :: F
o = const (Left 0)

ini :: N -> N -> F
ini n i l = if length l == fromIntegral n
                then Left (fromIntegral (l !! (fromInteger i-1)))
                else Right ( "you wrong!!! your I is " ++ show n ++ "-ary, not " ++ show (length l) ++ "-ary")
-- i think index will be small..



prec :: F -> F -> F
prec= prec'
    where
        prec' :: F -> F -> [N] -> Either N String
        prec' p' c' x' =
            let (xs,x) = (init x', last x') in
            if x == 0 then p' xs
            else if null (rights [prec' p' c' (xs ++ [x-1])])
                then c' (xs ++ [x-1] ++ lefts [prec' p' c' (xs ++ [x-1])])
                else Right (concat $ rights [prec' p' c' (xs ++ [x-1])])

mrec :: F -> F
mrec  = mrec'
    where
        mrec' ::F -> [N] -> Either N String
        mrec' p x = let mu y = if p (x ++ [y]) == Left 0 then y
                            else mu (y+1)
                    in Left (mu 0)

comp :: F -> [F] -> F
comp f cs x =
    if null (rights (($ x) <$> cs))
        then f $ lefts (($ x) <$> cs)
        else Right (concat $ rights (($ x) <$> cs))



-------------------eval-----------------------------


scp_0 :: String -> F
scp_0 s = let (ROOT pt) = parseTree s
            in case pt of
                ERROR e -> const (Right e)
                _ -> eval pt


eval :: Node -> F
eval n = case n of
    ERROR s -> const (Right s)
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
    | ERROR String
    deriving (Show)


parseTree :: String -> Node
parseTree = subparseTree . fromList . parser
    where
        subparseTree :: Set [String] -> Node
        subparseTree set = let (root, es) = S.partition (\x -> drop 1 x == ["root"]) set
                        in if size root == 1 then ROOT (nodes (head $ elemAt 0 root) $ toList es)
                            else ROOT (ERROR ("why root do not uniquely exist: "++ show root))


        nodes :: String -> [[String]] -> Node
        nodes fname s= case find ("ERROR" `elem`) s of
                        Just e -> ERROR (dropWhile (/="ERROR") e !! 1)
                        Nothing ->
                            let (fs, others) = L.partition (\x -> head x == fname) s
                                in case fs of
                                    [f1,f2]     | f1 !! 1 == "PREC0" && f2 !! 1 == "PREC1"
                                                    -> PREC (nodes (f1 !! 2) others) (nodes (f2 !! 2) others)
                                                | f2 !! 1 == "PREC0" &&  f1 !! 1 == "PREC1"
                                                    -> PREC (nodes (f2 !! 2) others) (nodes (f1 !! 2) others)
                                                | otherwise -> ERROR ("your primitive recursion wrong: " ++ show fs)

                                    [f] | f !! 1 == "COMP" -> COMP (nodes (f !! 2) others) (L.map (`nodes` others) $ drop 3 f)
                                        | f !! 1 == "MU" -> MU (nodes (f!! 2) others)

                                    _
                                        | fname == "O" -> O
                                        | fname == "S" -> S
                                        | head fname == 'I' ->
                                            let (fn:ame) = fname
                                            in let (n, i) = span (/=',') ame
                                                in I (read n) (read $ drop 1 i)
                                        | otherwise -> ERROR (fname ++ " not found")

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
                                | otherwise = ["ERROR" , "what is " ++ t]

        initial :: [Char] -> [String]
        initial (c:cs)
            | (c:cs) == "O" = ["O"]
            | (c:cs) == "S" = ["S"]
            | c == 'I' =
                if head (projection cs)  == 'E' then ["ERROR" , drop 1 $ projection cs]
                else ["I" ++ projection cs]
            | all ((||) <$> isDigit <*> isLower) (c:cs) = [c:cs]
            | otherwise = ["ERROR", (c:cs) ++ " is not initial function or function name"]
        initial [] = []

        projection :: [Char] -> [Char]
        projection cs =
            let (sup,n,sub,i) = (L.take 1 cs, takeWhile ((||) <$> isDigit <*> isLower) (drop 1 cs), L.take 1 $ dropWhile (/='_') cs, tail $ dropWhile (/='_') cs )
                in if sup == "^" && all isDigit n && sub == "_" && all isDigit i && n /= [] && i /= []
                                        then
                                        let (n', i') = (read n :: Int, read i :: Int)
                                        in
                                            if n' >= i' && n' > 0 && i' > 0
                                            then  n++ "," ++i
                                            else "E" ++  ("your index wrong: " ++ "i= " ++ i ++ ", n= " ++ n )
                                    else "E" ++ ("your projection is not ^[0-9]_[0-9], it is " ++ cs)

        composition :: [Char] -> [String]
        composition str = let (s1, s2) = span (/=',') str
                        in if s1 /= [] then initial s1 ++ composition (drop 1 s2)
                                        else []