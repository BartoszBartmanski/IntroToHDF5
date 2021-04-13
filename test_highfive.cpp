#include <highfive/H5Easy.hpp>
#include <highfive/H5DataSet.hpp>
#include <vector>

int main() {
    H5Easy::File file("test_highfive.h5", H5Easy::File::Overwrite);

    int A = 10;
    H5Easy::dump(file, "/path/to/A", A);

    A = H5Easy::load<int>(file, "/path/to/A");

    H5Easy::File file2("test2_rhdf5.h5", H5Easy::File::ReadOnly);
	auto test = H5Easy::load<std::vector<double>>(file2, "A");
    for (auto& i : test) {
        std::cout << i << std::endl;
    }
}
