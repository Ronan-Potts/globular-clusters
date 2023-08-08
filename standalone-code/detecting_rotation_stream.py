import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib

# Read summarised data
filePath = 'data/clean-clusters/catalogues/'
fileNames = ["NGC_5139_oCen.txt", "NGC_104_47Tuc.txt", "NGC_6273_M_19.txt", "NGC_7078_M_15.txt",
             "NGC_7089_M_2.txt", "NGC_6266_M_62.txt", "NGC_6656_M_22.txt", "NGC_5904_M_5.txt",
             "NGC_6139.txt", "NGC_6809_M_55.txt", "NGC_6402_M_14.txt"]
widths=[0.4, 0.4, 0.05, 0.05, 0.1, 0.05, 0.12, 0.2, 0.05, 0.1, 0.4]
fileNames = ["NGC_6752.txt"]
widths=[0.4]
for fileName,width in zip(fileNames,widths):
    print(fileName, width)
    df_pos_vel = pd.read_csv(filePath + fileName, header=0)

    mean_x = df_pos_vel['x']
    mean_y = df_pos_vel['y']
    mean_vx = df_pos_vel['vx']
    mean_vy = df_pos_vel['vy']

    '''
    Below is code that makes the vector field easier to view. If you wish to see the default vector field, replace the code below with:

    plt.quiver(mean_x, mean_y, mean_vx, mean_vy)
    plt.show()
    '''

    max_x = np.max(mean_x)
    min_x = np.min(mean_x)
    max_y = np.max(mean_y)
    min_y = np.min(mean_y)

    # Define bins for each point in vector field
    n_bins=5

    X_bins = np.arange(min_x, max_x, (max_x - min_x)/n_bins)
    Y_bins = np.arange(min_y, max_y, (max_y - min_y)/n_bins)

    x_width = (X_bins[1] - X_bins[0])/2
    y_width = (Y_bins[1] - Y_bins[0])/2

    X_bins, Y_bins = np.meshgrid(X_bins, Y_bins)

    vx_bins = []
    vy_bins = []
    for i in range(0,len(X_bins)):
        vx = []
        vy = []
        for j in range(0,len(Y_bins[0])):
            # Each boxed bin has bottom-left corner (X1,Y1) and top-right corner (X2,Y2)
            X1 = X_bins[i][j] - x_width
            X2 = X_bins[i][j] + x_width
            Y1 = Y_bins[i][j] - y_width
            Y2 = Y_bins[i][j] + y_width

            # Create filter for only GCs within the box bounded by (X1,X2,Y1,Y2)
            box_filter = (mean_x >= X1) & (mean_x <= X2) & (mean_y >= Y1) & (mean_y <= Y2)

            # Filter for GCs within box bounded by (X1,X2,Y1,Y2)
            filtered_df = df_pos_vel[box_filter]

            vx.append(np.mean(filtered_df['vx']))
            vy.append(np.mean(filtered_df['vy']))
        vx_bins.append(vx)
        vy_bins.append(vy)


    X_bins = np.array(X_bins)
    Y_bins = np.array(Y_bins)
    vx_bins = np.array(vx_bins)
    vy_bins = np.array(vy_bins)


    fig, ax = plt.subplots()
    plt.streamplot(X_bins, Y_bins, vx_bins, vy_bins)
    #plt.xlabel('Right Ascension (deg) relative to GC center')
    #plt.ylabel('Declination (deg) relative to GC center')
    plt.xlabel('')
    plt.ylabel('')
    ax.set_aspect('equal') 
    plt.xlim([-width,width])
    plt.ylim([-width,width])
    plt.xticks(fontsize=24)
    plt.yticks(fontsize=24)
    every_nth = 2
    for n, label in enumerate(ax.xaxis.get_ticklabels()):
        if (n+1) % every_nth != 0:
            label.set_visible(False)
    
    for n, label in enumerate(ax.yaxis.get_ticklabels()):
        if (n+1) % every_nth != 0:
            label.set_visible(False)
    plt.savefig('C:/Users/Ronan/Desktop/isochrones/' + fileName[0:-4])


