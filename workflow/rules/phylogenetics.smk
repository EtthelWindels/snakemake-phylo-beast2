

# phylogenetics

rule mltree:
    input:
        alignment = _get_alignment
    output:
        tree = "results/{dataset}/trees/ml_tree_{subsampling}.{dseed}.treefile"
    params:
        tree_args = config["ml_tree"]["tree_args"],
        file_name = "results/{dataset}/trees/ml_tree_{subsampling}.{dseed}"
    conda:
        "envs/iqtree2.yaml"
    shell:
        """
        iqtree2 -s {input.aln}  \
        {params.tree_args} \
        --prefix {params.file_name} 
        rm -f results/trees/*.ckp.gz 
        rm -f results/trees/*.uniqueseq.phy 
        rm -f results/trees/*.nex 
        mv {params.file_name}.log logs/ml_tree_{wildcards.dataset}_{wildcards.subsampling}.{wildcards.dseed}.log
        """

rule create_dates_file:
    input:
        metadata = rules.combine_subsamples.output.combined
    output:
        #dates = "results/{dataset}/data/dates_{subsampling}.{dseed}.csv",
        dates = "results/{dataset}/data/dates_{subsampling}.{dseed}.csv",
    run:
        md = pd.read_csv(input.metadata, sep = "\t")
        dates = pd.DataFrame() 
        dates["strain"] = md["seq_name"]
        dates["date"] = md["seq_name"].str.split("|", expand = True)[[2]]
        dates.to_csv(output.dates, index = False, header = True, sep = ",")


rule time_tree:
    input:
        dates = rules.create_dates_file.output.dates,
        aln = rules.mask_sequences.output.aln,
        tree = rules.mltree.output.tree,
    output:
        timetree = "results/{dataset}/trees/timetree_{subsampling}.{dseed}.nexus"
    params:
        clock_rate = 0.0008
    conda:
        "envs/treetime.yaml"
    shell:
        """
        treetime --tree {input.tree} \
         --dates {input.dates} \
         --aln {input.aln} \
         --clock-rate {params.clock_rate} \
         --outdir results/{wildcards.dataset}/trees
        """

rule plot_tree:
