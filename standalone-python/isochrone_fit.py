'''
This file uses a chi-squared parameter to find the best fitting isochrones to the GC data. The GC data plots g_mag against bp_rp. The analogues in the isochrone data are as follows:

    g_mag:     Gmag

    bp_rp:     (G_BPbrmag   OR   G_BPftmag) - G_RPmag

Concerns:

    * Isochrone data is from Gaia DR2 while GC data is from Gaia EDR3


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
import numpy as np
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
    gc_bp_rp = gc_data['bp_rp']

    r_pc = 1000*harris_data[harris_data["Name"]==gcName]["R_sun"].to_list()[0]
    gc_gmag = gc_data['g_mag'] - 5*np.log10(r_pc/10)

    isoPath = 'data/isochrones/clean/' + gcName[0:-4] + "/"
    isoNames = os.listdir(isoPath)


    first_isochrone = True
    difs = {}
    for isoName in isoNames:
        iso_data = pd.read_csv(isoPath + isoName, header=0)
        iso_bp_rp = iso_data['G_BPmag'] - iso_data['G_RPmag']
        iso_gmag = iso_data['Gmag']

        
        '''
        Add code here to minimise isochrone. Will use chi-squared.

            iso_gmag: the G-band magnitude of each isochrone in data/isochrones/clean/<GCNAME>/<ISOCHRONE_FILE>
            iso_bp_rp: the BP - RP magnitude of each isochrone in data/isochrones/clean/<GCNAME>/<ISOCHRONE_FILE>
        '''
        diff_sq = 0
        for g_mag in iso_gmag:
            # Get index so that I can define an isochrone G-band magnitude "range", which will allow me to filter for G_mag in that range for each GC.
            g_mag_index = iso_gmag[iso_gmag == g_mag].index[0]
            if g_mag_index != len(iso_gmag)-1:
                g_mag_later = iso_gmag[g_mag_index+1]
            else:
                g_mag_later = g_mag
            
            if g_mag_index != 0:
                g_mag_earlier = iso_gmag[g_mag_index-1]
            else:
                g_mag_earlier = g_mag
            
            # Range of isochrone G magnitude is [ 1/2 ( g_mag_i - g_mag_{i-1} )   ,    1/2 ( g_mag_{i+1} - g_mag_i ) ]
            range_upper = abs((g_mag_later - g_mag)/2)
            range_lower = abs((g_mag - g_mag_earlier)/2)

            # Filter gc data for gc_mag in isochrone G magnitude range.
            filter_gc_bp_rp = gc_bp_rp[(gc_gmag <= g_mag + range_upper) & (gc_gmag >= g_mag - range_lower)]
            # Should be at most two values in filter_iso_bp_rp
            filter_iso_bp_rp = iso_bp_rp[(iso_gmag <= g_mag + range_upper) & (iso_gmag >= g_mag - range_lower)]
            
            # Calculate difference squared of point from all points in GC
            for bp_rp_val in filter_iso_bp_rp:
                '''
                Issue: if filter_GC_bp_rp has main peaks, and the isochrone has two bp_rp values, then difference squared
                should be between those points individually, not combined.
                '''
                # Difference between GC values and isochrone bp_rp value
                diff_sq += sum((pd.array(filter_gc_bp_rp) - bp_rp_val)**2)
        difs[isoName] = diff_sq / len(iso_gmag)
        print(isoName, "done for", gcName)
    
    gc_difs_dict[gcName] = difs
    print("\n" + gcName, "done!", "\n")

for name in gcNames:
    # chi_sq_dict has the form {'isochrone_1.txt': 4283022.063089403, 'isochrone_10.txt': 4037561.0752140614, ... }
    chi_sq_dict = gc_difs_dict[name]
    # Sort the chi_sq values and get the smallest 10.
    sorted_vals = list(chi_sq_dict.values())
    sorted_vals.sort()
    smallest_10 = sorted_vals[0:10]

    # Identify the isochrones corresponding to the smallest 10 values.
    best_isochrones = []
    ordered_values = []
    for small_chi_sq in smallest_10:
        for key, value in chi_sq_dict.items():
            if value == small_chi_sq:
                best_isochrones.append(key)
                ordered_values.append(value)
    
    if name == gcNames[0]:
        gc_fitting_isochrones = pd.DataFrame({name: best_isochrones})
        gc_fitting_isochrone_vals = pd.DataFrame({name: ordered_values})
    else:
        gc_fitting_isochrones.insert(column=name, value=best_isochrones, loc=len(gc_fitting_isochrones.columns))
        gc_fitting_isochrone_vals.insert(column=name, value=ordered_values, loc=len(gc_fitting_isochrone_vals.columns))

gc_fitting_isochrones.to_csv('data/clean-clusters/GCs_real_fitting_isochrones.txt', sep=',', index=False)
gc_fitting_isochrone_vals.to_csv('data/clean-clusters/GCs_real_fitting_isochrones_vals.txt', sep=',', index=False)