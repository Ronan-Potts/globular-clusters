'''
This file grabs summarised data of each GC, including coordinates of the GCs after being projected onto a 2D map using the Mercator projection.
The Mercator projection is used as it keeps lines of latitude and longitude parallel and straight, meaning it may be easier to see a general
movement in the globular clusters.
'''

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib

# Read summarised data
df_pos_vel = pd.read_csv('data/clean-clusters/GCs_Summary.txt', header=0)

mean_x = df_pos_vel['mean_x']
mean_y = df_pos_vel['mean_y']
mean_vx = df_pos_vel['mean_vx']
mean_vy = df_pos_vel['mean_vy']

'''
Below is code that makes the vector field easier to view. If you wish to see the default vector field, replace the code below with:

plt.quiver(mean_x, mean_y, mean_vx, mean_vy)
plt.show()
'''

# Define bins for each point in vector field
n_bins=30
# Repeat each value in mean_x element-wise n_bins times
x_bins = np.repeat(np.linspace(min(mean_x), max(mean_x), n_bins), n_bins)
# Stack the mean_y array onto itself n_bins times
y_bins = np.tile(np.linspace(min(mean_y), max(mean_y), n_bins), n_bins)

# Initialise position arrays for vector field positions
X_bins = []
Y_bins = []
# Initialise velocity arrays for vector field vectors
vx_bins = []
vy_bins = []
# Initialise size for vector field color
size_bins = []

# 2D vector field -> 2D (i,j) coordinate system
for i in range(0,n_bins-1):
    for j in range(0,n_bins-1):
        # Each boxed bin has bottom-left corner (X1,Y1) and top-right corner (X2,Y2)
        X1 = x_bins[j+n_bins*i]
        X2 = x_bins[j+n_bins*(i+1)]
        Y1 = y_bins[j+n_bins*i]
        Y2 = y_bins[j+1+n_bins*i]

        # Find center of each box and define as (X_bins, Y_bins) for plt.quiver()
        X_bins.append((X1+X2)/2)
        Y_bins.append((Y1+Y2)/2)

        # Get x and y positions of each GC
        x_pos = df_pos_vel['mean_x']
        y_pos = df_pos_vel['mean_y']

        # Create filter for only GCs within the box bounded by (X1,X2,Y1,Y2)
        box_filter = (x_pos >= X1) & (x_pos <= X2) & (y_pos >= Y1) & (y_pos <= Y2)

        # Filter for GCs within box bounded by (X1,X2,Y1,Y2)
        filtered_df = df_pos_vel[box_filter]

        # Append mean velocity of GCs in box bounded by (X1,X2,Y1,Y2) to velocity arrays.
        # Append number of stars in each box to size_bins array.
        if len(filtered_df) != 0:
            vx_bins.append(np.mean(filtered_df['mean_vx']))
            vy_bins.append(np.mean(filtered_df['mean_vy']))
            size_bins.append(np.sum(filtered_df['size']))
        else:
            vx_bins.append(0)
            vy_bins.append(0)
            size_bins.append(0)

# Create colormap and ScalarMappable to show the sizes of each aggregation of globular clusters.
norm = matplotlib.colors.Normalize()
norm.autoscale(size_bins/np.sum(size_bins))
cm = matplotlib.cm.winter

sm = matplotlib.cm.ScalarMappable(cmap=cm, norm=norm)
sm.set_array([])

# Plot vector field and colorbar
plt.quiver(X_bins, Y_bins, vx_bins, vy_bins, pivot="mid", width=0.0025, scale=25*n_bins/3, color=cm(norm(size_bins)))
cbar = plt.colorbar(sm)
cbar.set_label('# stars (proportion)')
plt.xlabel('Right Ascension [deg] - 180 [deg]')
plt.ylabel('ln(tan(Dec. [deg]) + sec(Dec. [deg]))')
plt.show()


