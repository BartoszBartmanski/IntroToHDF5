
all: conda_env.yml

conda_env.yml:
	conda env export -n test_hdf5 --file $@

clean:
	rm -rf build/ Output/ gurobi.log conda_env.yml main.py.md README.md 
