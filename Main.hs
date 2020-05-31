module Main where

import Data.Text hiding (zipWith, last, init)
import Data.Text.IO
import GHC.IO
import Prelude hiding (readFile, writeFile, putStrLn)

testFileInput :: FilePath
testFileInput = "/home/neo/Forks/plfa.github.io/src/plfa/part1/Naturals.lagda.md"

testFileOutput :: FilePath
testFileOutput = "/home/neo/Forks/plfa.github.io/src/plfa/part1/Naturals.lagda"

main :: IO ()
main = do
  fileText <- readFile testFileInput
  writeFile testFileOutput $ convertText fileText

-- TODO getAllFilesFromFolderWithExtension ::

--  HACK that does the job
convertText :: Text -> Text
convertText txt = conv
  where
    splits = splitOn "```\n" txt
    alternateCodeBlocks = Prelude.concat $ repeat (["\\begin{code}\n", "\\end{code}\n"])
    conv = convert splits alternateCodeBlocks

convert :: [Text] -> [Text] -> Text
convert splits alternateCodeBlocks = res
  where
    texts = Prelude.concat $ zipWith (\a b -> [a, b]) splits alternateCodeBlocks
    res = Data.Text.concat $ if last texts == "\\begin{code}\n" then init texts else texts