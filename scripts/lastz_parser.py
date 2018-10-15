#!/usr/local/bin/python

#import multiprocessing as mp

from subprocess import call
from sys import argv

targets = argv[1:25]
queries = argv[25:]


def lastz_job(chrom):
    global targets
    global queries
    return call(['python', '/hps/nobackup/goldman/conor/1k_genomes/template_switching/scripts/lastz_python/lastz.py', targets[chrom], queries[chrom]])

def main():
    global targets
    global queries
    #no_cpus = mp.cpu_count()
    
    #lastz_jobs = []

    #pool = mp.Pool(processes=no_cpus)
    
    #aligned_results = pool.map(lastz_job, range(25))
    
    #pool.map(lastz_job, range(25))
    
    for chrom in range(25):
        call(['python', '/hps/nobackup/goldman/conor/1k_genomes/template_switching/scripts/lastz_python/lastz.py', targets[chrom], queries[chrom]])

if __name__ == '__main__':
    main()
