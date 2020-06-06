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
import           System.Directory
import           System.IO                     as SI

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
        renameLagdaMdFileAndModule filePathText

renameLagdaMdFileAndModule :: Text -> IO ()
renameLagdaMdFileAndModule filePath = do
  let old = DT.unpack filePath
  let new = DT.unpack $ DT.replace ".lagda.md" "Alternative.lagda.md" filePath
  renameFile old new
  fileContent <- readFile new
  let fileContentText = DT.pack fileContent
  let fileName = fileNameFromPath new
  let replaceOld = fileName <> " where"
  let replaceNew = fileName <> "Alternative where"
  let newFileContent = DT.replace replaceOld replaceNew fileContentText
  writeFile new fileContent

-- renameLagdaMdFileAndModule "/home/neo/Forks/plfa.github.io/src/plfa/part1/Naturals.lagda.md"

fileNameFromPath :: SI.FilePath -> Text
fileNameFromPath filePath = DT.pack fileNameNoExtension
  where
    turtleFilePath = decodeString filePath
    fileName = filename turtleFilePath
    fileNameString = encodeString fileName
    fileNameNoExtension = takeWhile (/= '.') fileNameString

-- fileNameFromPath "/home/neo/Forks/plfa.github.io/src/plfa/part1/Naturals.lagda.md"

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
