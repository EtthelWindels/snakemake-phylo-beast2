
rule filter:
    message:
        """
        Run qc analysis on sequences and filter
        """
    input:
        ids = rules.select_samples.output.ids,
        sequences = _get_sequences_file
    output:
        qc_report = "results/{dataset}/data/{prefix,.*}qc.txt",
        ids = "results/{dataset}/data/{prefix,.*}ids_filtered.tsv"
    # log:
    #     "logs/qc_{dataset}_{subsampling}.{dseed}.txt"
    conda:
        "envs/python-genetic-data.yaml"
    shell:
        """
        python3 #TODO, also maybe the option to run nextclade or other tool
        """


# saves ids that pass and the ones that don't