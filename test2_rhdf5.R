
library(rhdf5)

name <- "test2_rhdf5.h5"
h5createFile(name)
A <- c(1.0, 2.0, 5.0)
h5write(A, name, "A")
h5closeAll()
