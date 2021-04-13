
rule all:
    input:
        "test_h5py.h5", 
        "test_rhdf5.h5",
        expand("main.{lang}.html", lang=("py", "r"))

rule create_hdf5_file:
    output:
        "test2_rhdf5.h5"
    shell:
        "Rscript test2_rhdf5.R"

rule run_python_notebook:
    input:
        "test2_rhdf5.h5"
    output:
        "test_h5py.h5"
    shell:
        "jupyter-nbconvert --to notebook --inplace --execute main.py.ipynb"

rule run_r_notebook:
    input:
        "test2_rhdf5.h5"
    output:
        "test_rhdf5.h5"
    shell:
        "jupyter-nbconvert --to notebook --inplace --execute main.r.ipynb"

rule export_notebook:
    input:
        "test2_rhdf5.h5"
    output:
        "main.{lang}.{fmt}"
    params:
        fmt = lambda wildcards : "markdown" if wildcards.fmt == "md" else wildcards.fmt
    shell:
        "jupyter-nbconvert --to {params.fmt} --execute main.{wildcards.lang}.ipynb"

