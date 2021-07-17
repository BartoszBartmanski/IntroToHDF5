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

	// Reading data
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

    // Writing data using HighFive package
    H5Easy::File file2(argv[2], H5Easy::File::Overwrite);

    int a = 10;
    H5Easy::dump(file2, "int", a);

    std::vector<int> b = {1, 2, 5};
    H5Easy::dump(file2, "array", b);

	std::vector<std::string> c = {
        "Hello World !", 
        "This string list is mapped to a dataset of variable length string"
    };
	HighFive::DataSet dataset = file2.createDataSet<std::string>(
            "strings", HighFive::DataSpace::From(c));
    dataset.write(c);

}
