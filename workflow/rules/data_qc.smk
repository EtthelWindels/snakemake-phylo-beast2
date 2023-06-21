# ----------------------------------------------------------------------------------
#          ---        
#        / o o \    Snakemake workflow phylo-BEAST
#        V\ Y /V    Snakemake workflow to run beast2 analysis with genetic sequences 
#    (\   / - \     
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# -----------------------------------------------------------------------------------



rule filter:
    message:
        """
        Run qc analysis on sequences and filter
        """
    input:
        ids = rules.select_metadata.output.ids,
        sequences = config["input"]["sequences"]
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
