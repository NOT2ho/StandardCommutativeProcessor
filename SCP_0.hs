{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}


module SCP_0 (scp_0, main) where

import Data.Tree
import Data.Set as S (Set, take, partition, size, elemAt, fromList, map, toList)
import qualified Data.List as L (partition, take, map)
import Data.Char
import Control.Monad
import Data.List (find, dropWhileEnd, stripPrefix)
import Data.Either (fromLeft, isLeft, rights, lefts, fromRight)
import Distribution.Compat.Prelude (readMaybe)
import Text.Read (readEither)
import System.IO
import Data.Bifunctor


-----------------------io-------------------------------


main :: IO ()
main = do
        hSetBuffering stdin NoBuffering
        hSetBuffering stdout NoBuffering
        putStrLn "scpi 0.1.0 https://github.com/NOT2ho/StandardCommutativeProcessor \nwelcome to the scp-0 world. scpi will run forever"
        putStrLn "* not stable version"
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
        prec' p' c' [] = Right "empty input in primitive recursion"
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
                INIT (ERROR e) -> const (Right e)
                _ -> eval pt


eval :: Node Init -> F
eval n = case n of

    COMP g cs -> comp (eval g) (L.map eval cs)
    PREC g c -> prec (eval g) (eval c)
    MU c -> mrec (eval c)
    INIT init   ->
        case init of
                    O -> o
                    S n -> sn n
                    I n i -> ini n i
                    ERROR s -> const (Right s)
                    where
                        sn :: N -> F
                        sn 0 x = o x
                        sn 1 x = s x
                        sn n x = case s x of
                            Left num -> sn (n-1) [num]
                            Right e -> s x

-------------------------parser----------------------

data Node a
    = COMP (Node a) [Node a]
    | PREC (Node a)  (Node a)
    | MU (Node a)
    | ROOT (Node a)
    | INIT Init
    deriving (Functor, Show)

data Init
    = O
    | S N
    | I N N
    | ERROR String
    deriving (Show)


parseTree :: String -> Node Init
parseTree = subparseTree . fromList . parser
    where
        subparseTree :: Set [String] -> Node Init
        subparseTree set = let (root, es) = S.partition (\x -> drop 1 x == ["root"]) set
                        in case () of
                                    ()  | size root == 1 -> ROOT (nodes (head $ elemAt 0 root) $ toList es)
                                        | size root == 0 -> ROOT (INIT $ ERROR "why root do not uniquely exist: no root" )
                                        | size root > 1 ->  ROOT (INIT $ ERROR ("why root do not uniquely exist: "++ init (concatMap (++",") (toList (S.map head root)))))


        nodes :: String -> [[String]] -> Node Init
        nodes [] s = case find ("ERROR" `elem`) s of
                        Just e -> INIT $ ERROR (dropWhile (/="ERROR") e !! 1)
                        Nothing ->  INIT $ ERROR "empty function name not allowed"
        nodes fname s= case find ("ERROR" `elem`) s of
                        Just e -> INIT $ ERROR (dropWhile (/="ERROR") e !! 1)
                        Nothing ->
                            let (fs, others) = L.partition (\x -> head x == fname) s
                                in case fs of
                                    [f1,f2]     | length f1 < 3 || length f2 < 3 -> INIT $ ERROR "what do you want to do"
                                                | f1 !! 1 == "PREC0" && f2 !! 1 == "PREC1"
                                                    -> PREC (comper f1) (comper f2)
                                                | f2 !! 1 == "PREC0" &&  f1 !! 1 == "PREC1"
                                                    -> PREC (comper f2) (comper f1)
                                                | otherwise -> INIT $ ERROR ("your primitive recursion wrong: " ++ show fs)
                                                where comper a = if a !! 2 /= "COMP"
                                                        then nodes (a !! 2) others else compTree (drop 2 a) others

                                    [f]         | length f < 3 -> INIT $ ERROR "what do you want to do"
                                                | f !! 1 == "COMP" -> compTree (drop 2 f) others
                                                | f !! 1 == "MU" -> MU (nodes (f!! 2) others)
                                                | f !! 1 == "DEF" -> nodes (f!!2) others


                                    _
                                                | fname == "O" -> INIT O
                                                | fname /= [] && head fname == 'I' ->
                                                    let (fn:ame) = fname
                                                    in let (n, i) = span (/=',') ame
                                                        in INIT $ I (read n) (read $ drop 1 i)
                                                | fname /= [] && head fname == 'S' -> INIT $  S (read $ drop 1 fname)
                                                | otherwise -> INIT $ ERROR (fname ++ " not found")

                            where   compTree :: [String] -> [[String]] -> Node Init
                                    compTree ("COMP":ss:sss) other  = COMP (nodes ss other) (subCompTree sss other)
                                    compTree s _ = INIT $ ERROR (show s ++ " ?")


                                    initial fname       | fname == "O" = O
                                                        | fname /= [] && head fname == 'I' =
                                                            let (fn:ame) = fname
                                                            in let (n, i) = span (/=',') ame
                                                                in I (read n) (read $ drop 1 i)
                                                        | fname /= [] && head fname == 'S' = S (read $ drop 1 fname)
                                                        | otherwise = ERROR (fname ++ " not found")

                                    subCompTree :: [String] -> [[String]] ->  [Node Init]
                                    subCompTree ("COMP":s:ss) other =  [compTree ("COMP":s:ss) other]
                                    subCompTree (s:ss) other =  nodes s other : subCompTree ss other
                                    subCompTree [] _ = []


