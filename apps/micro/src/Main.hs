{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE StaticPointers #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Control.Distributed.Spark as S
import Control.Monad
import Data.Int
import System.Environment

main :: IO ()
main = do
  (n, nbPartitions) <- parseArgs
  conf <- S.newSparkConf "sparkle micro benchmark"
  sc <- S.newSparkContext conf
  rdd0 <- S.parallelize sc (dataset n)
      >>= S.repartition nbPartitions
  rdd1 <- S.map (S.closure $ static succ) rdd0
  -- just so that we actually force the call to map
  res <- S.collect rdd1
  print (head res)

parseArgs :: IO (Int32, Int32)
parseArgs = (,) <$> fmap read (getEnv "DATASET_SIZE")
                <*> fmap read (getEnv "DATASET_PARTITIONS")

dataset :: Int32 -> [Int32]
dataset n = [0 .. n]
