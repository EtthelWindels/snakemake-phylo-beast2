
rule load_sequences:
    message:
        """
        Load with LAPIS the selected sequences for each dataset and drop not full genome sequences.
        """
    input:
        ids = rules.combine_subsamples.output.combined
    output:
        aln = "results/{dataset}/data/aln_{subsampling}.{dseed}.fasta"
    log:
        "logs/load_seqs_{dataset}_{subsampling}.{dseed}.txt" # TODO add log, change run to shell
    conda:
        "envs/python-genetic-data.yaml"
    shell:
        """
        python3 workflow/scripts/lapis_query_sequences.py \
            --config "{config}" \
            --ids_file {input.ids} \
            --output_file {output.aln} \
            --drop_incomplete True 2>&1 | tee {log}
        """
