'''
This file is used to clean the raw isochrone data from http://stev.oapd.inaf.it/cgi-bin/cmd_3.6 with the following inputs:

Evolutionary tracks (DEFAULT)

    PARSEC: PARSEC version 1.2S
    COLIBRI: + COLIBRI S_37 (Pastorelli et al. (2020)) for 0.008≤Z≤0.02, + COLIBRI S_35 (Pastorelli et al. (2019)) for 0.0005≤Z≤0.006 + COLIBRI PR16 (Marigo et al. (2013), Rosenfield et al. (2016)) for Z≤0.0002 and Z≥0.03 )

Photometric system:

    SYSTEM: Gaia EDR3 (all Vegamags, Gaia passbands from ESA/Gaia website)
    VERSION (DEFAULT): YBC + new Vega

Circumstellar dust (DEFAULT): Using scaling relations as in Marigo et al. (2008)

    for M stars: 60% Silicate + 40% AlOx as in Groenewegen (2006)
    for C stars: 85% AMC + 15% SiC as in Groenewegen (2006)

Interstellar extinction (MOSTLY DEFAULT):

    Total extinction A_V = (given A_v for GC).
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

        ( UPDATE - JUST USED VALUES FOUND IN https://arxov.prg/pdf/1308.2257.pdf )

    [M/H]:

        Initial value: -2.4
        Final value: 0
        Step: 0.15

        ( UPDATE - JUST USED VALUES FOUND IN HARRIS DATA FOR PARTICULAR GC )

Output:

    Isochrone tables: stellar parameters as a function of initial mass
'''


'''
A_v is as follows:

/ NGC_104_47Tuc = 0.124
X NGC_2298      = 0.434
X NGC_362       = 0.155
X NGC_4147      = 0.062
X NGC_4590_M_68 = 0.155
X NGC_4833      = 0.992
/ NGC_5139_oCen = 0.372
/ NGC_5904_M_5  = 0.093
X NGC_6101      = 0.155
X NGC_6121_M_4  = 1.085
/ NGC_6139      = 2.325
X NGC_6144      = 1.116
X NGC_6218_M_12 = 0.589
X NGC_6254_M_10 = 0.868
/ NGC_6266_M_62 = 1.457
/ NGC_6273_M_19 = 1.178
X NGC_6333_M_9  = 1.178
X NGC_6341_M_92 = 0.062
X NGC_6388      = 1.147
/ NGC_6402_M_14 = 1.86
/ NGC_6539      = 3.162
/ NGC_6656_M_22 = 1.054
X NGC_6681_M_70 = 0.217
X NGC_6715_M_54 = 0.465
X NGC_6752      = 0.124
X NGC_6779_M_56 = 0.806
/ NGC_6809_M_55 = 0.248
/ NGC_7078_M_15 = 0.31
/ NGC_7089_M_2  = 0.186
'''

import pandas as pd

# re package used for regular expressions
import re


gcNames = ["NGC_104_47Tuc/", "NGC_5139_oCen/", "NGC_5904_M_5/", "NGC_6139/", "NGC_6266_M_62/", "NGC_6273_M_19/", "NGC_6402_M_14/", "NGC_6539/", "NGC_6656_M_22/", "NGC_6809_M_55/", "NGC_7078_M_15/", "NGC_7089_M_2/"]

for gcName in gcNames:
    # Accessing the file
    filePath = "./data/isochrones/raw/" + gcName
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
            isochrone_df_j = isochrone_df_j[["Gmag", "G_BPmag", "G_RPmag", "logAge", "MH"]]
            # Write clean file
            isochrone_df_j.to_csv('./data/isochrones/clean/' + gcName + 'isochrone_'+str(j)+'.txt', sep=',', index=False, header=0)
            isochrone_j = [row.values]
            j += 1
        else:
            isochrone_j.append(row.values)