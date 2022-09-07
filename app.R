library(shiny)
library(tidyverse)
library(shinydashboard)

filePath <- "data/clean-clusters/catalogues/"
fileName <- "NGC_4590_M_68.txt"
f_data <- read.csv(paste(filePath,fileName, sep=""),sep=',')
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
                     "Parallax Uncertainty (mas)")



colnames(f_data) = colnames

# Define UI for application that draws a histogram
ui <- dashboardPage(title="Globular Cluster Visualisations",
  
  # Application title
  dashboardHeader(title=textOutput("titleText"), titleWidth=400),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem(text="Globular Cluster", tabName="globular-cluster"),
      menuItem(text="2D Statistic Histogram", tabName="stat2Dhist"),
      menuItem(text="Scatter Plot", tabName="scatter-plot"),
      menuItem(text="Binned X Scatter Plot", tabName="binx-scatter-plot"),
      menuItem(text="Histogram", tabName="hist")
    )),
  
  dashboardBody(height="10px",
    tabItems(
      tabItem(tabName="globular-cluster",
             box(width=12,
               column(width=3,
                 selectInput("fileName",
                             "Select a Globular Cluster:",
                             choices = fileNames,
                             selected="NGC_5139_oCen")),
               column(width=9,
                 DT::dataTableOutput("aggregateData", width="100%"))),
             DT::dataTableOutput("dataTable", width="100%")
      ),
      tabItem(tabName="stat2Dhist",
            box(width=12,
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
            ),
            fluidRow(box(width=12,column(1),column(10, align="center", plotOutput("stat2DHist", width="100%")),column(1),height="530px"))
    ),
    tabItem(tabName='scatter-plot', align="center",
          box(width=12,
            column(width=4,
             selectInput("xvar",
                         "Select X Variable:",
                         choices = colnames(f_data),
                         selected="Declination (deg)")),
             column(width=4,
             selectInput("yvar",
                         "Select Y Variable:",
                         choices = colnames(f_data),
                         selected="Right Ascension (deg)")),
            column(width=4,
             selectInput("colorvar",
                         "Select Colour Variable:",
                         choices = colnames(f_data),
                         selected="Membership Probability")),
            column(width=12,
             sliderInput("color_min_max", label = h3("Colorbar Range"), min = 0, 
                         max = 1, value = c(0.95, 1)))),
          fluidRow(box(width=12,column(1),column(10, align="center", plotOutput("distPlot", width="100%")),column(1),height="530px"))
    ),
    tabItem(tabName='binx-scatter-plot', align="center",
            box(width=12,
                column(width=4,
                       selectInput("binscat_xvar",
                                   "Select X Variable:",
                                   choices = colnames(f_data),
                                   selected="Radius (mas)")),
                column(width=4,
                       selectInput("binscat_yvar",
                                   "Select Y Variable:",
                                   choices = colnames(f_data),
                                   selected="Tangential Velocity (mas/yr)")),
            column(width=4,
                   sliderInput("binscat_bins",
                               "Bins",
                               min=1, max=500, value=50, step=1))),
            fluidRow(box(width=12,column(1),column(10, align="center", plotOutput("binnedScatter", width="100%")),column(1),height="530px"))
    ),
    tabItem(tabName="hist",
            box(width=12,
             selectInput("histX",
                         "Select Histogram Variable",
                         choices = colnames(f_data),
                         selected="Declination (deg)"),
             shiny::checkboxInput("norm",
                                  "Normalise Distribution",
                                  value = TRUE)),
            fluidRow(box(width=12,column(1),column(10, align="center", plotOutput("histPlot", width="100%")),column(1),height="530px"))
    ))
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  f_data <- reactive({
    f_data <- read.csv(paste(filePath,paste(input$fileName,".txt",sep=""), sep=""),sep=',')
    colnames(f_data) = colnames
    f_data
  })
  
  output$titleText <- renderText({
    paste("Visualisation of Data in",input$fileName)
  })
  
  output$aggregateData <- DT::renderDataTable({
    mean_RA = signif(mean(f_data()[,2]), digits=6)
    mean_Dec = signif(mean(f_data()[,3]), digits=6)
    mean_PMRA = signif(mean(f_data()[,4]), digits=6)
    mean_PMDEC = signif(mean(f_data()[,5]), digits=6)
    disp_table <- as.data.frame(matrix(c(mean_RA, mean_Dec, mean_PMRA, mean_PMDEC), byrow=TRUE, nrow=1))
    colnames(disp_table) = c("Right Ascension (deg)", "Declination (deg)", "RA Proper Motion (mas/yr)", "Dec. Proper Motion (mas/yr)")
    DT::datatable(disp_table, options=list(dom='t'), rownames=FALSE)
    
  })
  
  output$distPlot <- renderPlot({
    f_data() |>
      ggplot(aes(x=.data[[input$xvar]], y=.data[[input$yvar]], color=.data[[input$colorvar]])) +
      geom_point() + 
      scale_color_continuous(limits=input$color_min_max, na.value = "transparent")
  }, height = function() {
    0.5*session$clientData$output_distPlot_width
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
  
  output$binnedScatter <- renderPlot({
    f_data = f_data()
    f_data = f_data |>
      mutate(binned_data = cut(get(input$binscat_xvar), breaks=input$binscat_bins)) |>
      group_by(binned_data) |>
      summarise(y_data = mean(get(input$binscat_yvar)))
    levels(f_data$binned_data) <- gsub("\\(.+,|]", "", levels(f_data$binned_data))
    f_data |>
      ggplot(aes(x=binned_data, y=y_data)) +
      geom_point(colour="#00c3ff") + 
      labs(x=input$binscat_xvar, y=input$binscat_yvar) + 
      scale_x_discrete(breaks = levels(f_data$binned_data)[floor(seq(1, 
                                                         nlevels(f_data$binned_data), 
                                                         length.out = 10))])
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
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
