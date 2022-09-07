import pandas as pd
import numpy as np
import os

# Accessing the file
filePath = 'data/clean-clusters/'
fileNames = os.listdir(filePath)

for fileName in fileNames:
    f_data = pd.read_csv(filePath+fileName)

    f_data = f_data[abs(f_data.plxe) < 0.1*abs(f_data.plx)]

    '''
    Approximately 0.1% of data has a parallax error of less than 1/10th the parallax.
    We probably shouldn't look at parallax as a reliable measure of distance, unless we consider sampling and calculate sample errors.
    Sampling would require a hypothesis for the distance distribution of stars in GCs, which we don't really have (ask Ciaran).
    '''

    if fileName == "NGC_5139_oCen.txt":
        print(f_data.plxe)
        print(len(f_data.plxe))