isName :: Char -> Bool
isName =(\x y z -> x || y || z) <$> isDigit <*> isLower <*> flip elem ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '+', '_', '/', '\\', '?', '\"', '\'', '{', '}', '`', '~', ';']

parser :: String -> [[String]]
parser s = L.map subparser (words (L.map (\x -> if x == '\n' then ' ' else x) s))
        where
        subparser :: String -> [String]
        subparser s = let (fname, s') = span isName s
                    in let (nodetype, s'') = break ((||) <$> isName <*> isAlpha) s'
                    in fname : node nodetype s''
                        where node t strs
                                | t == "" = []
                                | t == ">" = "COMP": compParse strs
                                | t == "|>" = "PREC0" : compParse strs
                                | t == "|>>" = "PREC1" : compParse strs
                                | t == "<" = "MU" : compParse strs
                                | t == ":=" = "DEF" : initial strs
                                | t == ":" = ["root"]
                                | t == "|" = precParse strs
                                | otherwise = ["ERROR" , "what is " ++ t]

        precParse :: [Char] -> [String]
        precParse [] = ["ERROR", "primitive recursion syntax wrong"]
        precParse [a] = if a == '>' then  ["ERROR", "empty primitive recursion"] else  ["ERROR", "primitive recursion syntax wrong, where is >"]
        precParse s = if s == ">>" then ["ERROR", "empty primitive recursion"] else
                        let (c,cl, ll) = (init (init s), last (init s) , last s)
                        in case () of
                            ()  | cl == '>' && ll == '>'  && ((||) <$> all isName <*> all isUpper ) c -> "PREC1" : initial c
                                | ll == '>' && ((||) <$> all isName <*> all isUpper ) (cl:c) -> "PREC0" : initial (c ++ [cl])
                                | all isName c -> ["ERROR", "primitive recursion syntax wrong, where is >"]
                                | head (initial s) == "ERROR" -> ["ERROR", "you can't use composition directly in |>"]
                                | otherwise -> ["ERROR", "what do you want to do in primitive recursion"]

        compParse:: [Char] -> [String]
        compParse [] = []
        compParse cs = if dropWhile (/='.') cs /= []
                            then "COMP" :  compParse (takeWhile (/='.') cs) ++ composition (drop 1 $ dropWhile (/='.') cs)
                            else initial cs

        initial :: [Char] -> [String]
        initial (c:cs)
            | (c:cs) == "O" = ["O"]
            | c == 'S' = if head (successor cs)  == 'E' then ["ERROR" , drop 1 $ successor cs]
                              else ["S" ++ successor cs]
            | c == 'I' =
                if head (projection cs)  == 'E' then ["ERROR" , drop 1 $ projection cs]
                else ["I" ++ projection cs]
            | null (c:cs) = ["ERROR", "empty function name not allowed (in initial)"]
            | all isName (c:cs) = [c:cs]
            | otherwise = ["ERROR", (c:cs) ++ " is not initial function or function name"]
        initial [] = []

        successor :: [Char] -> [Char]
        successor [] = "1"
        successor cs =
            let (sup,n, r) = (L.take 1 cs, takeWhile isDigit (drop 1 cs), dropWhile isDigit $ drop 1 cs)
                in if sup == "^" && null r
                                        then n
                                    else "E" ++ ("your successor is not (^[0,9]*)?, it is " ++ cs)


        projection :: [Char] -> [Char]
        projection [] = "E" ++ "your projection is not ^[0-9]*_[0-9]*, it is empty"
        projection cs =
            let (sup,n,sub,i) = (L.take 1 cs, takeWhile isDigit (drop 1 cs), L.take 1 $ dropWhile (/='_') cs, tail $ dropWhile (/='_') cs )
                in if sup == "^" && all isDigit n && sub == "_" && all isDigit i && n /= [] && i /= []
                                        then
                                        let (n', i') = (read n :: Integer, read i :: Integer)
                                        in
                                            if n' >= i' && n' > 0 && i' > 0
                                            then  n++ "," ++i
                                            else "E" ++  ("your index wrong: " ++ "i= " ++ i ++ ", n= " ++ n )
                                    else "E" ++ ("your projection is not ^[0-9]*_[0-9]*, it is " ++ cs)


        composition :: [Char] -> [String]
        composition str = let (s1, s2) = span (/=',') str
                          in if s1 /= [] then compParse s1 ++ composition (drop 1 s2)
                                        else []