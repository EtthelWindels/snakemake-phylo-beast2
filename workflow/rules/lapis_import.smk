# ----------------------------------------------------------------------------------
#          ---        
#        / o o \    Snakemake workflow phylo-BEAST
#        V\ Y /V    Rules to load sequence data and other metadata with LAPIS
#    (\   / - \     
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# -----------------------------------------------------------------------------------


rule load_metadata:
    message:
        """
        Load with LAPIS all high quality (nextclade qc score between 0 and 10) human sequences metadata in GISAID for {wildcards.deme} from config file.
        """
    output:
        metadata = "results/{dataset}/data/{deme}/metadata.tsv"
    log:
        "logs/load_metadata_{dataset}_{deme}.txt"
    conda:
        "envs/python-genetic-data.yaml"
    shell:
        """
        python3 workflow/scripts/lapis_query_metadata.py \
            --select config["dataset"][wildcards.dataset][wildcards.deme]['select'] \
            --deme {wildcards.deme} \
            --output {output.metadata} 2>&1 | tee {log}
        """

