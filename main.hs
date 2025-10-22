{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
main :: IO ()
main = pure ()

type NUM = Int


s :: NUM -> NUM
s = (+ 1)

o :: NUM -> NUM
o x = 0

ini :: NUM -> NUM -> ([NUM] -> NUM)
ini n i l = if length l == n then  l !! i else error "your fault"

prec ::  [NUM] -> ([NUM] -> NUM) -> ([NUM] -> NUM) -> NUM
prec x' p c = let (xs,x) = (init x', last x') in
    if x == 0 then p xs
    else c (xs ++ [x-1] ++ [prec (xs ++ [x-1]) p c])

mrec :: [NUM] -> ([NUM] -> NUM) -> NUM
mrec x p = let mu y = if p (x ++ [y]) == 0 then y
                    else mu (y+1)
            in mu 0
