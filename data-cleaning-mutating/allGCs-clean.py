import pandas as pd
import numpy as np
import os

# Accessing the file
filePath = "./clusters/catalogues/"
cleanPath = 'clean-clusters/catalogues/'
fileNames = os.listdir(filePath)

for fileName in fileNames:
    # Reading file with pandas
    f_data = pd.read_csv(filePath+fileName, sep="\t", header=0).rename(
        columns=lambda x: x.strip()
    )

    # Filter for stars with a membership probability greater than 95%
    f_data = f_data[f_data.memberprob >= 0.95]
    
    # Add relative RA and Dec. proper motion columns
    f_data['vx'] = f_data.pmra - np.mean(f_data.pmra)
    f_data['vy'] = f_data.pmdec - np.mean(f_data.pmdec)
    
    # Add radius
    f_data['r'] = np.sqrt(f_data['x']**2 + f_data['y']**2)
    
    # Add radial and tangential velocities
    f_data['vR'] = (f_data['vx']*f_data['x']+f_data['vy']*f_data['y'])/f_data['r']
    f_data['vPhi'] = (f_data['x']*f_data['vy']-f_data['y']*f_data['vx'])/f_data['r']

    # Remove useless columns (qflag, Sigma, bp_rp, g_mag)
    f_data = f_data.drop(['bp_rp', 'qflag', 'Sigma', 'g_mag'], axis=1)

    # Reorder columns
    ordered_cols = ['# source_id', 'ra', 'dec', 'pmra', 'pmdec', 'x', 'y', 'r', 'vx', 'vy', 'vR', 'vPhi', 'plx', 'memberprob', 'pmcorr', 'pmrae', 'pmdece', 'plxe']
    f_data = f_data[ordered_cols]

    if fileName == "Pal_5.txt":
        print(f_data)
    # Write clean files
    f_data.to_csv(cleanPath + fileName, sep=',', index=False)

    