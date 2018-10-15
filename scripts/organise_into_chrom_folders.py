#!/usr/local/bin/python

from sys import argv
from os.path import isfile, join
from os import listdir
from shutil import move
from os import mkdir

def make_chromosome_directories(fas_path):
    """
    Create chr1, chr2, ..., chrY in path of fasta files.
    """
    chr_list = []
    for i in range(22):
        chr_list.append("chr_" + str(i+1))
        chr_list.append("chr_X")
        chr_list.append("chr_Y")
    for folder in chr_list:
        mkdir(join(fas_path, str(folder)))
    return None


def main():
    fas_file_path = argv[1]

    pass


if __name__ == "__main__":
    main()
