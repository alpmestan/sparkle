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
  conf <- S.newSparkConf "sparkle micro benchmark"
  sc <- S.newSparkContext conf
  (n, nbPartitions) <- parseArgs
  rdd0 <- S.parallelize sc (dataset n)
      >>= S.repartition nbPartitions
  rdd1 <- S.map (S.closure $ static succ) rdd0
  -- just so that we actually force the call to map
  res <- S.collect rdd1
  print (head res)

parseArgs :: IO (Int32, Int32)
parseArgs = getArgs >>= \case
  [nstr, nbpartStr] -> return (read nstr, read nbpartStr)
  _                 ->
    error "Please specify a dataset size and the number of partitions it should be split into"

dataset :: Int32 -> [Int32]
dataset n = [0 .. n]
