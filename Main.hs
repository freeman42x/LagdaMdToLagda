module Main where

import Data.Text hiding (zipWith)
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

convertText :: Text -> Text
convertText txt = txt
  where
    splits = splitOn "```\n" txt
    alternateCodeBlocks = Prelude.concat $ repeat (["\\begin{code}", "\\end{code}"])
    conv = undefined

convert :: [Text] -> [Text] -> Text
convert splits alternateCodeBlocks =
  Data.Text.concat $ Prelude.concat
    $ zipWith (\a b -> [a, b]) splits alternateCodeBlocks