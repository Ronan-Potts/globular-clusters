# Here, I summarise data by finding the rotational velocity of each GC. This is done
# using the nls() function. If any errors occur then I define the GC as not rotating.
library(tidyverse)

filePath <- "../data/clean-clusters/catalogues/"
fileNames = c('AM_1', 'AM_4', 'Arp_2', 'BH_176', 'BH_261_AL_3', 'Djorg_1', 'Djorg_2_ESO456-', 'Eridanus', 'ESO280-06', 'ESO452-11', 'E_3', 'FSR_1735', 'HP_1_BH_229', 'IC_1257', 'IC_1276_Pal_7', 'IC_4499', 'Ko_1', 'Ko_2', 'Liller_1', 'Lynga_7_BH184', 'NGC_104_47Tuc', 'NGC_1261', 'NGC_1851', 'NGC_1904_M_79', 'NGC_2298', 'NGC_2419', 'NGC_2808', 'NGC_288', 'NGC_3201', 'NGC_362', 'NGC_4147', 'NGC_4372', 'NGC_4590_M_68', 'NGC_4833', 'NGC_5024_M_53', 'NGC_5053', 'NGC_5139_oCen', 'NGC_5272_M_3', 'NGC_5286', 'NGC_5466', 'NGC_5634', 'NGC_5694', 'NGC_5824', 'NGC_5897', 'NGC_5904_M_5', 'NGC_5927', 'NGC_5946', 'NGC_5986', 'NGC_6093_M_80', 'NGC_6101', 'NGC_6121_M_4', 'NGC_6139', 'NGC_6144', 'NGC_6171_M107', 'NGC_6205_M_13', 'NGC_6218_M_12', 'NGC_6229', 'NGC_6235', 'NGC_6254_M_10', 'NGC_6256', 'NGC_6266_M_62', 'NGC_6273_M_19', 'NGC_6284', 'NGC_6287', 'NGC_6293', 'NGC_6304', 'NGC_6316', 'NGC_6325', 'NGC_6333_M_9', 'NGC_6341_M_92', 'NGC_6342', 'NGC_6352', 'NGC_6355', 'NGC_6356', 'NGC_6362', 'NGC_6366', 'NGC_6380_Ton1', 'NGC_6388', 'NGC_6397', 'NGC_6401', 'NGC_6402_M_14', 'NGC_6426', 'NGC_6440', 'NGC_6441', 'NGC_6453', 'NGC_6496', 'NGC_6517', 'NGC_6522', 'NGC_6528', 'NGC_6535', 'NGC_6539', 'NGC_6540_Djorg', 'NGC_6541', 'NGC_6544', 'NGC_6553', 'NGC_6558', 'NGC_6569', 'NGC_6584', 'NGC_6624', 'NGC_6626_M_28', 'NGC_6637_M_69', 'NGC_6638', 'NGC_6642', 'NGC_6652', 'NGC_6656_M_22', 'NGC_6681_M_70', 'NGC_6712', 'NGC_6715_M_54', 'NGC_6717_Pal9', 'NGC_6723', 'NGC_6749', 'NGC_6752', 'NGC_6760', 'NGC_6779_M_56', 'NGC_6809_M_55', 'NGC_6838_M_71', 'NGC_6864_M_75', 'NGC_6934', 'NGC_6981_M_72', 'NGC_7006', 'NGC_7078_M_15', 'NGC_7089_M_2', 'NGC_7099_M_30', 'NGC_7492', 'Pal_1', 'Pal_10', 'Pal_11', 'Pal_12', 'Pal_13', 'Pal_14', 'Pal_15', 'Pal_2', 'Pal_3', 'Pal_4', 'Pal_5', 'Pal_6', 'Pal_8', 'Pyxis', 'Rup_106', 'Terzan_10', 'Terzan_12', 'Terzan_1_HP_2', 'Terzan_2_HP_3', 'Terzan_3', 'Terzan_4_HP_4', 'Terzan_5_11', 'Terzan_6_HP_5', 'Terzan_7', 'Terzan_8', 'Terzan_9', 'Ton2_Pismis26', 'UKS_1', 'Whiting_1')

colnames = c("Source ID",
             "Right Ascension (deg)",
             "Declination (deg)",
             "RA Proper Motion (mas/yr)",
             "Dec. Proper Motion (mas/yr)",
             "Right Ascension Deviation (deg)",
             "Declination Deviation (deg)",
             "Radius (mas)",
             "Relative RA Proper Motion (mas/yr)",
             "Relative Dec. Proper Motion (mas/yr)",
             "Radial Velocity (mas/yr)",
             "Tangential Velocity (mas/yr)",
             "Parallax (mas)",
             "Membership Probability",
             "Corr Coef between RA and Dec. Proper Motion Uncertainties",
             "RA Proper Motion Uncertainty (mas/yr)",
             "Dec. Proper Motion Uncertainty (mas/yr)",
             "Parallax Uncertainty (mas)",
             "G",
             "BP - RP")

