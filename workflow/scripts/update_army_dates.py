# ------------------------------------------------------------------------------
#          ---        
#        / o o \    Project:  cov-euphydyn
#        V\ Y /V    Script to update date of army sequences
#    (\   / - \     25 October 2022
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# ------------------------------------------------------------------------------

import argparse
import numpy as np
import pandas as pd
from isoweek import Week

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="query lapis metadata",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument("--input", type=str, required=True,  help="Input file for metadata")
    parser.add_argument("--output", type=str, required=True,  help="Output file for metadata")
    args = parser.parse_args()
    

    metadata = pd.read_csv(args.input, sep="\t")
    metadata["full_date"] = metadata["date"]
    metadata["date"] = pd.to_datetime(metadata['full_date']).dt.to_period('W').dt.start_time
    metadata.to_csv(args.output, index = False, sep="\t")

    print("Updated dates for army screening sequences!")

