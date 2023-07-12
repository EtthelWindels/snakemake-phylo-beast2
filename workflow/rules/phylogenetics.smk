# phylogenetics

rule iqtree:
    input:
        alignment = "results/data/{dataset}/aligned{sufix,.*}.fasta"
    output:
        tree =  "results/analysis/iqtree/{dataset}{sufix,.*}.treefile"
    params:
      outgroup = _get_analysis_param("iqtree", "outgroup"),
      outgroup_file = _get_analysis_param("iqtree", "outgroup_file"),
      alignment_outgroup =  "results/analysis/iqtree/temp/{dataset}{sufix,.*}.fasta",
      tree_args = _get_analysis_param("iqtree", "tree_args"),
      file_name = "results/analysis/iqtree/other/{dataset}{sufix,.*}",
      seed = _get_seed
    conda:
        "../envs/iqtree2.yaml"
    shell:
        """
        mkdir -p "results/analysis/iqtree/temp/"
        mkdir -p "results/analysis/iqtree/other/"
        cat {input.alignment} {params.outgroup_file} > {params.alignment_outgroup} 2>/dev/null  

        iqtree2 -s {params.alignment_outgroup}  \
        {params.tree_args} \
        -seed {params.seed} \
        -o '{params.outgroup}' \
        -pre {params.file_name} 
        mv {params.file_name}.treefile {output.tree}
        rm {params.alignment_outgroup}
        mv {params.file_name}.log logs/iqtree_{wildcards.dataset}{wildcards.sufix}.log
        """

rule plot_tree: #TODO add general metadata input
    input:
        tree = rules.iqtree.output.tree
    output:
        fig = "results/analysis/iqtree/{dataset}{sufix,.*}.png",
    params:
        outgroup = _get_analysis_param("iqtree", "outgroup"),
    script:
        "../scripts/plot_mltree.R"


# rule time_tree:
#     input:
#         dates = rules.create_dates_file.output.dates,
#         aln = rules.mask_sequences.output.aln,
#         tree = rules.iqtree.output.tree,
#     output:
#         timetree = "results/{dataset}/trees/timetree_{subsampling}.{dseed}.nexus"
#     params:
#         clock_rate = 0.0008
#     conda:
#         "envs/treetime.yaml"
#     shell:
#         """
#         treetime --tree {input.tree} \
#          --dates {input.dates} \
#          --aln {input.aln} \
#          --clock-rate {params.clock_rate} \
#          --outdir results/{wildcards.dataset}/trees
#         """

# rule plot_tree:
