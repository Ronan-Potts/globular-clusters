# Colour magnitude diagram:


# Look at the link below for an understanding of the colour magnitude diagram.
# https://physics.weber.edu/palen/clearinghouse/labs/Clusterhr/color_mag.html

# Look at the link below to understand isochrones.
# http://voyages.sdss.org/expeditions/expedition-to-the-milky-way/star-clusters/isochrone-fitting

# Look at the link below to fit isochrones
# https://astronomy.stackexchange.com/questions/34526/how-to-evaluate-the-fit-of-an-isochrone-to-a-stellar-population





library(shiny)
library(tidyverse)
library(shinydashboard)

filePath <- "data/clean-clusters/catalogues/"
fileName <- "NGC_5139_oCen.txt"
f_data <- read.csv(paste(filePath,fileName, sep=""),sep=',')
fileNames = c('AM_1', 'AM_4', 'Arp_2', 'BH_176', 'BH_261_AL_3', 'Djorg_1', 'Djorg_2_ESO456-', 'Eridanus', 'ESO280-06', 'ESO452-11', 'E_3', 'FSR_1735', 'HP_1_BH_229', 'IC_1257', 'IC_1276_Pal_7', 'IC_4499', 'Ko_1', 'Ko_2', 'Liller_1', 'Lynga_7_BH184', 'NGC_104_47Tuc', 'NGC_1261', 'NGC_1851', 'NGC_1904_M_79', 'NGC_2298', 'NGC_2419', 'NGC_2808', 'NGC_288', 'NGC_3201', 'NGC_362', 'NGC_4147', 'NGC_4372', 'NGC_4590_M_68', 'NGC_4833', 'NGC_5024_M_53', 'NGC_5053', 'NGC_5139_oCen', 'NGC_5272_M_3', 'NGC_5286', 'NGC_5466', 'NGC_5634', 'NGC_5694', 'NGC_5824', 'NGC_5897', 'NGC_5904_M_5', 'NGC_5927', 'NGC_5946', 'NGC_5986', 'NGC_6093_M_80', 'NGC_6101', 'NGC_6121_M_4', 'NGC_6139', 'NGC_6144', 'NGC_6171_M107', 'NGC_6205_M_13', 'NGC_6218_M_12', 'NGC_6229', 'NGC_6235', 'NGC_6254_M_10', 'NGC_6256', 'NGC_6266_M_62', 'NGC_6273_M_19', 'NGC_6284', 'NGC_6287', 'NGC_6293', 'NGC_6304', 'NGC_6316', 'NGC_6325', 'NGC_6333_M_9', 'NGC_6341_M_92', 'NGC_6342', 'NGC_6352', 'NGC_6355', 'NGC_6356', 'NGC_6362', 'NGC_6366', 'NGC_6380_Ton1', 'NGC_6388', 'NGC_6397', 'NGC_6401', 'NGC_6402_M_14', 'NGC_6426', 'NGC_6440', 'NGC_6441', 'NGC_6453', 'NGC_6496', 'NGC_6517', 'NGC_6522', 'NGC_6528', 'NGC_6535', 'NGC_6539', 'NGC_6540_Djorg', 'NGC_6541', 'NGC_6544', 'NGC_6553', 'NGC_6558', 'NGC_6569', 'NGC_6584', 'NGC_6624', 'NGC_6626_M_28', 'NGC_6637_M_69', 'NGC_6638', 'NGC_6642', 'NGC_6652', 'NGC_6656_M_22', 'NGC_6681_M_70', 'NGC_6712', 'NGC_6715_M_54', 'NGC_6717_Pal9', 'NGC_6723', 'NGC_6749', 'NGC_6752', 'NGC_6760', 'NGC_6779_M_56', 'NGC_6809_M_55', 'NGC_6838_M_71', 'NGC_6864_M_75', 'NGC_6934', 'NGC_6981_M_72', 'NGC_7006', 'NGC_7078_M_15', 'NGC_7089_M_2', 'NGC_7099_M_30', 'NGC_7492', 'Pal_1', 'Pal_10', 'Pal_11', 'Pal_12', 'Pal_13', 'Pal_14', 'Pal_15', 'Pal_2', 'Pal_3', 'Pal_4', 'Pal_5', 'Pal_6', 'Pal_8', 'Pyxis', 'Rup_106', 'Terzan_10', 'Terzan_12', 'Terzan_1_HP_2', 'Terzan_2_HP_3', 'Terzan_3', 'Terzan_4_HP_4', 'Terzan_5_11', 'Terzan_6_HP_5', 'Terzan_7', 'Terzan_8', 'Terzan_9', 'Ton2_Pismis26', 'UKS_1', 'Whiting_1')

