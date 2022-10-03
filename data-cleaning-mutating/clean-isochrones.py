import pandas as pd
import numpy as np
import os

# re package used for regular expressions
import re



# Accessing the file
filePath = "./data/isochrones/raw/"
fileName = "isochrones.txt"

lines = open(filePath + fileName, "r").readlines()

i = 0
for line in lines:
    if line[0] == "#":
        line = line[2:]
    lines[i] = re.sub(" +", ",", line)[0:-1].split(",")
    lines[i] = [line.strip() for line in lines[i]]
    i += 1

isochrones_df = pd.DataFrame(lines)

j = 1
isochrone_j = []
for index,row in isochrones_df.iterrows():
    if row[0] == "Zini" and len(isochrone_j) not in [1,0]:
        isochrone_df_j = pd.DataFrame(isochrone_j)
        # Write clean file
        isochrone_df_j.to_csv('./data/isochrones/clean/isochrone_'+str(j)+'.txt', sep=',', index=False, header=0)
        isochrone_j = [row.values]
        j += 1
    else:
        isochrone_j.append(row.values)