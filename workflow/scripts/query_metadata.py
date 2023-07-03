# ------------------------------------------------------------------------------
#          ---        
#        / o o \    Snakemake workflow phylo-BEAST
#        V\ Y /V    Script to query metadata inside snakemake workflow
#    (\   / - \     
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# ------------------------------------------------------------------------------

import ast
import argparse
import numpy as np
import pandas as pd


def attr_dict_to_query(attr_dict):
    s = str(attr_dict)
    query = s.replace(
        " ", "").replace(
        "{", "").replace(
        "}", "").replace(
        "'", "").replace(
        ",", "' & ").replace(
        "From:", " >= '").replace(
        "To:", " <= '").replace(
        "Not:", " != '").replace(
        ":", " == '").replace(
        "\\n", ",") + "'"
    return query


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="query metadata",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument("--metadata", type=str, required=True, help="Metadata file")
    parser.add_argument("--select", type=ast.literal_eval, required=True, help="Select config yaml") 
    parser.add_argument("--seq_id", type=str, required=True, help="Column id to use as sample id")
    parser.add_argument("--deme", type=str, required=True, help="Deme name")
    parser.add_argument("--output", type=str, required=True,  help="Output file for metadata")
    args = parser.parse_args()
    
    metadata = pd.read_csv(args.metadata, sep = "\t", dtype = "str")

    if args.select is not None:
        query = attr_dict_to_query(args.select)
        metadata = metadata.query(query)
    
    ids = metadata[[args.seq_id]]
    print(ids)
    if "sample_id" in metadata:
        ids["sample_id"] = metadata["sample_id"]
    elif args.deme is not None:
        ids["sample_id"] = metadata["seq_id"] + "|" + args.deme + "|" + metadata["date"]
    else:
        ids["sample_id"] = metadata["seq_id"] + "|" + metadata["date"]

    print(ids)

    ids.to_csv(args.output, index = False, sep="\t")

