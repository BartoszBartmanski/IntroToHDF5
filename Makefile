
all: conda_env.yml test_h5py.h5 test_rhdf5.hdf5

conda_env.yml:
	conda env export -n test_hdf5 --file $@

build:
	mkdir $@

# Remember to run this outside of conda env
./build/test_highfive: build
	cd build && cmake ../ && make test_highfive

test_highfive.h5: ./build/test_highfive
	$<

test_h5py.h5:
	jupyter-nbconvert --to notebook --inplace --execute main.py.ipynb

test_rhdf5.hdf5:
	jupyter-nbconvert --to notebook --inplace --execute main.r.ipynb

clean:
	rm -rf build/ *.h5 *.hdf5 conda_env.yml
