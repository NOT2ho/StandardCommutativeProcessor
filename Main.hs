module Main where

import SCP_0
import SCP_1
import Numbering
import System.IO



main :: IO ()
main =  do
    hSetBuffering stdin NoBuffering
    hSetBuffering stdout NoBuffering
    putStr "0 to scp-0, 1 to scp-1, else to numbering: "
    num <- read <$> getLine
    if num == 0 then do SCP_0.main
    else if num == 1 then do SCP_1.main 
    else do Numbering.main