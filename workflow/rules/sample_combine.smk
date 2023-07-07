rule combine_samples:
    message:
        """
        Combine sequences metadata from demes.
        """
    input:
        ids = _get_ids_to_combine
    output:
        combined = "results/data/{dataset}/ids_combined{sufix,.*}.tsv" 
    log:
        # ("logs/combine_subsamples_{dataset}_{subsampling}.{dseed}.txt" if _is_structured
        # else "logs/combine_subsamples_{dataset}.txt")
    shell:
        """
        rm -f {output.combined}
        awk '(NR == 1) || (FNR > 1)' {input.ids} > {output.combined} 2>&1 | tee {log}
        """