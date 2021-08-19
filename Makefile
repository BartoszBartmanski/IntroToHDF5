
SHELL := /bin/bash

ENV_NAME := test_hdf5

all: README.md

README.md: main.py.md
	cp $^ $@

Output/test_py.h5:
	mkdir -p $(dir $@) && Scripts/test_data.py $@

Output/test_r.h5:
	mkdir -p $(dir $@) && Scripts/test_data.R $@

build/test_highfive:
	mkdir -p  $(dir $@) && cd $(dir $@) && cmake ../ && make $(notdir $@)

Output/test_highfive.h5: build/test_highfive Output/test_py.h5 Output/test_r.h5
	./$^ $@

main.py.md: Output/test_highfive.h5 Output/test_py.h5 Output/test_r.h5
	jupyter-nbconvert --to markdown --execute $(patsubst %.md,%.ipynb,$@)

conda_env.yml:
	conda env export -n ${ENV_NAME} -f $@

conda_env_simple.yml:
	conda env export -n ${ENV_NAME} -f $@ --from-history

.git/hooks/pre-commit:
	ln -s ../../.pre-commit $@

clean:
	rm -rf build/ Output/ gurobi.log conda_env.yml main.py.md README.md 
