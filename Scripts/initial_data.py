#!/usr/bin/env python

import h5py
import numpy as np
import sys


def example(filename):
    # Writing to a file
    with h5py.File(filename, "w") as fh:
    	fh.create_dataset("array", data=[0, 10, 5])
    	fh.create_dataset("strings", data=["hello", "world"])
    	fh.create_dataset("int", data=1)
    	fh.create_dataset("string", data="test")

if __name__ == "__main__":
    example(sys.argv[1])

