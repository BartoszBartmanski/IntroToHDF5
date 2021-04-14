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
    std::cout << std::endl << "A = " << std::endl;
	auto test = H5Easy::load<std::vector<double>>(file2, "A");
    for (auto& i : test) {
        std::cout << i << std::endl;
    }

    auto test2 = H5Easy::load<std::vector<std::vector<double>>>(file2, "B");
    std::cout << std::endl << "B = " << std::endl;
    for (auto& i : test2) {
        for (auto& j : i) {
            std::cout << j << " ";
        }
        std::cout << std::endl;
    }

    // Testing picking columns from matrix based on a condition
    std::vector<int> cond = {1, 0};

    std::vector<std::vector<double>> new_mat;
    for (const auto& row : test2) {
        std::vector<double> temp;
        for (unsigned i=0; i < row.size(); i++) {
            if (cond[i] != 0) {
                temp.push_back(row[i]);
            }
        }
        new_mat.push_back(temp);
    }

    std::cout << std::endl << "Subset of matrix:" << std::endl;
    for (const auto& row : new_mat) {
        for (const auto& elem : row) {
            std::cout << elem << " ";
        }
        std::cout << std::endl;
    }

    std::vector<int> test3 = {0, 1, 1, 1};
    std::cout << std::endl << "Number of ones in the vector:" << std::endl;
    std::cout << std::count(test3.begin(), test3.end(), 1) << std::endl;
    
} 
