import pandas as pd
import numpy as np
import os
import re

'''
The Harris data was not written in a very computer friendly way, and the naming convention for the GCs is different
from the naming convention used in the clean-clusters data. This file cleans the Harris data, making it an actual
dataframe, and merges the names of the two datasets. Note that a few GCs do not appear in both datasets. These include:

(in Harris data but not in clean-clusters data)
2MS-GC01
2MS-GC02
GLIMPSE02
GLIMPSE01

(in clean-clusters data but not in Harris data)
BH_140.txt
Bliss_1.txt
Crater.txt
ESO_93-8.txt
FSR_1716.txt
FSR_1758.txt
Gran_1.txt
Kim_3.txt
Laevens_3.txt
Mercer_5.txt
Munoz_1.txt
Pfleiderer_2.txt
Ryu_059_RLGC1.txt
Ryu_879_RLGC2.txt
Segue_3.txt
VVV_CL001.txt
VVV_CL002.txt
'''

'''
IDs and Positional data
'''

# Accessing the file
filePath = "./data/clusters-harris/raw/"
fileNames = os.listdir(filePath)
fileName = "id_position_data.txt"

f_data = pd.read_csv(filePath + fileName, sep="\t", header=0).rename(
        columns=lambda x: x.strip()
    )

# Rewrite dataframe so that it has columns with actual separators
id_position_df = []
for index, row in f_data.iterrows():
    row.values[0] = row.values[0].strip()
    # Split into sections that will be dealt with individually
    row.values[0] = [row.values[0][0:24], row.values[0][24:65], row.values[0][65:]]
    # Section 1 (ID, name)
    row.values[0][0] = re.sub(" {2,13}", "\t", row.values[0][0])
    row.values[0] = row.values[0][0].split(sep="\t")[:-1] + [row.values[0][1]] + [row.values[0][2]]
    # Section 2 (RA, Dec, L, B)
    row.values[0][-2] = re.sub(" {2,}", '\t', row.values[0][-2])
    row.values[0] = row.values[0][0:-2] + row.values[0][-2].split(sep='\t') + [row.values[0][-1]]
    # Section 3 (R_sun, R_gc, X, Y, Z)
    row.values[0][-1] = re.sub(" +", "\t", row.values[0][-1])
    row.values[0] = row.values[0][0:-1] + row.values[0][-1].split(sep='\t')[1:]
    # Merge ID and Name into single Name
    if row.values[0][1] != '':
        if row.values[0][1][0] == "M":
            row.values[0][0:2] = [re.sub(" +", "_", row.values[0][0]) + '_' + re.sub(" +", "_", row.values[0][1]) + ".txt"]
        else:
            row.values[0][0:2] = [re.sub(" +", "_", row.values[0][0]) + '_' + re.sub(" +", "", row.values[0][1]) + ".txt"]
    else:
        row.values[0][0:2] = [re.sub(" +", "_", row.values[0][0]) + ".txt"]

    # Manually match Name in Harris data to file_name in GCs_Summary.txt
#    g_data = pd.read_csv('./clean-clusters/GCs_Summary.txt')
#    file_names = g_data['file_name'].tolist()
#    while row.values[0][0] not in file_names:
#        print(row.values[0][0], "is not in GCs_Summary.txt. Please input the correct name, as shown in GCs_Summary.txt, for", row.values[0][0])
#        real_name = input()
#        row.values[0][0] = real_name + ".txt"
#        if real_name == "remove":
#            break
    id_position_df.append(row.values[0])

