module Main where

import Data.Text
import Data.Text.IO
import GHC.IO
import Prelude hiding (readFile, writeFile, putStrLn)

main :: IO ()
main = do
  fileText <- readFile testFileInput
  writeFile testFileOutput "42"

-- getAllFilesFromFolderWithExtension ::

testFileInput :: FilePath
testFileInput = "/home/neo/Forks/plfa.github.io/src/plfa/part1/Naturals.lagda.md"

testFileOutput :: FilePath
testFileOutput = "/home/neo/Forks/plfa.github.io/src/plfa/part1/Naturals.lagda"

convertFile :: Text -> Text
convertFile content = "result"

convertText :: Text -> Text
convertText txt = undefined

testConvert = convertFile "42"

testReadFile = readFile testFileInput