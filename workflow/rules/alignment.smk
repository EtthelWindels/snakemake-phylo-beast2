

# alignment
rule align:
    message:
        """
        Align with mafft
        """
    input:
        sequences = rules.select_sequences.output.sequences
    output:
        alignment = "results/data/{dataset}/aligned{sufix,.*}.fasta"
    log:
        "logs/align_{dataset}_{sufix,.*}.txt"
    conda:
        "envs/mafft.yaml"
    shell:
        """
        mafft #TODO
        """
