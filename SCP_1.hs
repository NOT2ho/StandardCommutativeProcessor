
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# LANGUAGE ParallelListComp #-}

module SCP_1(main, name) where

import Data.List (group, sort, genericLength)
import System.Directory
import System.FilePath
import SCP_0(scp_0)
import Numbering(conaturalizer, name)

main :: IO ()
main = do
    putStrLn "welcome to the scp-1 world"
    currentDir <- getCurrentDirectory
    putStr "input file name: "
    filename <- getLine
    let fileloc = currentDir </> filename
    file <- readFile fileloc
    putStr "output file name(default: txt.txt): "
    filename' <- getLine
    let output =  if null filename' then  currentDir </> "txt.txt" else currentDir </> filename'
    writeFile output $ scp_1 file

scp_1 :: String -> String
scp_1 str = case lines str of
                [alpha, f, s] -> either conaturalizer ("something wrong in scp-0 code. \n" ++) $ scp_0 isName f (counter alpha s)
                _ -> "USER ERROR: input 3 lines"


isName :: Char -> Bool
isName = flip elem name


counter :: String -> String -> [Integer]
counter alpha s = [ genericLength $ filter (==a) s | a <- alpha ]

