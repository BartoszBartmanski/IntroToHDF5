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
    os << "]\n";
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

	// Reading in data generated using rhdf5 package
    H5Easy::File file1(argv[1], H5Easy::File::ReadOnly);
	auto a1 = H5Easy::load<std::vector<double>>(file1, "A");
    std::cout << std::endl << "A = " << a1;

    auto b1 = H5Easy::load<std::vector<std::vector<double>>>(file1, "B");
    std::cout << std::endl << "B = " << b1;

    HighFive::FixedLenStringArray<10> c1;
    file1.getDataSet("C").read(c1);
    std::cout << "C = ";
    for (unsigned i=0; i<c1.size(); i++) {
        std::cout << c1.getString(i) << " ";
    }

    auto d1 = H5Easy::load<std::vector<std::vector<int>>>(file1, "D");
    std::cout << std::endl << "D = " << d1;

    // Writing data using HighFive package
    H5Easy::File file2(argv[2], H5Easy::File::Overwrite);

 	// Writing using H5Easy classes/functions
    int A = 10;
    H5Easy::dump(file2, "/path/to/A", A);

	// Writing using HighFive classes/functions
	std::vector<std::string> string_list = {
        "Hello World !", 
        "This string list is mapped to a dataset of variable length string"
    };
	HighFive::DataSet dataset = file2.createDataSet<std::string>(
            "/path/to/B", HighFive::DataSpace::From(string_list));
    dataset.write(string_list);

	// To load using H5Easy
	auto a2 = H5Easy::load<int>(file2, "/path/to/A");
	std::cout << a2 << std::endl;

}
