#!/usr/bin/env Rscript

library(rhdf5)


args <- commandArgs(trailingOnly=TRUE)
fname <- args[1]

h5createFile(fname)
h5write(42, fname, "int")
h5write("test", fname, "string")
h5write(c(1.0, 2.0, 5.0), fname, "array")
strings <- c("hello", "world")
h5write(strings, fname, "strings")

d <- rbind(c(FALSE, TRUE),
           c(TRUE, FALSE), 
           c(TRUE, FALSE))
h5write(d, fname, "rectangular_matrix")

h5closeAll()
