module Main where

import Control.Monad (return)
import Data.Text (Text)
import qualified Data.Text as DT
import Data.Text.IO (readFile, writeFile, putStrLn)
import GHC.IO
import Prelude (concat, zipWith, last, init, repeat, ($), (==))

-- testFileInput :: FilePath
-- testFileInput = "/home/neo/Forks/plfa.github.io/src/plfa/part1/NaturalsRen.lagda.md"
--
-- testFileOutput :: FilePath
-- testFileOutput = "/home/neo/Forks/plfa.github.io/src/plfa/part1/Naturals.lagda"

main :: IO ()
main = do
  -- * find all files with .lagda.md extension under a folder
  -- * read content of all those files as Text
  -- and store both read location and content
  -- * fmap previous to a write location and converted content
  -- * write previous to respective files
  return ()

  -- fileText <- readFile testFileInput
  -- writeFile testFileOutput $ convertText fileText

-- TODO getAllFilesFromFolderWithExtension ::

--  HACK that does the job
convertText :: Text -> Text
convertText txt = conv
  where
    splits = DT.splitOn "```\n" txt
    alternateCodeBlocks = Prelude.concat $ repeat (["\\begin{code}\n", "\\end{code}\n"])
    conv = convert splits alternateCodeBlocks

convert :: [Text] -> [Text] -> Text
convert splits alternateCodeBlocks = res
  where
    texts = Prelude.concat $ zipWith (\a b -> [a, b]) splits alternateCodeBlocks
    res = DT.concat $ if last texts == "\\begin{code}\n" then init texts else texts