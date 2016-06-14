{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Distributed.Spark as S

main :: IO ()
main = do
    conf <- newSparkConf "Spark Online Latent Dirichlet Allocation in Haskell!"
    sc   <- getOrCreateSparkContext conf
    sqlc <- getOrCreateSQLContext sc
    stopwords <- textFile sc "s3a://AKIAIKSKH5DRWT5OPMSA:bmTL4A9MubJSV9Xhamhi5asFVllhb8y10MqhtVDD@tweag-sparkle/stopwords.txt" >>= collect
    {-
    docs <- wholeTextFiles sc "s3a://AKIAIKSKH5DRWT5OPMSA:bmTL4A9MubJSV9Xhamhi5asFVllhb8y10MqhtVDD@tweag-sparkle/nyt/"
        >>= justValues
        >>= zipWithIndex
    -}
    docs <- textFile sc "dbfs:/databricks-datasets/wiki/part-*" >>= zipWithIndex
    docsRows <- toRows docs
    docsDF <- toDF sqlc docsRows "docId" "text"
    tok  <- newTokenizer "text" "words"
    tokenizedDF <- tokenize tok docsDF
    swr  <- newStopWordsRemover stopwords "words" "filtered"
    filteredDF <- removeStopWords swr tokenizedDF
    cv   <- newCountVectorizer vocabSize "filtered" "features"
    cvModel <- fitCV cv filteredDF
    countVectors <- toTokenCounts cvModel filteredDF "docId" "features"
    lda  <- newLDA miniBatchFraction numTopics maxIterations
    ldamodel  <- runLDA lda countVectors
    describeResults ldamodel cvModel maxTermsPerTopic

    where numTopics         = 100
          miniBatchFraction = 2/100 + 1/4000000
          vocabSize         = 10000
          maxTermsPerTopic  = 10
          maxIterations     = 100
