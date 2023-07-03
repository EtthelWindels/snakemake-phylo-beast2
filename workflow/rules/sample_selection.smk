
# ----------------------------------------------------------------------------------
#          ---        
#        / o o \    Snakemake workflow phylo-BEAST
#        V\ Y /V    Rules to load sequence data and other metadata for the analysis
#    (\   / - \     
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# -----------------------------------------------------------------------------------



rule select_samples:
    message:
        """
        Load metadata file.
        """
    input: 
        metadata = _get_metadata_file 
    output:
        ids = "results/data/{dataset}/{prefix,.*}ids.tsv",
    params:
        select = _get_select_params,
        seq_id = _get_seq_id,
        deme = lambda wildcards: wildcards.prefix[0:-1] or None
    log:
        "logs/select_samples_{dataset}{prefix,.*}.txt"
    # conda:
    #     "envs/python-genetic-data.yaml"
    shell:
        """
        python3 workflow/scripts/query_metadata.py \
            --metadata {input.metadata} \
            --select "{params.select}" \
            --seq_id {params.seq_id} \
            --deme {params.deme} \
            --output {output.ids} 2>&1 | tee {log}
        """



