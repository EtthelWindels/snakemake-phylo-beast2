# Generate one metadata file

rule process_metadata:
    input:
        meta_Ma = "data/metadata/Malawi_metadata_raw.txt",
        meta_Ta = "data/metadata/Tanzania_metadata_raw.txt",
        meta_TG = "data/metadata/TheGambia_metadata_raw.txt",
        meta_VN = "data/metadata/Vietnam_metadata_raw.txt"
    output:
        meta_all = "data/metadata/allcountries_metadata.txt" 
    script:
        "../scripts/process_metadata.R"


# Adjust alignment names

rule alignment_names:
    input:
        meta_all = "data/metadata/allcountries_metadata.txt",
        alignment_in = "data/alignments/{dataset}/{dataset}_outgr_var_aln.fasta"
    output:
        alignment_out = "data/alignments/{dataset}/{dataset}_newid.fasta"
    log:
        "logs/{dataset}/{dataset}_newid.txt"
    script:
        "../scripts/adjust_alignment_names.R"     


# Subsample datasets with >400 sequences

rule subsample:
    input:
        meta_all = "data/metadata/allcountries_metadata.txt",
        alignment_in = "data/alignments/{dataset}/{dataset}_newid.fasta"
    output:
        alignment_out = "data/alignments/{dataset}/{dataset}_beast.fasta"
    script:
        "../scripts/subsample.R"


# TO DO: only apply this rule to alignments to be subsampled (avoid unnecessary reading and writing of fasta files)
# e.g. 
# rule subsample:
#     input:
#         alignment_in = _is_subsampled
#         meta_all = "data/metadata/allcountries_metadata.txt",
#     output:
#         alignment_out = "data/alignments/{dataset}/{dataset}_beast.fasta"
# or subsample based on separate ID file

