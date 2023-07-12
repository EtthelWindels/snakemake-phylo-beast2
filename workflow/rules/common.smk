# Common functions

def _is_structured(wildcards):
    return (config["datasets"][wildcards.dataset].get("structure") is not None)

def _is_subsampled(wildcards):
    return (config["datasets"][wildcards.dataset].get("replicates") is not None)

def _is_filtered(wildcards):
    return (config["datasets"][wildcards.dataset].get("filter") is not None)

def _is_filtered_deme(wildcards, deme):
    return (config["datasets"][wildcards.dataset][deme].get("filter") is not None)

def _get_ids_to_subsample(wildcards):
    if _is_filtered(wildcards):
        return "results/data/{dataset}/{prefix,.*}ids_filtered.tsv"
    else:
        return "results/data/{dataset}/{prefix,.*}ids.tsv"

def _get_ids_to_combine(wildcards):
    if _is_structured(wildcards):
        demes = config["datasets"][wildcards.dataset]["structure"].keys()
        files = []
        for deme in demes:
            if config["datasets"][wildcards.dataset]["structure"][deme].get("subsample") is not None:
                files.append("results/data/{dataset}/" + deme + "/" + "ids_subsampled{sufix,*.}.tsv") 
            elif config["datasets"][wildcards.dataset]["structure"][deme].get("filter") is not None:
                files.append("results/data/{dataset}/" + deme + "/" + "ids_filtered.tsv") 
            else:
                files.append("results/data/{dataset}/" + deme + "/" + "ids.tsv") 
            # files.append("results/{{dataset}}/data/" + deme + "/" + "ids" + 
            #     ("_filtered" if (config["dataset"][wildcards.dataset]["structure"][deme].get("filter") is not None) else "") + ".tsv")
        return files
    return "results/data/{dataset}/ids.tsv"

def  _get_sequence_ids(wildcards):
    data_dir = "results/data/{dataset}/"
    if _is_subsampled(wildcards) and _is_structured(wildcards):
        return data_dir + "ids_combined{sufix}.tsv"
    if _is_subsampled(wildcards):
        return data_dir + "ids_subsampled{sufix}.tsv"
    if _is_structured(wildcards):
        return data_dir + "ids_combined.tsv"
    if _is_filtered(wildcards):
        return data_dir + "ids_filtered.tsv"
    else:
        return data_dir + "ids.tsv"


def  _get_metadata_file(wildcards):
    return _get_dataset_param("metadata", wildcards)

# def  _get_all_metadata_files(wildcards):
#     datasets = config["datasets"][wildcards.dataset]["structure"].keys()
#     metadata_files = []
#     for d in datasets:
#         metadata_files.append(config["datasets"][wildcards.dataset]["structure"][d].get("metadata"))
#     return metadata_files

def  _get_sequences_file(wildcards):
    return _get_dataset_param("sequences", wildcards)


def  _get_select_params(wildcards):
    return _get_dataset_param("select", wildcards)

def  _get_seq_id(wildcards):
    seq_id = _get_dataset_param("seq_id", wildcards) or config["lapis"]["seq_id"]
    return seq_id

def _get_deme(wildcards):
    if _is_structured(wildcards):
        return config["datasets"][wildcards.dataset]["structure"][wildcards.prefix[0:-1]].get("deme", 
            wildcards.prefix[0:-1]) 
    else:
        return None

def _get_seed(wildcards):
    # Returns data seed if several replicates or 1
    return wildcards.sufix[1:] or 1

def _get_analysis_param(analysis, param):
    return config["run"]["analysis"][analysis].get(param)

def  _get_dataset_param(param, wildcards):
    if _is_structured(wildcards):
        return config["datasets"][wildcards.dataset]["structure"][wildcards.prefix[0:-1]].get(param)
    else:
        return config["datasets"][wildcards.dataset].get(param)

def  _get_subsampling_param(param, wildcards):
    if _is_structured(wildcards):
        return config["datasets"][wildcards.dataset]["structure"][wildcards.prefix[0:-1]]["subsample"].get(param)
    else:
        return config["datasets"][wildcards.dataset]["subsample"].get(param)

