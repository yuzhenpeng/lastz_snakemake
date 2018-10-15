#!/usr/local/bin/python

from sys import argv
from Bio import SeqIO


def chunk_chroms(record): 
    midpoint = len(record.seq) / 2




def main():
    fasta_record = SeqIO.read(argv[1], "fasta")
    chunk_chroms(fasta_record)


if __name__ == "__main__":
    main()
