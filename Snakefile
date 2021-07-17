
rule all:
    input:
        "main.py.md"
    output:
        "README.md"
    shell:
        "cp {input} {output}"

rule highfive_input:
    output:
        "Output/highfive_test.h5"
    shell:
        "Scripts/initial_data.py {output}"

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
        "Output/highfive_test.h5"
    output:
        "Output/highfive_test2.h5"
    shell:
        "./build/highfive_test {input[1]} {output}"

rule export_notebook:
    input:
        "Output/highfive_test.h5"
    output:
        "main.py.{fmt}"
    params:
        fmt = lambda wildcards : "markdown" if wildcards.fmt == "md" else wildcards.fmt
    shell:
        "jupyter-nbconvert --to {params.fmt} --execute main.py.ipynb"

