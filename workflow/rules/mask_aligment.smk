
rule mask_sequences:
    message:
        """
        Mask bases in alignment {input.aln}
          - masking {params.mask_from_beginning} from beginning
          - masking {params.mask_from_end} from end
          - masking other sites: {params.mask_sites}
        Rule from nextstrain ncov workflow.
        """
    input:
        aln = (rules.load_sequences.output.aln if config["output"]["lapis_import"]
                else rules.align.output.aln)
    output:
        aln =  "results/{dataset}/data/aln_masked_{subsampling}.{dseed}.fasta"
    log:
        "logs/mask_{dataset}_{subsampling}.{dseed}.txt"
    benchmark:
        "benchmarks/mask_{dataset}_{subsampling}.{dseed}.txt"
    params:
        mask_from_beginning = config["mask"]["mask_from_beginning"],
        mask_from_end = config["mask"]["mask_from_end"],
        mask_sites = config["mask"]["mask_sites"]
    conda:
        "envs/python-genetic-data.yaml"
    shell:
        """
        python3 workflow/scripts/mask_alignment.py \
            --alignment {input.aln} \
            --mask-from-beginning {params.mask_from_beginning} \
            --mask-from-end {params.mask_from_end} \
            --mask-sites {params.mask_sites} \
            --mask-terminal-gaps \
            --output {output.aln} 2> {log}
        """
