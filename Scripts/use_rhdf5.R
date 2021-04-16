#!/usr/bin/env Rscript

library(rhdf5)

example1 <- function(filename) {
    # First, we try saving very simple data to hdf5 format

    h5createFile(filename)
    
    # A vector
    a <- c(1.0, 2.0, 5.0)
    h5write(a, filename, "A")
    
    # A matrix
    b <- rbind(c(1, 2), c(2, 3))
    h5write(b, filename, "B")
    
    # A vector of strings
    c <- c("hello", "world", "foofoofoo", "barbarbarbar")
    h5write(c, filename, "C")

    d <- rbind(c(FALSE, TRUE),
               c(TRUE, FALSE),
               c(TRUE, FALSE))
    h5write(d, filename, "D")
    
    h5closeAll()
}


example2 <- function(filename) {
    # Second, a more complicated example
    
    ## Writing to HDF5 format
    h5createFile(filename)
    h5createGroup(filename,"foo")
    h5createGroup(filename,"baa")
    h5createGroup(filename,"foo/foobaa")
    
    A = matrix(1:10,nr=5,nc=2)
    h5write(A, filename, "foo/A")
    
    B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
    attr(B, "scale") <- "liter"
    h5write(B, filename, "foo/B")
    
    C = matrix(paste(LETTERS[1:10],LETTERS[11:20], collapse=""), nr=2,nc=5)
    h5write(C, filename, "foo/foobaa/C")
    
    df = data.frame(1L:5L,seq(0,1,length.out=5),
                      c("ab","cde","fghi","a","s"), stringsAsFactors=FALSE)
    h5write(df, filename, "df")
    
    h5closeAll()
    
    
    ## Reading data from HDF5 format
    fh = H5Fopen(filename)
    
    print("Dataframe generated within the script:")
    print(df)
    print("Dataframe from the hdf5 file:")
    print(fh$"df")
}

args <- commandArgs(trailingOnly=TRUE)
example1(args[1])
example2(args[2])

