

rule combine_samples:
    message:
        """
        Combine sequences metadata from demes.
        """
    input:
        subsample = _get_ids_to_combine
    output:
        # combined = ("results/{dataset}/data/ids.tsv" if (lambda wildcards: _is_structured(wildcards)) else "") # Conditional rule, only for structured datasets
        combined = "results/{dataset}/data/ids_combined{sufix,.*}.tsv" 
    log:
        # ("logs/combine_subsamples_{dataset}_{subsampling}.{dseed}.txt" if _is_structured
        # else "logs/combine_subsamples_{dataset}.txt")
    shell:
        """
        rm -f {output.combined}
        awk '(NR == 1) || (FNR > 1)' {input.subsample} > {output.combined} 2>&1 | tee {log}
        """
