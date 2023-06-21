

# alignment
rule align:
    message:
        """
        Align with mafft
        """
    input:
        sequences = rules.filter.output.sequences
    output:
        aln = "results/{dataset}/data/{subsampling}/alignment.{dseed}.fasta"
    log:
        "logs/align_{dataset}_{subsampling}.{dseed}.txt"
    conda:
        "envs/mafft.yaml"
    shell:
        """
        mafft #TODO
        """
