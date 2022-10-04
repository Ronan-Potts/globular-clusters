'''
This file uses a chi-squared parameter to find the best fitting isochrones to the GC data. The GC data plots g_mag against bp_rp. The analogues in the isochrone data are as follows:

    g_mag:     Gmag

    bp_rp:     (G_BPbrmag   OR   G_BPftmag) - G_RPmag

Concerns:

    * Isochrone data is from Gaia DR2 while GC data is from Gaia EDR3

'''

import pandas as pd
import numpy as np
import os


# Accessing the file
gcPath = 'data/clean-clusters/catalogues/'
# gcNames = os.listdir(gcPath)
gcNames = ["NGC_104_47Tuc.txt", "NGC_2298.txt", "NGC_362.txt", "NGC_4147.txt", "NGC_4590_M_68.txt", "NGC_4833.txt", "NGC_5139_oCen.txt", "NGC_5904_M_5.txt", "NGC_6101.txt", "NGC_6121_M_4.txt", "NGC_6139.txt", "NGC_6144.txt", "NGC_6218_M_12.txt", "NGC_6254_M_10.txt", "NGC_6266_M_62.txt", "NGC_6273_M_19.txt", "NGC_6333_M_9.txt", "NGC_6341_M_92.txt", "NGC_6388.txt", "NGC_6402_M_14.txt", "NGC_6539.txt", "NGC_6656_M_22.txt", "NGC_6681_M_70.txt", "NGC_6715_M_54.txt", "NGC_6752.txt", "NGC_6779_M_56.txt", "NGC_6809_M_55.txt", "NGC_7078_M_15.txt", "NGC_7089_M_2.txt", "Terzan_3.txt"]


gc_fitting_isochrones = []



for gcName in gcNames:
    gc_data = pd.read_csv(gcPath + gcName, header=0)
    gc_bp_rp = gc_data['bp_rp']
    gc_gmag = gc_data['g_mag']

    isoPath = 'data/isochrones/clean/'
    isoNames = os.listdir(isoPath)

    first_isochrone = True
    for isoName in isoNames:
        iso_data = pd.read_csv(isoPath + isoName, header=0)
        iso_bp_rp = iso_data['G_BPbrmag'] - iso_data['G_RPmag']
        iso_gmag = iso_data['Gmag']

        
        '''
        Add code here to minimise isochrone
        '''

        # if chi_sq is one of the 10 smallest values, ...
        
        # just get the number of the isochrone
        if first_isochrone:
            fitting_isos = isoName[:-4]
            first_isochrone = False
        else:
            fitting_isos = fitting_isos + ' ' + isoName[:-4]

    gc_fitting_isochrones.append(fitting_isos)

    print(gcName, "done!")

gc_fitting_isochrones = pd.DataFrame(list(zip(gcNames, gc_fitting_isochrones)), columns=['file_name', 'fitting_isochrone_js'])
gc_fitting_isochrones.to_csv('data/clean-clusters/GCs_fitting_isochrones.txt', sep=',', index=False)