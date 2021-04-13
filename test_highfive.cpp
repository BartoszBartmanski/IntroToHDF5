#include <highfive/H5Easy.hpp>
#include <highfive/H5DataSet.hpp>
#include <highfive/H5DataSpace.hpp>

#include <string>
#include <vector>
#include <iostream>

int main() {
    H5Easy::File file("test_highfive.h5", H5Easy::File::Overwrite);

 	// Writing using H5Easy
    int A = 10;
    H5Easy::dump(file, "/path/to/A", A);

	// Writing using HighFive classes
	std::vector<std::string> string_list;
	string_list.push_back("Hello World !");
	string_list.push_back("This string list is mapped to a dataset of "
	                      "variable length string");

	HighFive::DataSet dataset = file.createDataSet<std::string>(
            "/path/to/C", HighFive::DataSpace::From(string_list));

    // let's write our vector of  string
    dataset.write(string_list);

	// To load using H5Easy
	A = H5Easy::load<int>(file, "/path/to/A");

	// Reading in data generated using another package
    H5Easy::File file2("test2_rhdf5.h5", H5Easy::File::ReadOnly);
	auto test = H5Easy::load<std::vector<double>>(file2, "A");
    for (auto& i : test) {
        std::cout << i << std::endl;
    }

    auto test2 = H5Easy::load<std::vector<std::vector<double>>>(file2, "B");
    for (auto& i : test2) {
        for (auto& j : i) {
            std::cout << j << " ";
        }
        std::cout << std::endl;
    }
} 
