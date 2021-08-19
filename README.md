# IntroToHDF5

Small introduction on how to work with the HDF5 format 
within Python, R and C++ programming languages.

Documentation on [h5py] and [rhdf5].

[h5py]: https://docs.h5py.org/en/stable/quick.html
[rhdf5]: https://bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.html

## Requirements

To use HighFive library (for reading and writing of 
HDF5 files in C++) need to install (through `apt` 
tool in Ubuntu):
* libboost-serialization1.71-dev
* libboost-system1.71-dev
* libboost1.71-dev
* libhdf5-dev
* hdf5-helpers
* hdf5-tools

To reproduce anything in this repository, first 
create the conda environment from `conda_env_simple.yml`:
```
conda env create -n test_hdf5 -f conda_env_simple.yml
```
If conda is not installed, follow the installation 
instructions [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/#regular-installation).

Then activate the conda enviornment:
```
conda activate test_hdf5
```
and execute the following command:
```
make all
```

# h5py package (Python)


```python
%load_ext rpy2.ipython
import h5py
import numpy as np
from os import path, makedirs
import pandas as pd


if not path.isdir("Output"): makedirs("Output")
```

Writing to an hfd5 file:


```python
fname = "Output/h5py_test.h5"

with h5py.File(fname, "w") as fh:
    fh.create_dataset("int", data=1)
    fh.create_dataset("string", data="test")
    fh.create_dataset("array", data=[0, 10, 5])
    fh.create_dataset("strings", data=["hello", "world"])

df = pd.DataFrame([["a", 1], ["b", 2]], columns=["letter", "number"])
df.to_hdf(fname, "df")
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>letter</th>
      <th>number</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div>



Reading from an hdf5 file:


```python
with h5py.File(fname) as fh:
    print(fh.keys())
    print(fh["int"][()])
    print(fh["string"][()].decode("UTF-8"))
    print(fh["array"][:])
    print([x.decode("UTF-8") for x in fh["strings"][()]])
pd.read_hdf(fname, "df")
```

    <KeysViewHDF5 ['array', 'df', 'int', 'string', 'strings']>
    1
    test
    [ 0 10  5]
    ['hello', 'world']





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>letter</th>
      <th>number</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>a</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div>



**Note**: Pandas dataframes can be saved and read from an hdf5 file, but through pandas' own API, not through h5py.

# rhdf5 package (R)


```r
%%R
library(rhdf5)
```

Writing to an hdf5 file:


```r
%%R

fname <- "Output/rhdf5_test.h5"
if (file.exists(fname)) { file.remove(fname) } 

h5createFile(fname)
h5write(42, fname, "int")
h5write("test", fname, "string")
h5write(c(1.0, 2.0, 5.0), fname, "vector")
strings <- c("hello", "world", "foofoofoo", "barbarbarbar")
h5write(strings, fname, "strings")

d <- rbind(c(FALSE, TRUE),
           c(TRUE, FALSE),
           c(TRUE, FALSE))
h5write(d, fname, "rectangular_matrix")

name <- c("Jon", "Bill", "Maria", "Ben", "Tina")
age <- c(23, 41, 32, 58, 26)
df <- data.frame(name, age)
h5write(df, fname, "df")

h5closeAll()
```

Reading from an hdf5 file:


```r
%%R

fh = H5Fopen(fname)
print(fh)
print(fh$"int")
print(fh$"string")
print(fh$"vector")
print(fh$"strings")
print(fh$"rectangular_matrix")
print(fh$"df")
h5closeAll()
```

    HDF5 FILE 
            name /
        filename 
    
                    name       otype   dclass   dim
    0 df                 H5I_DATASET COMPOUND 5    
    1 int                H5I_DATASET FLOAT    1    
    2 rectangular_matrix H5I_DATASET INTEGER  3 x 2
    3 string             H5I_DATASET STRING   1    
    4 strings            H5I_DATASET STRING   4    
    5 vector             H5I_DATASET FLOAT    3    
    [1] 42
    [1] "test"
    [1] 1 2 5
    [1] "hello"        "world"        "foofoofoo"    "barbarbarbar"
          [,1]  [,2]
    [1,] FALSE  TRUE
    [2,]  TRUE FALSE
    [3,]  TRUE FALSE
       name age
    1   Jon  23
    2  Bill  41
    3 Maria  32
    4   Ben  58
    5  Tina  26


Data in an hdf5 file created in one language can be read in another language, but we need to be careful, as shown later


```python
with h5py.File("Output/rhdf5_test.h5") as fh:
    print(fh.keys())
    print(fh["int"][0])
    print(fh["string"][0].decode("UTF-8"))
    print(fh["vector"][:])
    print([x.decode("UTF-8") for x in fh["strings"]])
    df = pd.DataFrame(np.array(fh["df"]))
    df["name"] = df["name"].apply(lambda x : x.decode("UTF-8"))
    print(df)
```

    <KeysViewHDF5 ['df', 'int', 'rectangular_matrix', 'string', 'strings', 'vector']>
    42.0
    test
    [1. 2. 5.]
    ['hello', 'world', 'foofoofoo', 'barbarbarbar']
        name   age
    0    Jon  23.0
    1   Bill  41.0
    2  Maria  32.0
    3    Ben  58.0
    4   Tina  26.0


**Important**: `rhdf5` package saves matrices transposed, which is explained in `rhdf5` docs [here](https://bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.html#reading-hdf5-files-with-external-software). If we open matrix D in `rhdf5_test.h5` in Python:


```python
with h5py.File("Output/rhdf5_test.h5") as fh:
    print(fh["rectangular_matrix"][:])
```

    [[0 1 1]
     [1 0 0]]


The matrix `rectangular_matrix`, when read in Python is transposed and boolean entries have been changed to integers. We can observe the same behaviour when opening a file created by `rhdf5` package within C++. This happens because `rhdf5` "This is due to the fact the fastest changing dimension on C is the last one, but on R it is the first one (as in Fortran)." based on `rhdf5` documentation.


```r
%%R
fh = H5Fopen("Output/rhdf5_test.h5")
print(fh$"rectangular_matrix")
h5closeAll()
```

          [,1]  [,2]
    [1,] FALSE  TRUE
    [2,]  TRUE FALSE
    [3,]  TRUE FALSE


Lists and vectors from R saved in hdf5 file:


```r
%%R 

fname <- "Output/rhdf5_test2.h5"
if (file.exists(fname)) { file.remove(fname) } 

h5createFile(fname)

num <- 10
a <- rep(1, num)
names(a) <- paste0("M", 1:num)
print(a)  # names in a vector are not saved into hdf5 format (see below)
h5write(a, fname, "a")

b <- list(M1=1, M2=1)
h5write(b, fname, "b")

num <- 10
c <- as.list(rep(1, num))
names(c) <- paste0("M", 1:num)
h5write(c, fname, "c")
```

     M1  M2  M3  M4  M5  M6  M7  M8  M9 M10 
      1   1   1   1   1   1   1   1   1   1 



```r
%%R

fh = H5Fopen(fname)
print("a = ")
print(fh$"a")
print("b = ")
print(fh$"b")
print("c = ")
print(fh$"c")
h5closeAll()
```

    [1] "a = "
     [1] 1 1 1 1 1 1 1 1 1 1
    [1] "b = "
    $M1
    [1] 1
    
    $M2
    [1] 1
    
    [1] "c = "
    $M1
    [1] 1
    
    $M10
    [1] 1
    
    $M2
    [1] 1
    
    $M3
    [1] 1
    
    $M4
    [1] 1
    
    $M5
    [1] 1
    
    $M6
    [1] 1
    
    $M7
    [1] 1
    
    $M8
    [1] 1
    
    $M9
    [1] 1
    


We can also read R's lists and vectors in python with `h5py` module:


```python
with h5py.File("Output/rhdf5_test2.h5") as fh:
    print(fh["a"][:])
    print({x: fh["b"][x][0] for x in fh["b"].keys()})
    print({x: fh["c"][x][0] for x in fh["c"].keys()})
```

    [1. 1. 1. 1. 1. 1. 1. 1. 1. 1.]
    {'M1': 1.0, 'M2': 1.0}
    {'M1': 1.0, 'M10': 1.0, 'M2': 1.0, 'M3': 1.0, 'M4': 1.0, 'M5': 1.0, 'M6': 1.0, 'M7': 1.0, 'M8': 1.0, 'M9': 1.0}


# HighFive package (C++)

Below is the C++ code on how to read and write hdf5 format:


```python
from IPython.display import Markdown as md

with open("src/test_highfive.cpp") as fh:
    cpp_file = fh.read()
md(f"```C++\n{cpp_file}```")
```




```C++
#include <highfive/H5Easy.hpp>
#include <highfive/H5DataSet.hpp>
#include <highfive/H5DataSpace.hpp>

#include <string>
#include <vector>
#include <iostream>


template <typename T>
std::ostream& operator<<(std::ostream& os, const std::vector<T>& v) {
    os << "[";
    for (int i = 0; i < v.size(); ++i) {
        os << v[i];
        if (i != v.size() - 1)
            os << ", ";
    }
    os << "]";
    return os;
}

template <typename T>
std::ostream& operator<<(std::ostream& os, const std::vector<std::vector<T>>& m) {
    for (const auto& row : m) {
        os << row;
    }
    return os;
}


int main(int argc, char** argv) {

	// Reading data generated in python
    std::cout << "--- Reading data generated in python ---" 
        << std::endl << std::endl;

    H5Easy::File file1(argv[1], H5Easy::File::ReadOnly);

    auto val_int = H5Easy::load<int>(file1, "int");
    std::cout << "int = " << val_int << std::endl;

    auto val_string = H5Easy::load<std::string>(file1, "string");
    std::cout << "string = " << val_string << std::endl;

    auto val_array = H5Easy::load<std::vector<int>>(file1, "array");
    std::cout << "array = " << val_array << std::endl;

    // Reading in a vector of strings is a bit more complicated
    std::vector<std::string> val_strings;
    auto data = file1.getDataSet("strings");
    std::cout << H5Easy::getShape(file1, "strings")[0] << " elements of type " 
        << data.getDataType().string() << std::endl;
    data.read(val_strings);
    std::cout << "strings = ";
    for (auto& elem : val_strings) {
        std::cout << elem << ", ";
    }
    std::cout << std::endl;

    // Reading data generated in R
    std::cout << std::endl << "--- Reading data generated in R ---" 
        << std::endl << std::endl;
    H5Easy::File file2(argv[2], H5Easy::File::ReadOnly);

    auto val_int2 = H5Easy::load<int>(file2, "int");
    std::cout << "int = " << val_int2 << std::endl;

    auto val_string2 = H5Easy::load<HighFive::FixedLenStringArray<10>>(file2, "string");
    std::cout << "string = " << val_string2.getString(0) << std::endl;

    auto val_array2 = H5Easy::load<std::vector<double>>(file2, "array");
    std::cout << "array = " << std::endl << val_array2 << std::endl;

    auto val_strings2 = H5Easy::load<HighFive::FixedLenStringArray<10>>(file2, "strings");
    std::cout << "strings = ";
    for (auto& elem : val_strings2) { std::cout << std::string(elem.data()) << ", "; }
    std::cout << std::endl;

    auto val_matrix = H5Easy::load<std::vector<std::vector<int>>>(file2, "rectangular_matrix");
    std::cout << "rectangular_matrix = " << std::endl;
    for (auto& row : val_matrix) { std::cout << row << std::endl; }

    // Writing data using HighFive package
    H5Easy::File file3(argv[3], H5Easy::File::Overwrite);

    int a = 10;
    H5Easy::dump(file3, "int", a);

    std::vector<int> b = {1, 2, 5};
    H5Easy::dump(file3, "array", b);

	std::vector<std::string> c = {
        "Hello World !", 
        "This string list is mapped to a dataset of variable length string"
    };
	HighFive::DataSet dataset = file3.createDataSet<std::string>(
            "strings", HighFive::DataSpace::From(c));
    dataset.write(c);

}
```



We can open `hdf5` files generated in C++, using `HighFive` package, like so:


```python
with h5py.File("Output/test_highfive.h5") as fh:
    print(fh.keys())
    print(fh["int"][()])
    print(fh["array"][:])
    print([x.decode("UTF-8") for x in fh["strings"]])
```

    <KeysViewHDF5 ['array', 'int', 'strings']>
    10
    [1 2 5]
    ['Hello World !', 'This string list is mapped to a dataset of variable length string']

