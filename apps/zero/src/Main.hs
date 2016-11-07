{-# LANGUAGE StaticPointers #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Distributed.Spark as S
import Control.Exception (bracket)
import Control.Monad
import Data.ByteString as BS
import Data.Int
import System.Directory (doesFileExist)
import System.Environment (getArgs)
import System.IO
import System.Random

main :: IO ()
main = do
  conf <- newSparkConf "Example"
  sc <- getOrCreateSparkContext conf
  rdd0 <- binaryRecords sc "./some.data" (fromIntegral blockSize)
  rdd1 <- S.map (closure $ static countZero) rdd0
  res <- S.reduce (closure $ static (+)) rdd1
  print res

countZero :: ByteString -> Int32
countZero = fromIntegral . BS.count 0

blockSize :: Int
blockSize = 1000000
