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
        metadata = _get_ids_to_subsample
    output:
        metadata = "results/{dataset}/data/{prefix,.*}ids_subsampled.{dseed}.tsv"
    params:
        n = 1, #lambda wildcards: config["dataset"][wildcards.dataset][wildcards.deme]["n"],
        include = "", #lambda wildcards: config["dataset"][wildcards.dataset][wildcards.deme].get("include"), 
        exclude = "", #lambda wildcards: config["dataset"][wildcards.dataset][wildcards.deme].get("exclude"),
        weights = "", #lambda wildcards: config["dataset"][wildcards.dataset][wildcards.deme].get("weights_file")
        subsampling = ""
    # log:
        # "logs/subsample_{dataset}_{deme}_{subsampling}.{dseed}.txt"
    conda:
        "envs/r-genetic-data.yaml"
    shell:
        """
        Rscript workflow/scripts/subsample.R \
            --metadata_file {input.metadata} \
            --include_file {params.include} \
            --exclude_file {params.exclude} \
            --n {params.n} \
            --method {params.subsampling} \
            --weights_file {params.weights} \
            --seed {wildcards.dseed} \
            --output_file {output.metadata} 2>&1 | tee {log}
        """

