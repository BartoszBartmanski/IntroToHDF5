
rule all:
    input:
        "main.py.md"
    output:
        "README.md"
    shell:
        "cp {input} {output}"

rule use_h5py:
    output:
        "Output/h5py_test.h5"
    shell:
        "Scripts/use_h5py.py {output}"

rule use_rhdf5:
    output:
        "Output/rhdf5_test1.h5", "Output/rhdf5_test2.h5"
    shell:
        "Scripts/use_rhdf5.R {output}"

rule compile_highfive:
    input:
        "src/highfive_test.cpp"
    output:
        "build/highfive_test"
    shell:
        "cd build && cmake ../ && make highfive_test"

rule run_highfive:
    input:
        "build/highfive_test",
        "Output/rhdf5_test1.h5"
    output:
        "Output/highfive_test.h5"
    shell:
        "./build/highfive_test {input[1]} {output}"

rule export_notebook:
    input:
        "Output/h5py_test.h5",
        "Output/rhdf5_test1.h5",
        "Output/rhdf5_test2.h5",
        "Output/highfive_test.h5"
    output:
        "main.py.{fmt}"
    params:
        fmt = lambda wildcards : "markdown" if wildcards.fmt == "md" else wildcards.fmt
    shell:
        "jupyter-nbconvert --to {params.fmt} --execute main.py.ipynb"