# Write new DF
id_position_df = pd.DataFrame(id_position_df, columns=["Name", "RA", "DEC", "L", "B", "R_sun", "R_gc", "X", "Y", "Z"])
# Rewrite names of GCs using the manual method that was commented out above
id_position_df["Name"] = ['NGC_104_47Tuc.txt', 'NGC_288.txt', 'NGC_362.txt', 'Whiting_1.txt', 'NGC_1261.txt', 'Pal_1.txt', 'AM_1.txt', 'Eridanus.txt', 'Pal_2.txt', 'NGC_1851.txt', 'NGC_1904_M_79.txt', 'NGC_2298.txt', 'NGC_2419.txt', 'Ko_2.txt', 'Pyxis.txt', 'NGC_2808.txt', 'E_3.txt', 'Pal_3.txt', 'NGC_3201.txt', 'Pal_4.txt', 'Ko_1.txt', 'NGC_4147.txt', 'NGC_4372.txt', 'Rup_106.txt', 'NGC_4590_M_68.txt', 'NGC_4833.txt', 'NGC_5024_M_53.txt', 'NGC_5053.txt', 'NGC_5139_oCen.txt', 'NGC_5272_M_3.txt', 'NGC_5286.txt', 'AM_4.txt', 'NGC_5466.txt', 'NGC_5634.txt', 'NGC_5694.txt', 'IC_4499.txt', 'NGC_5824.txt', 'Pal_5.txt', 'NGC_5897.txt', 'NGC_5904_M_5.txt', 'NGC_5927.txt', 'NGC_5946.txt', 'BH_176.txt', 'NGC_5986.txt', 'Lynga_7_BH184.txt', 'Pal_14.txt', 'NGC_6093_M_80.txt', 'NGC_6121_M_4.txt', 'NGC_6101.txt', 'NGC_6144.txt', 'NGC_6139.txt', 'Terzan_3.txt', 'NGC_6171_M107.txt', 'ESO452-11.txt', 'NGC_6205_M_13.txt', 'NGC_6229.txt', 'NGC_6218_M_12.txt', 'FSR_1735.txt', 'NGC_6235.txt', 'NGC_6254_M_10.txt', 'NGC_6256.txt', 'Pal_15.txt', 'NGC_6266_M_62.txt', 'NGC_6273_M_19.txt', 'NGC_6284.txt', 'NGC_6287.txt', 'NGC_6293.txt', 'NGC_6304.txt', 'NGC_6316.txt', 'NGC_6341_M_92.txt', 'NGC_6325.txt', 'NGC_6333_M_9.txt', 'NGC_6342.txt', 'NGC_6356.txt', 'NGC_6355.txt', 'NGC_6352.txt', 'IC_1257.txt', 'Terzan_2_HP_3.txt', 'NGC_6366.txt', 'Terzan_4_HP_4.txt', 'HP_1_BH_229.txt', 'NGC_6362.txt', 'Liller_1.txt', 'NGC_6380_Ton1.txt', 'Terzan_1_HP_2.txt', 'Ton2_Pismis26.txt', 'NGC_6388.txt', 'NGC_6402_M_14.txt', 'NGC_6401.txt', 'NGC_6397.txt', 'Pal_6.txt', 'NGC_6426.txt', 'Djorg_1.txt', 'Terzan_5_11.txt', 'NGC_6440.txt', 'NGC_6441.txt', 'Terzan_6_HP_5.txt', 'NGC_6453.txt', 'UKS_1.txt', 'NGC_6496.txt', 'Terzan_9.txt', 'Djorg_2_ESO456-.txt', 'NGC_6517.txt', 'Terzan_10.txt', 'NGC_6522.txt', 'NGC_6535.txt', 'NGC_6528.txt', 'NGC_6539.txt', 'NGC_6540_Djorg.txt', 'NGC_6544.txt', 'NGC_6541.txt', 'remove.txt', 'ESO280-06.txt', 'NGC_6553.txt', 'remove.txt', 'NGC_6558.txt', 'IC_1276_Pal_7.txt', 'Terzan_12.txt', 'NGC_6569.txt', 'BH_261_AL_3.txt', 'remove.txt', 'NGC_6584.txt', 'NGC_6624.txt', 'NGC_6626_M_28.txt', 'NGC_6638.txt', 'NGC_6637_M_69.txt', 'NGC_6642.txt', 'NGC_6652.txt', 'NGC_6656_M_22.txt', 'Pal_8.txt', 'NGC_6681_M_70.txt', 'remove.txt', 'NGC_6712.txt', 'NGC_6715_M_54.txt', 'NGC_6717_Pal9.txt', 'NGC_6723.txt', 'NGC_6749.txt', 'NGC_6752.txt', 'NGC_6760.txt', 'NGC_6779_M_56.txt', 'Terzan_7.txt', 'Pal_10.txt', 'Arp_2.txt', 'NGC_6809_M_55.txt', 'Terzan_8.txt', 'Pal_11.txt', 'NGC_6838_M_71.txt', 'NGC_6864_M_75.txt', 'NGC_6934.txt', 'NGC_6981_M_72.txt', 'NGC_7006.txt', 'NGC_7078_M_15.txt', 'NGC_7089_M_2.txt', 'NGC_7099_M_30.txt', 'Pal_12.txt', 'Pal_13.txt', 'NGC_7492.txt']
# Get rid of "remove.txt" entries which don't show up in both files
id_position_df = id_position_df[id_position_df["Name"] != "remove.txt"].sort_values("Name")

# Write clean file
id_position_df.to_csv('./data/clusters-harris/clean/id_position_data.txt', sep=',', index=False)
'''
Checking for GCs in clean-clusters which aren't in Harris data
'''

f_data = pd.read_csv('./data/clean-clusters/GCs_Summary.txt', sep=',', header=0)

for name in f_data["file_name"]:
    if name not in id_position_df["Name"].tolist():
        print(name)