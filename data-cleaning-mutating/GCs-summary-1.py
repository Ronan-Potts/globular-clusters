'''
The purpose of this file is to map the GCs onto a 2D surface with which we can visualise the positions of the GCs and
potentially create a vector field of the velocities of each GC. I am using equations (1) and (6) from 
https://mathworld.wolfram.com/MercatorProjection.html. Here, right ascension (RA) is the analogue for longitude, while
declination is the analogue for latitude.

The Mercator projection is used as it keeps lines of latitude and longitude parallel and straight, meaning it may be
easier to see a broader rotation or movement in the globular clusters.
'''

import pandas as pd
import numpy as np
import os


# Accessing the file
filePath = 'data/clean-clusters/catalogues/'
fileNames = os.listdir(filePath)

mean_x = []
mean_y = []
mean_vx = []
mean_vy = []
mean_vR = []
mean_vPhi = []
size = []
names = []

firstFile = True
for fileName in fileNames:
    f_data = pd.read_csv(filePath+fileName,header=0)
    
    f_data = f_data.drop(['x', 'y', 'vx', 'vy', 'plx', 'memberprob', 'pmcorr', 'plxe'], axis=1)

    longitude = f_data['ra']
    latitude = f_data['dec']

    f_data['x_mercator'] = longitude - 180
    f_data['y_mercator'] = np.log(np.tan(np.deg2rad(latitude)) + (1/np.cos(np.deg2rad(latitude))))

    mean_x_mercator = np.mean(f_data['x_mercator'])
    mean_y_mercator = np.mean(f_data['y_mercator'])
    mean_vx_mercator = np.mean(f_data['pmra'])
    mean_vy_mercator = np.mean(f_data['pmdec'])

    mean_x.append(mean_x_mercator)
    mean_y.append(mean_y_mercator)
    mean_vx.append(mean_vx_mercator)
    mean_vy.append(mean_vy_mercator)
    mean_vR.append(np.mean(f_data['vR']))
    mean_vPhi.append(np.mean(f_data['vPhi']))
    size.append(len(f_data['ra']))
    names.append(fileName)

# Summarise current data into a DataFrame
df_pos_vel = pd.DataFrame(list(zip(names, mean_x,mean_y,mean_vx,mean_vy,size)), columns=['file_name', 'mean_x','mean_y','mean_vx','mean_vy', 'size'])

# Write summarised data for each GC into a file.
df_pos_vel.to_csv('data/clean-clusters/GCs_Summary.txt', sep=',', index=False)
