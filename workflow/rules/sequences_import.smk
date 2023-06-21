rule load_sequences:
    message:
        """
        Load the selected sequences for each dataset.
        """
    input:
        # ids = "results/{dataset}/data/ids_combined.tsv" if (lambda wildcards: _is_structured(wildcards)) else "results/{dataset}/data/ids.tsv"
        ids = _get_sequences_ids
    output:
        # sequences = "results/{dataset}/data/{subsampling}/sequences.{dseed}.fasta"
        sequences = "results/{dataset}/data/sequences{sufix,.*}.fasta"
    log:
        # "logs/load_seqs_{dataset}_{subsampling}.{dseed}.txt" # TODO add log, change run to shell
    conda:
        "envs/python-genetic-data.yaml"
    shell:
        """
        python3 workflow/scripts/query_sequences.py \
            --config "{config}" \
            --ids_file {input.ids} \
            --output_file {output.sequences} \
            --drop_incomplete True 2>&1 | tee {log}
        """

