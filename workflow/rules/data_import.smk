
# ----------------------------------------------------------------------------------
#          ---        
#        / o o \    Snakemake workflow phylo-BEAST
#        V\ Y /V    Rules to load sequence data and other metadata for the analysis
#    (\   / - \     
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# -----------------------------------------------------------------------------------



rule select_metadata:
    message:
        """
        Load metadata file.
        """
    input: 
        metadata = config["input"]["metadata"]
    output:
        ids = "results/{dataset}/data/{prefix,.*}ids.tsv",
        metadata = "results/{dataset}/data/{prefix,.*}metadata.tsv"
    log:
        # "logs/load_metadata_{dataset}.txt"
    conda:
        "envs/python-genetic-data.yaml"
    shell:
        """
        python3 workflow/scripts/query_metadata.py \
            --metadata {input.metadata} \
            --config "{config}" \
            --dataset {wildcards.dataset} \
            --output {output.metadata} 2>&1 | tee {log}
        """


# rule select_metadata:
#     message:
#         """
#         Load metadata file.
#         """
#     input: 
#         metadata = config["input"]["metadata"]
#     output:
#         # ids = "results/{dataset}/data/{deme}/ids.tsv" if (lambda wildcards: _is_structured(wildcards)) else "results/{dataset}/data/ids.tsv"
#         ids = "results/{dataset}/data/ids.tsv",
#         metadata = "results/{dataset}/data/metadata.tsv"
#     log:
#         # "logs/load_metadata_{dataset}.txt"
#     conda:
#         "envs/python-genetic-data.yaml"
#     shell:
#         """
#         python3 workflow/scripts/query_metadata.py \
#             --metadata {input.metadata} \
#             --config "{config}" \
#             --dataset {wildcards.dataset} \
#             --output {output.metadata} 2>&1 | tee {log}
#         """

# rule select_structured_metadata:
#     message:
#         """
#         Load metadata file.
#         """
#     input: 
#         metadata = config["input"]["metadata"]
#     output:
#         ids = "results/{dataset}/data/{deme}_ids.tsv"
#     log:
#         # "logs/load_metadata_{dataset}.txt"
#     conda:
#         "envs/python-genetic-data.yaml"
#     shell:
#         """
#         python3 workflow/scripts/query_metadata.py \
#             --metadata {input.metadata} \
#             --config "{config}" \
#             --dataset {wildcards.dataset} \
#             --deme {wildcards.deme} \
#             --output {output.metadata} 2>&1 | tee {log}
#         """

        