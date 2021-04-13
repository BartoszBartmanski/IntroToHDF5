
all: conda_env.yml test_highfive.h5

conda_env.yml:
	conda env export -n test_hdf5 --file $@

build:
	mkdir $@

# Remember to run this outside of conda env
./build/test_highfive: build
	cd build && cmake ../ -DHIGHFIVE_USE_BOOST=OFF && make test_highfive

test_highfive.h5: ./build/test_highfive
	$<

clean:
	rm -rf build/ *.h5 conda_env.yml *.html gurobi.log