# Summarising data
h_data = read.csv("../data/clusters-harris/clean/id_position_data.txt")

first = TRUE
for (fileName in fileNames) {
  fileName
  # Read data
  f_data <- read.csv(paste(filePath,paste(fileName,".txt",sep=""), sep=""),sep=',')
  vPhi = mean(f_data$vPhi)
  vR = mean(f_data$vR)
  colnames(f_data) = colnames
  
  # Distance from sun
  R_sun = signif(mean(h_data[h_data[,"Name"]==paste(fileName,".txt",sep=''),6]), digits=6)
  vPhi_on_vR = signif(vPhi/vR, digits=6)

  x_to_be_binned = f_data[, "Radius (mas)"]
  
  # Bin x values and calculate mean/se of data in each x bin
  f_data = f_data |>
    mutate(binned_data = cut(get("Radius (mas)"), breaks=50)) |>
    group_by(binned_data) |>
    summarise(y_data = mean(get("Tangential Velocity (mas/yr)")), se = sd(get("Tangential Velocity (mas/yr)"))/sqrt(n()))
  # Replace levels in binned data with numbers
  levels(f_data$binned_data) <- gsub("\\(.+,|]", "", levels(f_data$binned_data))
  # Make binned X values numeric
  f_data$binned_data = as.numeric(as.character(f_data$binned_data))
  
  tryCatch(
    expr = {
      # non-linear regression (nls) on data using eq 1 from https://arxiv.org/pdf/1305.6025.pdf
      variables = nls(y_data ~ I(E-(omega*binned_data)/(1+b*(binned_data^(2*cpow)))), data=f_data, start=list(E=0, omega=2, b=50, cpow=1))
      
      # Extract constants from NLS
      E = coef(variables)[1]
      omega = coef(variables)[2]
      b = coef(variables)[3]
      cpow = coef(variables)[4]
      
      
      # Add rows containing y values of fitted curve at each x value, and the ribbon y range
      f_data = f_data |>
        mutate(y_val = I(E-(omega*binned_data)/(1+b*(binned_data^(2*cpow))))) |>
        mutate(y_min = y_val - se, y_max = y_val + se)
      
      # Finding peak of data
      v_p = max(abs(f_data$y_val-E))
      v_p = as.numeric(f_data[abs(f_data$y_val-E) == v_p, "y_val"])
      error = as.numeric(f_data[f_data$y_val == v_p, "se"])
      
      if (abs(v_p) <= abs(error)) {
        stop("Not rotating")
      } else {
        is_rotating = 1
      }
    },
    error = function(e){
      is_rotating <<- 0
      print(paste(fileName, "is not rotating."))
      
    },
    finally = {
      if (first) {
        disp_table <- as.data.frame(matrix(c(paste(fileName, ".txt", sep=''), R_sun, vPhi_on_vR, is_rotating), byrow=TRUE, nrow=1))
        first = FALSE
      } else {
        disp_table[nrow(disp_table)+1,] <- c(paste(fileName, ".txt", sep=''), R_sun, vPhi_on_vR, is_rotating)
      }
      print(paste(fileName, "completed."))
      print("-----------------------------------------")
    }
  )
}
colnames(disp_table) = c("file_name", "r_sun", "vPhi/vR", "rotating")

summary_data = read.csv("../data/clean-clusters/GCs_Summary.txt", sep=',')


age_df = read.csv("../data/clean-clusters/age.txt", sep=',')

complete_data <- merge(x=summary_data, y=disp_table, by="file_name")

# For adding AGE data from https://arxiv.org/pdf/1308.2257.pdf
complete_data = read.csv("../data/clean-clusters/GCs_Summary_2.txt", sep=',')
complete_data <- merge(x=complete_data, y=age_df, by.x="file_name", by.y="ngc", all=TRUE)

harris_summary = read.csv("../data/clusters-harris/clean/merged_data.txt", sep=",")

complete_data <- merge(x=complete_data, y=harris_summary, by.x="file_name", by.y="Name", all=TRUE)

write.csv(complete_data, "../data/clean-clusters/GCs_All_Summary.txt", row.names=FALSE, quote=FALSE)

#These stars are possibly rotating
DT::datatable(complete_data[abs(as.numeric(complete_data$`vPhi/vR`)) >= 3 & as.numeric(complete_data$size) >= 1000,], rownames=FALSE)
