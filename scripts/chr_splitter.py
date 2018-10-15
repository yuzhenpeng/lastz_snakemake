#!/bin/python

from Bio import SeqIO
from sys import argv
from sys import exit


def fasta_parse(seq_file, output_dir, path_file):
    for chrom in SeqIO.parse(open(path_file), "fasta"):
        file_name = str(seq_file)[:-3] + "." + str(chrom.id) + ".fa"
        out_file = output_dir + file_name
        SeqIO.write(chrom, out_file, "fasta")


def main():
    if str(argv[1])[-2:] != "fa":
        print("File extension should be .fa")
        exit()
    just_file = str(argv[1]).split("/")[-1]
    output_dir = "fasta_files/" + just_file[:-3] + "/chromosomes/"
    fasta_parse(just_file, output_dir, argv[1])


if __name__ == "__main__":
    main()
