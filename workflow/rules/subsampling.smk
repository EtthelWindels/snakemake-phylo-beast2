# ------------------------------------------------------------------------------
#          ---        
#        / o o \    Snakemake workflow phylo-BEAST
#        V\ Y /V    Rules for subsampling
#    (\   / - \     
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# ------------------------------------------------------------------------------


rule subsample:
    message:
        """
        Subsample sequences 
        """
    input:
        ids = _get_ids_to_subsample,
        metadata = _get_metadata_file
    output:
        ids = "results/data/{dataset}/{prefix,.*}ids_subsampled.{dseed}.tsv"
    params:
        include = lambda wildcards: _get_subsampling_param("include", wildcards), 
        exclude = lambda wildcards: _get_subsampling_param("exclude", wildcards),
        n = lambda wildcards: _get_subsampling_param("n", wildcards),
        method = lambda wildcards: _get_subsampling_param("method", wildcards),
        weights = lambda wildcards: _get_subsampling_param("weights", wildcards)
    log:
        "logs/subsample_{dataset}_{prefix,.*}.{dseed}.txt"
    # conda:
    #     "envs/r-genetic-data.yaml"
    shell:
        """
        Rscript workflow/scripts/subsample.R \
            --ids_file {input.ids} \
            --metadata_file {input.metadata} \
            --include_file {params.include} \
            --exclude_file {params.exclude} \
            --n {params.n} \
            --method {params.method} \
            --weights {params.weights} \
            --seed {wildcards.dseed} \
            --output_file {output.ids} 2>&1 | tee {log}
        """

