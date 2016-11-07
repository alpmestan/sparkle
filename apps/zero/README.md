### Build and package up the Haskell program

``` sh
# see sparkle's root README.md for prerequisites
# then issue this from this repository
$ stack build
$ stack exec -- sparkle package
# creates a "zero.jar" archive in this directory
```

### Build and package up the Java program

``` sh
$ mvn package
# creates a JAR archive in the "target" directory
```

### Running the applications

``` sh
# Haskell version, using 4 cores = 4 spark workers
$ path/to/spark/bin/spark-submit --master local[4] zero.jar

# Java version, 4 cores as well
$ path/to/spark/bin/spark-submit --master local[4] --main Zero target/simple-project-1.0.jar
```
