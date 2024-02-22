# Common functions

def _is_subsampled(wildcards):
    return (config["datasets"][wildcards.dataset].get("subsampled") is not None)

def _get_analysis_param(wildcards, param):
    return config["analyses"][wildcards.method][wildcards.analysis].get(param)

def _get_model_analysis(wildcards,analysis):
     return config["analyses"][wildcards.method][analysis].get("model")

