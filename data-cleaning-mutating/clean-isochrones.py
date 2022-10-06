'''
This file is used to clean the raw isochrone data from http://stev.oapd.inaf.it/cgi-bin/cmd_3.6 with the following inputs:

Evolutionary tracks (DEFAULT)

    PARSEC: PARSEC version 1.2S
    COLIBRI: + COLIBRI S_37 (Pastorelli et al. (2020)) for 0.008≤Z≤0.02, + COLIBRI S_35 (Pastorelli et al. (2019)) for 0.0005≤Z≤0.006 + COLIBRI PR16 (Marigo et al. (2013), Rosenfield et al. (2016)) for Z≤0.0002 and Z≥0.03 )

Photometric system:

    SYSTEM: Gaia's DR2 G, G_BP and G_RP (Vegamags, Gaia passbands from Maiz-Apellaniz and Weiler 2018)
    VERSION (DEFAULT): YBC + new Vega

Circumstellar dust (DEFAULT): Using scaling relations as in Marigo et al. (2008)

    for M stars: 60% Silicate + 40% AlOx as in Groenewegen (2006)
    for C stars: 85% AMC + 15% SiC as in Groenewegen (2006)

Interstellar extinction (DEFAULT):

    Total extinction A_V = 0.0 mag.
    Apply this extinction using extinction coefficients computed star-by-star (except for the OBC case, which uses constant coefficients)
    Adopted extinction curve: Cardelli et al. (1989) + O'Donnell (1994), with R_V = 3.1

Long Period Variability (DEFAULT):

    3. Periods from Trabucchi et al. (2021)

Initial mass function (DEFAULT):

    Kroupa (2001, 2002) canonical two-part-power law IMF, corrected for unresolved binaries

Ages/metallicities:

    Linear age (yr):
        
        Initial value: 9.0e9
        Final value: 14.0e9
        Step: 0.25e9 yr

    [M/H]:

        Initial value: -2.4
        Final value: 0
        Step: 0.15

Output:

    Isochrone tables: stellar parameters as a function of initial mass
'''

import pandas as pd

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
    line = line.strip()
    lines[i] = re.sub("[ \t]+", ",", line).split(',')
    lines[i] = [line.strip() for line in lines[i]]
    i += 1

isochrones_df = pd.DataFrame(lines)

j = 1
isochrone_j = []
for index,row in isochrones_df.iterrows():
    if row[0] == "Zini" and len(isochrone_j) not in [1,0]:
        isochrone_df_j = pd.DataFrame(isochrone_j)
        isochrone_df_j.columns = isochrone_df_j.iloc[0]
        isochrone_df_j = isochrone_df_j[["Gmag", "G_BPbrmag", "G_BPftmag", "G_RPmag"]]
        # Write clean file
        isochrone_df_j.to_csv('./data/isochrones/clean/isochrone_'+str(j)+'.txt', sep=',', index=False, header=0)
        isochrone_j = [row.values]
        j += 1
    else:
        isochrone_j.append(row.values)