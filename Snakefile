CHROMOSOMES = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', 'X', 'Y']

CURRENT_SAMPLE = config["mysamp"]


rule crossmap:
    input:
        "/homes/cwalker/genomes/chains/GRCh37_to_GRCh38.chain.gz",
        "/hps/nobackup/goldman/conor/cortex_graphs/per_sample_vcfs/{sample}.vcf.gz",
        "/hps/nobackup/goldman/conor/ensembl_GRCh38/Homo_sapiens.GRCh38.fa"
    output:
        "crossmapped_samples/{sample}.vcf"
    shell:
        "python2 /hps/nobackup/goldman/conor/1k_genomes/template_switching/tools/CrossMap-0.2.9/bin/CrossMap.py vcf {input} {output}"

rule sort_vcf:
    input:
        "crossmapped_samples/{sample}.vcf"
    output:
        "sorted_samples/{sample}.vcf"
    shell:
        "vcf-sort {input} > {output}"

rule bgzip_vcf:
    input:
        "sorted_samples/{sample}.vcf"
    output:
        "bgzipped_vcfs/{sample}.bgz"
    shell:
        "bgzip -c {input} > {output}"

rule tabix_vcf:
    input:
        "bgzipped_vcfs/{sample}.bgz"
    output:
        "bgzipped_vcfs/{sample}.bgz.tbi"
    shell:
        "tabix -p vcf {input}"

rule create_fasta:
    input:
        "/hps/nobackup/goldman/conor/ensembl_GRCh38/Homo_sapiens.GRCh38.fa",
        "bgzipped_vcfs/{sample}.bgz",
        "bgzipped_vcfs/{sample}.bgz.tbi"
    output:
        "fasta_files/{sample}/genome/{sample}.fa"
    shell:
        "bcftools consensus -f {input} > {output}"

rule split_into_chromosomes:
    input:
        gen_fas=("fasta_files/{my_samp}/genome/{my_samp}.fa".format(my_samp=config["mysamp"]))
    output:
        expand("fasta_files/{my_samp}/chromosomes/{my_samp}.{chrom}.fa", my_samp=config["mysamp"], chrom=CHROMOSOMES)
    shell:
        "python scripts/chr_splitter.py {input.gen_fas}"

#rule chunk_chromosomes:
#    input:
#        chrom_file
#    output:
#        chrom_file{chunks}
#    shell:
#        python chunk_chroms.py

rule fa_to_twobit:
    input:
        expand("fasta_files/{my_samp}/chromosomes/{my_samp}.{chrom}.fa", my_samp=config["mysamp"], chrom=CHROMOSOMES)
    output:
        expand("fasta_files/{my_samp}/chromosomes/{my_samp}.{chrom}.2bit", my_samp=config["mysamp"], chrom=CHROMOSOMES)
    shell:
        "for f in {input}; do twobitname=`echo $f | rev | cut -c3- | rev`; twobitname+=2bit; faToTwoBit $f $twobitname; done"

rule lastz_align_chromosomes:
    input:
        target=expand("/hps/nobackup/goldman/conor/ensembl_GRCh38/{chrom}.2bit", my_samp=config["mysamp"], chrom=CHROMOSOMES),
        query=expand("fasta_files/{my_samp}/chromosomes/{my_samp}.{chrom}.2bit", my_samp=config["mysamp"], chrom=CHROMOSOMES)
    output:
        expand("aligned/{my_samp}/maf/{chrom}_{my_samp}.maf", my_samp=config["mysamp"], chrom=CHROMOSOMES)
    shell:
        """
        python scripts/lastz_python/lastz.py {input.target[0]} {input.query[0]}
        python scripts/lastz_python/lastz.py {input.target[1]} {input.query[1]}
        python scripts/lastz_python/lastz.py {input.target[2]} {input.query[2]}
        python scripts/lastz_python/lastz.py {input.target[3]} {input.query[3]}
        python scripts/lastz_python/lastz.py {input.target[4]} {input.query[4]}
        python scripts/lastz_python/lastz.py {input.target[5]} {input.query[5]}
        python scripts/lastz_python/lastz.py {input.target[6]} {input.query[6]}
        python scripts/lastz_python/lastz.py {input.target[7]} {input.query[7]}
        python scripts/lastz_python/lastz.py {input.target[8]} {input.query[8]}
        python scripts/lastz_python/lastz.py {input.target[9]} {input.query[9]}
        python scripts/lastz_python/lastz.py {input.target[10]} {input.query[10]}
        python scripts/lastz_python/lastz.py {input.target[11]} {input.query[11]}
        python scripts/lastz_python/lastz.py {input.target[12]} {input.query[12]}
        python scripts/lastz_python/lastz.py {input.target[13]} {input.query[13]}
        python scripts/lastz_python/lastz.py {input.target[14]} {input.query[14]}
        python scripts/lastz_python/lastz.py {input.target[15]} {input.query[15]}
        python scripts/lastz_python/lastz.py {input.target[16]} {input.query[16]}
        python scripts/lastz_python/lastz.py {input.target[17]} {input.query[17]}
        python scripts/lastz_python/lastz.py {input.target[18]} {input.query[18]}
        python scripts/lastz_python/lastz.py {input.target[19]} {input.query[19]}
        python scripts/lastz_python/lastz.py {input.target[20]} {input.query[20]}
        python scripts/lastz_python/lastz.py {input.target[21]} {input.query[21]}
        python scripts/lastz_python/lastz.py {input.target[22]} {input.query[22]}
        python scripts/lastz_python/lastz.py {input.target[23]} {input.query[23]}
        """
