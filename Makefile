
all: conda_env.yml

conda_env.yml:
	conda env export -n test_hdf5 -f $@

.git/hooks/pre-commit:
	ln -s ../../.pre-commit $@

clean:
	rm -rf build/ Output/ gurobi.log conda_env.yml main.py.md README.md 
