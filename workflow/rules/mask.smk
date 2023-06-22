

rule mask:
    message:
        """
        Mask bases in alignment {input.aln}
          - masking {params.mask_from_beginning} from beginning
          - masking {params.mask_from_end} from end
          - masking other sites: {params.mask_sites}
        Rule from nextstrain ncov workflow.
        """
    input:
        alignment = "results/{dataset}/data/aligned{sufix,.*}.fasta"
    output:
        masked =  "results/{dataset}/data/masked{sufix,.*}.fasta"
    log:
        "logs/mask_{dataset}{sufix,.*}.txt"
    benchmark:
        "benchmarks/mask_{dataset}{sufix,.*}}.txt"
    params:
        mask_from_beginning = config["mask"]["mask_from_beginning"],
        mask_from_end = config["mask"]["mask_from_end"],
        mask_sites = config["mask"]["mask_sites"]
    conda:
        "envs/python-genetic-data.yaml"
    shell:
        """
        python3 workflow/scripts/mask_alignment.py \
            --alignment {input.alignment} \
            --mask-from-beginning {params.mask_from_beginning} \
            --mask-from-end {params.mask_from_end} \
            --mask-sites {params.mask_sites} \
            --mask-terminal-gaps \
            --output {output.masked} 2> {log}
        """
