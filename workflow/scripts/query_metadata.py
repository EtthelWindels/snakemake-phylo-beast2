# ------------------------------------------------------------------------------
#          ---        
#        / o o \    Snakemake workflow phylo-BEAST
#        V\ Y /V    Script to query metadata inside snakemake workflow
#    (\   / - \     
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# ------------------------------------------------------------------------------

import urllib, json, requests, os, sys, ast
import argparse
import numpy as np
import pandas as pd


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="query metadata",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument("--metadata", type=ast.literal_eval, required=True, help="Metadata file")
    parser.add_argument("--select", type=ast.literal_eval, required=True, help="Select config yaml") 
    parser.add_argument("--deme", type=str, required=True, help="Deme name")
    parser.add_argument("--output", type=str, required=True,  help="Output file for metadata")
    args = parser.parse_args()
    
    #TODO give option to pass query in select property

    if args.select.get('ids_file') is None:
        data = query_dataframe(args.metadata, args.select) #TODO, maybe create query and here jsut called pandas query method

        # if 'exclude_country' in attributes: # TODO include negation in query
        #     data = data.query("country not in @attributes['exclude_country']").reset_index()
            
    else:
        ids = pd.read_csv(args.select['ids_file'], sep=None)
        id = ids.columns.values
        data = metadata.query('@id in @ids')
        
    
    data['deme'] = args.deme
    data.to_csv(args.output, index = False, sep="\t")

