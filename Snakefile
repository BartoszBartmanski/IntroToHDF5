
rule all:
    input:
        "main.py.md"
    output:
        "README.md"
    shell:
        "cp {input} {output}"

rule test_data_python:
    output:
        "Output/test_py.h5"
    shell:
        "Scripts/test_data.py {output}"

rule test_data_r:
    output:
        "Output/test_r.h5"
    shell:
        "Scripts/test_data.R {output}"

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
        "Output/test_py.h5",
        "Output/test_r.h5"
    output:
        "Output/highfive_test.h5"
    shell:
        "{input} {output}"

rule export_notebook:
    input:
        "Output/highfive_test.h5"
    output:
        "main.py.{fmt}"
    params:
        fmt = lambda wildcards : "markdown" if wildcards.fmt == "md" else wildcards.fmt
    shell:
        "jupyter-nbconvert --to {params.fmt} --execute main.py.ipynb"

