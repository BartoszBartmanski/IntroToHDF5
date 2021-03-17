#include <highfive/H5Easy.hpp>

int main() {
    H5Easy::File file("test_highfive.h5", H5Easy::File::Overwrite);

    int A = 10;
    H5Easy::dump(file, "/path/to/A", A);

    A = H5Easy::load<int>(file, "/path/to/A");
}
