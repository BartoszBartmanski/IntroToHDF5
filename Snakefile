
rule all:
    input:
        "test_h5py.h5", 
        "test_rhdf5.h5",
        expand("main.{lang}.html", lang=("py", "r"))

rule run_python_notebook:
    output:
        "test_h5py.h5"
    shell:
        "jupyter-nbconvert --to notebook --inplace --execute main.py.ipynb"

rule run_r_notebook:
    output:
        "test_rhdf5.h5"
    shell:
        "jupyter-nbconvert --to notebook --inplace --execute main.r.ipynb"

rule export_notebook:
    output:
        "main.{lang}.html"
    shell:
        "jupyter-nbconvert --to html --execute main.{wildcards.lang}.ipynb"

