


def _is_structured(wildcards):
    return (config["dataset"][wildcards.dataset].get("structure") is not None)

def _is_subsampled(wildcards):
    return (config["dataset"][wildcards.dataset].get("replicates") is not None)

def _is_filtered(wildcards):
    return (config["dataset"][wildcards.dataset].get("filter") is not None)

def _is_filtered_deme(wildcards, deme):
    return (config["dataset"][wildcards.dataset][deme].get("filter") is not None)


def _get_ids_to_subsample(wildcards):
    # if _is_structured(wildcards):
    #     demes = config["dataset"][wildcards.dataset]["structure"].keys()
    #     files = []
    #     for deme in demes:
    #         files.append("results/{{dataset}}/data/" + deme + "/" + "ids" + 
    #             ("_filtered" if (config["dataset"][wildcards.dataset]["structure"][deme].get("filter") is not None) else "") + ".tsv")
    #     return files
    if _is_filtered(wildcards):
        return "results/{dataset}/data/{prefix,.*}ids_filtered.tsv"

    else:
        return "results/{dataset}/data/{prefix,.*}ids.tsv"

def _get_ids_to_combine(wildcards):
    if _is_structured(wildcards):
        demes = config["dataset"][wildcards.dataset]["structure"].keys()
        files = []
        for deme in demes:
            if config["dataset"][wildcards.dataset]["structure"][deme].get("subsample") is not None:
                files.append("results/{dataset}/data/" + deme + "/" + "ids_subsampled{sufix,*.}.tsv") 
            elif config["dataset"][wildcards.dataset]["structure"][deme].get("filter") is not None:
                files.append("results/{dataset}/data/" + deme + "/" + "ids_filtered.tsv") 
            else:
                files.append("results/{dataset}/data/" + deme + "/" + "ids.tsv") 
            # files.append("results/{{dataset}}/data/" + deme + "/" + "ids" + 
            #     ("_filtered" if (config["dataset"][wildcards.dataset]["structure"][deme].get("filter") is not None) else "") + ".tsv")
        return files
    return "results/{dataset}/data/ids.tsv"

def  _get_sequence_ids(wildcards):
    data_dir = "results/{dataset}/data/"
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
