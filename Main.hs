module Main where

import           Control.Monad
import           Data.Foldable
import           Data.List
import qualified Data.Text                     as DT
import qualified Data.Text.IO                  as DTI
import           GHC.IO
import           Prelude
import           Turtle
import           Turtle.Prelude                as TP
import           System.IO

-- testFileInput :: FilePath
-- testFileInput = "/home/neo/Forks/plfa.github.io/src/plfa/part1/NaturalsXXX.lagda.md"
--
-- testFileOutput :: FilePath
-- testFileOutput = "/home/neo/Forks/plfa.github.io/src/plfa/part1/Naturals.lagda"

main :: IO ()
main = do
  -- * find all files with .lagda.md extension under a folder
  files <- TP.sort
    $ lstree "/home/neo/Forks/plfa.github.io/src/plfa/"
  let lagdaMdFiles = mfilter isLagdaMd $ encodeString <$> files
  conv lagdaMdFiles
    where
      conv = traverse_ convertToLagda
      isLagdaMd = isSuffixOf ".lagda.md"
      convertToLagda filePath = withFile filePath ReadMode $ \handle -> do
        fileContent <- hGetContents handle
        let filePathText = DT.pack filePath
        let lagdaFilePath = DT.unpack $ DT.replace ".lagda.md" ".lagda" filePathText
        let convertedFileContent = convertText $ DT.pack fileContent
        writeFile lagdaFilePath $ DT.unpack convertedFileContent

  -- * read content of all those files as Text
  -- and store both read location and content
  -- * fmap previous to a write location and converted content
  -- * write previous to respective files



--  HACK that does the job
convertText :: Text -> Text
convertText txt = conv
 where
  splits = DT.splitOn "```\n" txt
  alternateCodeBlocks =
    Prelude.concat $ repeat ["\\begin{code}\n", "\\end{code}\n"]
  conv = convert splits alternateCodeBlocks

convert :: [Text] -> [Text] -> Text
convert splits alternateCodeBlocks = res
 where
  texts = Prelude.concat $ zipWith (\a b -> [a, b]) splits alternateCodeBlocks
  res =
    DT.concat $ if last texts == "\\begin{code}\n" then init texts else texts
