{-# LANGUAGE StaticPointers #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Control.Distributed.Spark as S
import Control.Monad
import Data.ByteString (ByteString, count, pack)
import Data.Int

main :: IO ()
main = do
  conf <- S.newSparkConf "Example"
  sc <- S.newSparkContext conf
  rdd0 <- S.binaryRecords sc "some.data" (fromIntegral blockSize)
  rdd1 <- S.map (S.closure $ static countZero) rdd0
  res <- S.reduce (S.closure $ static (+)) rdd1
  putStrLn $ ">>> Found " ++ show res ++ " bytes equal to 0"


countZero :: ByteString -> Int32
countZero = fromIntegral . count 0

blockSize :: Int
blockSize = 64000