isoFitPath = 'data/clean-clusters/GCs_real_fitting_isochrones.txt'
isoPath = paste('data/isochrones/clean/', 'NGC_5139_oCen', '/', sep='')
fitting_isochrones_df = read.csv(isoFitPath, sep=',')
fitting_isochrones = fitting_isochrones_df$NGC_5139_oCen.txt

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
             "G (brightness)",
             "BP - RP (colour)")



colnames(f_data) = colnames

# Define UI for application that draws a histogram
ui <- dashboardPage(title="Globular Cluster Visualisations",
  
  # Application title
  dashboardHeader(title=textOutput("titleText"), titleWidth=400),
  
  dashboardSidebar(
    sidebarMenu(
      selectInput("fileName",
                  "Select a Globular Cluster:",
                  choices = fileNames,
                  selected="NGC_104_47Tuc"),
      menuItem(text="Home", icon=icon("house"), tabName="home"),
      menuItem(text="Globular Cluster", icon=icon("database"), tabName="globular-cluster"),
      menuItem(text="Visualisations", icon=icon("image"), tabName="visualisations",
        menuSubItem(text="2D Statistic Histogram", tabName="stat2Dhist"),
        menuSubItem(text="Scatter Plot", tabName="scatter-plot"),
        menuSubItem(text="Binned X Scatter Plot", tabName="binx-scatter-plot"),
        menuSubItem(text="Histogram", tabName="hist")
      )
    )),
  
  dashboardBody(
    tags$style(HTML(".box-header {
                                      color:#fff;
                                      border-style:solid;
                                      border-color:#3c8dbc;
                                      border-width:2px;
                                      background:#2b6179
                                      }"),
               HTML(".box {
                                      border-style:solid;
                                      border-color:#3c8dbc;
                                      border-width:2px;
                                      border-top-width:0px;
                                      }")
    ),
    tabItems(
      tabItem(tabName="home",
              fluidRow(box(width=12, title="Introduction to Data",
                  htmlOutput("intro_text"))),
              fluidRow(box(width=12, title="Packages & Versions",
                  htmlOutput("package_text"))),
              fluidRow(box(width=12, title="Author",
                  htmlOutput("author_text")))
      ),
      tabItem(tabName="globular-cluster",
             fluidRow(box(width=12, title="Summary",
                 DT::dataTableOutput("aggregateData", width="100%"))
             ),
             fluidRow(
               box(width=12, title="Data Table",
                   DT::dataTableOutput("dataTable", width="100%"))
             )
      ),
      tabItem(tabName="stat2Dhist",
            fluidRow(box(width=12, title="Controls",
              column(width=3,
               selectInput("x2dstat",
                           "Select X Variable",
                           choices = colnames(f_data),
                           selected="Declination Deviation (deg)")),
              column(width=3,
               selectInput("y2dstat",
                           "Select Y Variable",
                           choices = colnames(f_data),
                           selected="Right Ascension Deviation (deg)")),
              column(width=3,
               selectInput("stat2d",
                           "Select Statistic",
                           choices = colnames(f_data),
                           selected="Tangential Velocity (mas/yr)")),
              column(width=3,
               sliderInput("bin2dslider",
                           "Bin Width",
                           min=0.0001, max=0.1, value=0.025)),
              column(width=12,
                     sliderInput("statistic_min_max", label = h3("Statistic Range"), min = 0, 
                                 max = 1, value=c(0, 1)))
              )
            ),
            fluidRow(box(width=12,title="2D Histogram", align="center", plotOutput("stat2DHist", width="100%"), height="700px"))
    ),
    tabItem(tabName='scatter-plot',
          fluidRow(box(width=12, title="Controls",
            column(width=3,
             selectInput("xvar",
                         "Select X Variable:",
                         choices = colnames(f_data),
                         selected="BP - RP (colour)")),
             column(width=3,
             selectInput("yvar",
                         "Select Y Variable:",
                         choices = colnames(f_data),
                         selected="G (brightness)")),
            column(width=3,
             selectInput("colorvar",
                         "Select Colour Variable:",
                         choices = colnames(f_data),
                         selected="BP - RP (colour)")),
            column(width=3,
                   uiOutput("scatter_controls")),
            column(width=6,
             sliderInput("color_min_max", label = h3("Colorbar Range"), min = 0, 
                         max = 1, value = c(0.95, 1))),
            column(width=6,
                   sliderInput("alphavar", label = h3("Transparency"), min = 0, 
                               max = 1, value = 0.1))
            )),
          fluidRow(box(title="Fitting Isochrones", width=12,
                       uiOutput("scatter_isofit_1"),
                       DT::dataTableOutput("scatter_isofit_2"),
                       DT::dataTableOutput("scatter_isofit_4"),
                       DT::dataTableOutput("scatter_isofit_5"),
                       DT::dataTableOutput("scatter_isofit_6"),
                       uiOutput("scatter_isofit_3")
          )
          ),
          fluidRow(box(title="Scatter Plot", width=12, align="center", plotOutput("distPlot", width="100%"), height="720px"))
          
    ),
    tabItem(tabName='binx-scatter-plot',
            fluidRow(box(width=12, title="Rotating Stars",
                htmlOutput("rotating_stars_txt"),
                DT::dataTableOutput("rotating_stars", width="100%"))),
            fluidRow(box(width=12, title="Controls",
                column(width=3,
                       selectInput("binscat_xvar",
                                   "Select X Variable:",
                                   choices = colnames(f_data),
                                   selected="Radius (mas)")),
                column(width=3,
                       selectInput("binscat_yvar",
                                   "Select Y Variable:",
                                   choices = colnames(f_data),
                                   selected="Tangential Velocity (mas/yr)")),
                column(width=3,
                       sliderInput("binscat_bins",
                                   "Bins",
                                   min=1, max=500, value=50, step=1)),
                column(width=3,
                       checkboxInput("binscat_fit", "Fit Curve", value=TRUE)))),
            fluidRow(box(title="Binned-X Scatter Plot", width=12, align="center", plotOutput("binnedScatter", width="100%"),height="700px"))
    ),
    tabItem(tabName="hist",
            fluidRow(box(width=12, title="Controls",
               selectInput("histX",
                           "Select Histogram Variable",
                           choices = colnames(f_data),
                           selected="Declination (deg)"),
               shiny::checkboxInput("norm",
                                    "Normalise Distribution",
                                    value = TRUE))),
            fluidRow(box(title="Histogram", width=12, align="center", plotOutput("histPlot", width="100%"),height="700px"))
    ))
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  
  # Home Page ________________________________________________________________________________________________________________________________________________________________________________________________________________________________
  
  output$intro_text <- renderUI({
    HTML(paste("Welcome to my <b>PHYS2923 globular clusters shiny application</b>! Here,
               you will be able to quickly and easily analyse data from a multitude of files, including the most recent <a href='https://zenodo.org/record/4891252#.YvCGAHZBwuU'>Catalogue of stars in Milky Way globular clusters from Gaia EDR3</a>
               and an older <a href='https://physics.mcmaster.ca/~harris/mwgc.dat'>catalog of parameters for milky way globular clusters</a>.",
               "Here, you have access to many <b>visualisations</b> to explore properties of the data There is also a <b>data table</b> if you wish to
               explore a specific entry in the data.", sep="<br><br>"))
  })
  output$package_text <- renderUI({
    HTML(paste("<b>R:</b> <a href='https://www.r-project.org/'>version 2.4.1</a> (Funny-Looking Kid), released on 2022-06-23.",
               "<b>RStudio:</b> <a href='https://www.rstudio.com/products/rstudio/download/#download'>version 2022.07.1+554</a>, an IDE used to write this shinyapp.",
               "<b>Tidyverse:</b> heavily used to create graphs using <b>ggplot2</b>, clean data with <b>dplyr</b> and <b>tidyr</b> and more.",
               "<b>Shiny:</b> used as the scaffolds for this web application.",
               "<b>Shinydashboard:</b> used to beautify the web application by adding a menu on the left side of the page, and a header on the top side of the page.",
               "<b>DT:</b> used to create the interactive data tables. Find more information <a href='https://rstudio.github.io/DT/'>here</a>.",
               sep="<br><br>"))
  })
  output$author_text <- renderUI({
    HTML(paste("Made by <b>Ronan Potts</b> at the University of Sydney for
               PHYS2923 in Semester 2, 2022.", sep="<br><br>"))
  })
  
  output$rotating_stars_txt <- renderUI({
    HTML(paste("To visualise some more interesting <b>stars which may be rotating</b>, use any of the globular clusters defined below. In particular, consider NGC_6266_M62, NGC_6139, NGC_7078_M_15, NGC_7089_M_2, and any stars with rotating = 1.", sep="<br><br>"))
  })
  output$rotating_stars <- DT::renderDataTable({
    gc_summary = read.csv("data/clean-clusters/GCs_Summary_2.txt", sep=",")
    DT::datatable(gc_summary[abs(as.numeric(gc_summary$`vPhi.vR`)) >= 3 & as.numeric(gc_summary$size) >= 1000,], rownames=FALSE, options = list(scrollX=TRUE))
  })
  
  
  # Other
  
  f_data <- reactive({
    f_data <- read.csv(paste(filePath,paste(input$fileName,".txt",sep=""), sep=""),sep=',')
    colnames(f_data) = colnames
    f_data
  })
  
  
  h_data <- reactive({
    h_data <- read.csv("data/clusters-harris/clean/merged_data.txt")
    h_data
  })
  
  output$titleText <- renderText({
    paste("Visualisation of Data in",input$fileName)
  })
  
  output$aggregateData <- DT::renderDataTable({
    f_data = f_data()
    h_data = h_data()
    mean_RA = signif(mean(f_data[,2]), digits=6)
    mean_Dec = signif(mean(f_data[,3]), digits=6)
    mean_PMRA = signif(mean(f_data[,4]), digits=6)
    mean_PMDEC = signif(mean(f_data[,5]), digits=6)
    num_stars = length(f_data[,1])
    R_sun = signif(mean(h_data[h_data[,"Name"]==paste(input$fileName,".txt",sep=''),6]), digits=6)
    disp_table <- as.data.frame(matrix(c(mean_RA, mean_Dec, mean_PMRA, mean_PMDEC, R_sun, num_stars), byrow=TRUE, nrow=1))
    colnames(disp_table) = c("Right Ascension (deg)", "Declination (deg)", "RA Proper Motion (mas/yr)", "Dec. Proper Motion (mas/yr)", "Distance from Sun (kPc)", "Number of Stars")
    DT::datatable(disp_table, options=list(dom='t'), rownames=FALSE)
  })
  
  output$distPlot <- renderPlot({
    f_data = f_data()
    
    if (input$yvar == "G (brightness)") {
      h_data = h_data()
      r_pc = 1000*(h_data[h_data$Name == paste(input$fileName, ".txt", sep=""), "R_sun"])
      dist_mod = 5*log10(r_pc/10)
      p = f_data |>
        ggplot() +
        geom_point(alpha=input$alphavar, aes(x=.data[[input$xvar]], y=.data[[input$yvar]]-dist_mod, color=.data[[input$colorvar]])) +
        scale_y_reverse() + labs(y="G (intensity - absolute)")
    } else {
      p = f_data |>
        ggplot() +
        geom_point(alpha=input$alphavar, aes(x=.data[[input$xvar]], y=.data[[input$yvar]], color=.data[[input$colorvar]]))
    }
    
    if (input$colorvar == "BP - RP (colour)") {
      p = p + scale_color_gradientn(colours = c("red4", "red","lightblue","darkblue"),
                                    values = c(1.0,0.6,0.4,0), na.value = "transparent")
    } else {
      p = p + scale_color_continuous(limits=input$color_min_max, na.value = "transparent")
    }
    
    if (input$scatter_isochrone_fit) {
      h_data = h_data()
      r_pc = 1000*(h_data[h_data$Name == paste(input$fileName, ".txt", sep=""), "R_sun"])
      dist_mod = 5*log10(r_pc/10)
      max_min = f_data |>
        mutate(gmag_abs = `G (brightness)` - dist_mod) |>
        summarise(min = min(gmag_abs), max=max(gmag_abs))
      max_gmag = max_min$max
      min_gmag = max_min$min
      isochrone_df = isochrone_df() |>
        mutate(bp_rp = G_BPmag - G_RPmag) |>
        filter(Gmag <= max_gmag & Gmag >= min_gmag)
      
      p = p + geom_point(data=isochrone_df, mapping = aes(x=bp_rp, y=Gmag), color='black') + scale_y_reverse()
    }
    p + theme_bw(base_size = 30)
  }, height = function() {
    0.5*session$clientData$output_distPlot_width
  })
  
  isochrone_df <- reactive({
    isoPath = paste('data/isochrones/clean/', input$fileName, '/', sep='')
    read.csv(paste(isoPath,input$isochrone_fit, sep=""),sep=',')
  })
  
  output$histPlot <- renderPlot({
    # Calculate number of bins with Freedman-Diaconis rule
    x <- f_data()[[input$histX]]
    bw <- 2 * IQR(x) / length(x)^(1/3)
    hist_plot <- f_data() |>
      ggplot(aes(x=.data[[input$histX]], fill=.data[[input$colorvar]])) +
      geom_histogram(binwidth=bw)
    
    if(input$norm==TRUE){
      hist_plot = hist_plot + aes(y=..count../sum(..count..)) + labs(y="Proportion")
      hist_plot
    } else {
      hist_plot = hist_plot + labs(y="Count")
      hist_plot
    }
  }, height = function() {
    0.5*session$clientData$output_distPlot_width
  })
  
  output$dataTable <- DT::renderDataTable({
    f_data <- f_data() |>
      DT::datatable(options = list(scrollX=TRUE))
  })
  
  output$stat2DHist <- renderPlot({
    f_data() |>
      ggplot(aes(x=.data[[input$x2dstat]], y=.data[[input$y2dstat]], z=.data[[input$stat2d]])) +
      stat_summary_2d(binwidth=input$bin2dslider, fun=mean, na.rm=TRUE) + 
      guides(fill = guide_legend(title = input$stat2d, reverse=TRUE, title.position="right")) + 
      theme(legend.key.height = unit(2.5, "cm"),legend.title = element_text(size=14,angle = 90),legend.title.align = 0.5) +
      scale_fill_gradientn(colors=c("blue", "cyan", "purple"), limits=input$statistic_min_max, na.value = "transparent", breaks=seq(input$statistic_min_max[1], input$statistic_min_max[2], (input$statistic_min_max[2]-input$statistic_min_max[1])/5))
  }, height = function() {
    0.5*session$clientData$output_stat2DHist_width
  })
  
  
  # Binned-X Scatter Plot
  output$binnedScatter <- renderPlot({
    R_sun = mean(h_data()[h_data()[,"Name"]==paste(input$fileName,".txt",sep=''),6])
    mas_to_rad = (2*pi)/(360*3600*1000)
    kPc_to_km = 3.086e+16
    yr_to_s = 60*60*24*365
    num_stars = length(f_data()[,1])
    # If you want to fit a curve:
    if (input$binscat_fit) {
      # Bin x values and calculate mean/se of data in each x bin
      f_data = f_data() |>
        mutate(binned_data = cut(get(input$binscat_xvar), breaks=input$binscat_bins)) |>
        group_by(binned_data) |>
        summarise(y_data = mean(get(input$binscat_yvar)), se = sd(get(input$binscat_yvar))/sqrt(n()))
      # Replace levels in binned data with numbers
      levels(f_data$binned_data) <- gsub("\\(.+,|]", "", levels(f_data$binned_data))
      # Make binned X values numeric
      f_data$binned_data = as.numeric(as.character(f_data$binned_data))
      
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
      
      # Plot curve
      p = f_data |>
        ggplot(aes(x=binned_data, y=y_data)) +
        geom_point(colour="#00c3ff") +  labs(x=input$binscat_xvar, y=input$binscat_yvar) +
        geom_function(fun = function(x) I(E-(omega*x)/(1+b*(x^(2*cpow))))) +
        geom_ribbon(aes(ymin=y_min, ymax=y_max), alpha=0.2)
      
      if (input$binscat_xvar == "Radius (mas)") {
        # Add second x axis on top
        p = p + scale_x_continuous(sec.axis = sec_axis(trans = ~ . * R_sun * kPc_to_km * mas_to_rad, name = "Radius (km)"))}
      if (input$binscat_yvar == "Tangential Velocity (mas/yr)"){
        # Add second y axis on right
        p = p + scale_y_continuous(sec.axis = sec_axis(trans = ~ . * R_sun * kPc_to_km * mas_to_rad / yr_to_s, name = "Tangential Velocity (km/s)"))
      } else if (input$binscat_yvar == "Radial Velocity (mas/yr)"){
        p = p + scale_y_continuous(sec.axis = sec_axis(trans = ~ . * R_sun * kPc_to_km * mas_to_rad / yr_to_s, name = "Radial Velocity (km/s)"))
      }
      
      if (input$binscat_fit == TRUE){
        v_p = max(abs(f_data$y_val-E))
        v_p = as.numeric(f_data[abs(f_data$y_val-E) == v_p, "y_val"])
        error = as.numeric(f_data[f_data$y_val == v_p, "se"])
        x_p = as.numeric(f_data[f_data$y_val == v_p, "binned_data"])
        if (v_p > 0) {
          p = p + annotate("text", label=paste0("v_p = ", signif(v_p,2), " +- ", signif(error,1)), x=x_p, y = v_p + 1.5*error)
        } else {
        p = p + annotate("text", label=paste0("v_p = ", signif(v_p,2), " +- ", signif(error,1)), x=x_p, y = v_p - 1.5*error)
        }
      }
      p
    } else {
    # Bin x values and calculate mean/se of data in each x bin
    f_data = f_data() |>
      mutate(binned_data = cut(get(input$binscat_xvar), breaks=input$binscat_bins)) |>
      group_by(binned_data) |>
      summarise(y_data = mean(get(input$binscat_yvar)), se = sd(get(input$binscat_yvar))/sqrt(n()))
    # Replace levels in binned data with numbers
    levels(f_data$binned_data) <- gsub("\\(.+,|]", "", levels(f_data$binned_data))
    # Make binned X values numeric
    f_data$binned_data = as.numeric(as.character(f_data$binned_data))
    
    
    # Add rows containing the ribbon y range
    f_data = f_data |>
      mutate(y_min = y_data - se, y_max = y_data + se)
    
    # Plot curve
    p = f_data |>
      ggplot(aes(x=binned_data, y=y_data)) +
      geom_point(colour="#00c3ff") + 
      labs(x=input$binscat_xvar, y=input$binscat_yvar) +
      geom_ribbon(aes(ymin=y_min, ymax=y_max), alpha=0.2)
    
    if (input$binscat_xvar == "Radius (mas)") {
        # Add second x axis on top
        p = p + scale_x_continuous(sec.axis = sec_axis(trans = ~ . * R_sun * kPc_to_km * mas_to_rad, name = "Radius (km)"))}
    if (input$binscat_yvar == "Tangential Velocity (mas/yr)"){
        # Add second y axis on right
        p = p + scale_y_continuous(sec.axis = sec_axis(trans = ~ . * R_sun * kPc_to_km * mas_to_rad / yr_to_s, name = "Tangential Velocity (km/s)"))
    } else if (input$binscat_yvar == "Radial Velocity (mas/yr)"){
      p = p + scale_y_continuous(sec.axis = sec_axis(trans = ~ . * R_sun * kPc_to_km * mas_to_rad / yr_to_s, name = "Radial Velocity (km/s)"))
    }
    p
    }
  }, height = function() {
    0.5*session$clientData$output_binnedScatter_width
  })
  
  
  # Updates application with change in data.
  observe({
    data = f_data()
    min_scatter = min(data[, input$colorvar])
    max_scatter = max(data[, input$colorvar])
    min_stat2d = min(data[, input$stat2d])
    max_stat2d = max(data[, input$stat2d])
    updateSliderInput(session,
                      "color_min_max",
                      min = signif(min_scatter, 2),
                      max = signif(max_scatter, 2),
                      step=signif((max_scatter-min_scatter)/500, 2))
    updateSliderInput(session,
                      "statistic_min_max",
                      min = signif(min_stat2d, 2),
                      max = signif(max_stat2d, 2),
                      step=signif((max_stat2d-min_stat2d)/500,2),
                      value = c(min_stat2d, max_stat2d))
  })
  
  
  
  # Isochrone fitting
  
  output$scatter_controls <- renderUI({
    if (input$xvar == "BP - RP (colour)" & input$yvar == "G (brightness)"){
      checkboxInput("scatter_isochrone_fit", "Fit Isochrone(s) to Data?", value=TRUE)
    } else {
      
    }
  })
  
  output$scatter_isofit_1 <- renderUI({
    if (input$scatter_isochrone_fit & input$xvar == "BP - RP (colour)" & input$yvar == "G (brightness)") {
        HTML(paste("Isochrones are used here to segment globular clusters into groups
                   based on age. Isochrones depict regions which encompass stars with
                   similar ages.",
                   "Isochrones were fit using advice from 
                   <a href='https://astronomy.stackexchange.com/questions/34526/how-to-evaluate-the-fit-of-an-isochrone-to-a-stellar-population'>this stackexchange.com page</a>
                   by generating a range of isochrones from
                   <a href='http://stev.oapd.inaf.it/cgi-bin/cmd'>the CMD 3.6 input form</a>.",
                   '',
                   sep="<br><br>"))
    } else {
      HTML(paste("Isochrones are used here to segment globular clusters into groups
                 based on age. Isochrones depict regions which encompass stars with
                 similar ages. To see more, set X Variable = 'BP - RP (colour)', Y Variable =
                 'G (brightness)', and check the 'Fit Isochrone(s) to Data?' box",
                 sep="<br><br>"))
    }
  })
  
  output$scatter_isofit_2 <- DT::renderDataTable({
    gc_summary = read.csv("data/clean-clusters/GCs_All_Summary.txt", sep=",")
    rotating_gcs = gc_summary[abs(as.numeric(gc_summary$`vPhi.vR`)) >= 3 & as.numeric(gc_summary$size) >= 1000,"file_name"]
    gc_summary = gc_summary |>
      filter(abs(as.numeric(`vPhi.vR`)) >= 3 & as.numeric(size) >= 1000) |>
      mutate(A_v = 3.1*`E.B.V.`) |>
      subset(select=c("file_name", "E.B.V.", "A_v", "X.Fe.H.", "age"))
    colnames(gc_summary) = c("Globular Cluster", "E(B-V)", "A_v", "[Fe/H]", "Age (Gyr)")
    DT::datatable(gc_summary, rownames=FALSE)
  })
  
  output$scatter_isofit_3 <- renderUI({
    fitting_isochrones = list.files(paste('data/isochrones/clean/', input$fileName, '/', sep=''))
    selectInput("isochrone_fit",
                "What Isochrone do you want to fit?",
                choices = fitting_isochrones,
                selected = fitting_isochrones[1])
  })
  
  
  output$scatter_isofit_4 <- DT::renderDataTable({
    gc_iso_fit = read.csv("data/clean-clusters/GCs_real_fitting_isochrones.txt", sep=",")
    DT::datatable(gc_iso_fit, rownames=FALSE, options = list(scrollX=TRUE))
  })
  
  
  output$scatter_isofit_5 <- DT::renderDataTable({
    gc_iso_fit = read.csv("data/clean-clusters/fitting_isochrones/GCs_real_fitting_isochrones.txt", sep=",")
    DT::datatable(gc_iso_fit, rownames=FALSE, options = list(scrollX=TRUE))
  })
  
  
  output$scatter_isofit_6 <- DT::renderDataTable({
    gc_iso_fit = read.csv("data/clean-clusters/GCs_real_fitting_isochrones_2.txt", sep=",")
    DT::datatable(gc_iso_fit, rownames=FALSE, options = list(scrollX=TRUE))
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
