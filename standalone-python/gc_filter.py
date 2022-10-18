'''
Modifying GC data by filtering. If there are fewer than 1% Of data points in a specific region around a point,
delete that point.
'''

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os


# Accessing the file
gcPath = 'data/clean-clusters/catalogues/'
# gcNames = os.listdir(gcPath)
# gcNames = ["NGC_104_47Tuc.txt", "NGC_2298.txt", "NGC_362.txt", "NGC_4147.txt", "NGC_4590_M_68.txt", "NGC_4833.txt", "NGC_5139_oCen.txt", "NGC_5904_M_5.txt", "NGC_6101.txt", "NGC_6121_M_4.txt", "NGC_6139.txt", "NGC_6144.txt", "NGC_6218_M_12.txt", "NGC_6254_M_10.txt", "NGC_6266_M_62.txt", "NGC_6273_M_19.txt", "NGC_6333_M_9.txt", "NGC_6341_M_92.txt", "NGC_6388.txt", "NGC_6402_M_14.txt", "NGC_6539.txt", "NGC_6656_M_22.txt", "NGC_6681_M_70.txt", "NGC_6715_M_54.txt", "NGC_6752.txt", "NGC_6779_M_56.txt", "NGC_6809_M_55.txt", "NGC_7078_M_15.txt", "NGC_7089_M_2.txt", "Terzan_3.txt"]
gcNames = ["NGC_104_47Tuc.txt", "NGC_5139_oCen.txt", "NGC_5904_M_5.txt", "NGC_6139.txt", "NGC_6266_M_62.txt", "NGC_6273_M_19.txt", "NGC_6402_M_14.txt", "NGC_6539.txt", "NGC_6656_M_22.txt", "NGC_6809_M_55.txt", "NGC_7078_M_15.txt", "NGC_7089_M_2.txt"]

harris_data = pd.read_csv('data/clusters-harris/clean/merged_data.txt')

gc_fitting_isochrones = []

gc_difs_dict = {}
for gcName in gcNames:
    gc_data = pd.read_csv(gcPath + gcName, header=0).dropna(subset=["bp_rp", "g_mag"])
    gc_bp_rp = np.array(gc_data['bp_rp'])

    r_pc = 1000*harris_data[harris_data["Name"]==gcName]["R_sun"].to_list()[0]
    gc_gmag = np.array(gc_data['g_mag'] - 5*np.log10(r_pc/10))

    num_points = len(gc_gmag)

    plt.scatter(gc_bp_rp, gc_gmag)
    plt.gca().invert_yaxis()
    plt.show()

    # Define box width
    width_g = ( max(gc_gmag) - min(gc_gmag) )/20
    width_br = ( max(gc_bp_rp) - min(gc_bp_rp) )/20
    
    i = 0
    while i < len(gc_gmag):
        if i%200 == 0:
            print(i, len(gc_gmag))
        # Get points
        gc_g = gc_gmag[i]
        gc_br = gc_bp_rp[i]
        if gc_g in np.delete(gc_gmag, i):
            if gc_br in np.delete(gc_bp_rp, i):
                gc_gmag = np.delete(gc_gmag, i)
                gc_bp_rp = np.delete(gc_bp_rp, i)
                continue

        # Find number of points in box
        filter = np.logical_and(abs(gc_gmag - gc_g) <= width_g/2, abs(gc_bp_rp - gc_br) <= width_br/2)
        current_num = len(gc_gmag[filter])
        if gc_g <= 0 and gc_br >= 3:
            print(current_num, num_points/50)
        if current_num <= num_points/50:
            filter = np.logical_and(gc_gmag != gc_g, gc_bp_rp != gc_br)
            gc_gmag = gc_gmag[filter]
            gc_bp_rp = gc_bp_rp[filter]
        else:
            i += 1
    

    plt.scatter(gc_bp_rp, gc_gmag)
    plt.gca().invert_yaxis()
    plt.show()

    f_data = pd.DataFrame(list(zip(gc_gmag, gc_bp_rp)), columns=["g_mag", "bp_rp"])
    f_data.to_csv('data/clean-clusters/filtered/' + gcName, sep=',', index=False)