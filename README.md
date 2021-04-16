# HDF5

This repository is about testing how to work with HDF5 format, within Python, R and C++ programming languages.

Documentation on [h5py] and [rhdf5].

[h5py]: https://docs.h5py.org/en/stable/quick.html
[rhdf5]: https://bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.html

## Requirements

To use HighFive library (for reading and writing of HDF5 files in C++) need to install (through `apt` tool in Ubuntu):
* libboost-serialization1.71-dev
* libboost-system1.71-dev
* libboost1.71-dev
* libhdf5-dev
* hdf5-helpers
* hdf5-tools


# h5py package (Python)


```python
%load_ext rpy2.ipython
import h5py
import numpy as np
```

    /home/bartosz/.miniconda3/envs/test_hdf5/lib/python3.7/site-packages/rpy2/ipython/rmagic.py:77: UserWarning: The Python package `pandas` is strongly recommended when using `rpy2.ipython`. Unfortunately it could not be loaded (error: No module named 'pandas'), but at least we found `numpy`.
      'but at least we found `numpy`.' % str(ie))


We can read the output of `use_h5py.py` script as follows:


```python
with h5py.File("Output/h5py_test.h5") as fh:
    print(fh.keys())
    print(fh["array"][:])
    print(fh["int"][()])
    print(fh["string"][()].decode("UTF-8"))
    print([x.decode("UTF-8") for x in fh["strings"][()]])
```

    <KeysViewHDF5 ['array', 'int', 'string', 'strings']>
    [ 0 10  5]
    1
    test
    ['hello', 'world']


# rhdf5 package (R)

We can open data saved by `rhdf5` package within Python like so:


```python
fname = "Output/rhdf5_test1.h5"
with h5py.File(fname) as fh:
    print(fh.keys())
    print(*[(x, fh[x][()]) for x in fh], sep="\n")
```

    <KeysViewHDF5 ['A', 'B', 'C', 'D']>
    ('A', array([1., 2., 5.]))
    ('B', array([[1., 2.],
           [2., 3.]]))
    ('C', array([b'hello', b'world'], dtype='|S5'))
    ('D', array([[0, 1, 1],
           [1, 0, 0]], dtype=int8))



```python
fname = "Output/rhdf5_test2.h5"
with h5py.File(fname) as fh:
    print(fh.keys())
    print(fh["foo"].keys())
    print(fh["foo/A"][:])
    print(fh["df"][:])
```

    <KeysViewHDF5 ['baa', 'df', 'foo']>
    <KeysViewHDF5 ['A', 'B', 'foobaa']>
    [[ 1  2  3  4  5]
     [ 6  7  8  9 10]]
    [(1, 0.  , b'ab') (2, 0.25, b'cde') (3, 0.5 , b'fghi') (4, 0.75, b'a')
     (5, 1.  , b's')]


Or natively in R like so:


```r
%%R
library(rhdf5)

fname <- "Output/rhdf5_test2.h5"
fh = H5Fopen(fname)
print(fh)
print(fh$"df")
h5closeAll()
```

    HDF5 FILE 
            name /
        filename 
    
      name       otype   dclass dim
    0  baa H5I_GROUP               
    1  df  H5I_DATASET COMPOUND   5
    2  foo H5I_GROUP               
      X1L.5L seq.0..1..length.out...5. c..ab....cde....fghi....a....s..
    1      1                      0.00                               ab
    2      2                      0.25                              cde
    3      3                      0.50                             fghi
    4      4                      0.75                                a
    5      5                      1.00                                s


**Important**: `rhdf5` package saves matrices transposed, which is explained in `rhdf5` docs [here](https://bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.html#reading-hdf5-files-with-external-software). If we open matrix D in `rhdf5_test1.h5` in Python:


```python
with h5py.File("Output/rhdf5_test1.h5") as fh:
    print(fh["D"][:])
```

    [[0 1 1]
     [1 0 0]]


And in R:


```r
%%R
fh = H5Fopen("Output/rhdf5_test1.h5")
print(fh$"D")
h5closeAll()
```

          [,1]  [,2]
    [1,] FALSE  TRUE
    [2,]  TRUE FALSE
    [3,]  TRUE FALSE


The matrix D, when read in Python is transposed and boolean entries have been changed to integers. We can observe the same behaviour when opening a file created by `rhdf5` package within C++. This happens because `rhdf5` "This is due to the fact the fastest changing dimension on C is the last one, but on R it is the first one (as in Fortran)." based on `rhdf5` documentation.

# HighFive package (C++)

We can open `hdf5` files generated in C++, using `HighFive` package, like so:


```python
with h5py.File("Output/highfive_test.h5") as fh:
    print(fh["path/to"].keys())
    print(fh["path/to/A"][()])
    print([x.decode("UTF-8") for x in fh["path/to/B"]])
```

    <KeysViewHDF5 ['A', 'B']>
    10
    ['Hello World !', 'This string list is mapped to a dataset of variable length string']

