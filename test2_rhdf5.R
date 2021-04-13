
library(rhdf5)

name <- "test2_rhdf5.h5"
h5createFile(name)
a <- c(1.0, 2.0, 5.0)
h5write(a, name, "A")
b <- rbind(c(1, 2), c(2, 3))
h5write(b, name, "B")
c <- c("hello", "world")
h5write(c, name, "C")
h5closeAll()
