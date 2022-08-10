library(shiny)
library(tidyverse)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
filePath <- "../clusters/catalogues/"
fileName <- "Pal_5.txt"
f_data <- read.csv(paste(filePath,fileName, sep=""),sep='\t')

colnames(f_data) = c("Source ID",
                     "Right Ascension (deg)",
                     "Declination (deg)",
                     "Right Ascension Deviation (deg)",
                     "Declination Deviation (deg)",
                     "Parallax (mas)",
                     "RA Proper Motion (mas/yr)",
                     "Dec. Proper Motion (mas/year)",
                     "Parallax Uncertainty (mas)",
                     "RA Proper Motion Uncertainty (mas/yr)",
                     "Dec. Proper Motion Uncertainty (mas/year)",
                     "Corr Coef between RA and Dec. Proper Motion Uncertainties",
                     "G-band magnitude",
                     "BP-RP",
                     "Source Density [stars/arcmin^2]",
                     "Quality Flag",
                     "Membership Probability")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(paste("Visualisation of Data in",fileName)),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          tabsetPanel(
            tabPanel('Scatter Plot',
            selectInput("xvar",
                        "Select X Variable:",
                        choices = colnames(f_data),
                        selected="Declination (deg)"),
            selectInput("yvar",
                        "Select Y Variable:",
                        choices = colnames(f_data),
                        selected="Right Ascension (deg)"),
            selectInput("colorvar",
                        "Select Colour Variable:",
                        choices = colnames(f_data),
                        selected="Membership Probability")
            ),
            tabPanel("Histogram",
            selectInput("histX",
                        "Select Histogram Variable",
                        choices = colnames(f_data),
                        selected="Declination (deg)"),
            shiny::checkboxInput("norm",
                                 "Normalise Distribution",
                                 value = TRUE)
            )
          )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           tabsetPanel(
             tabPanel("Scatter Plot",
                      plotOutput("distPlot")),
             tabPanel("Histogram for X Variable",
                      plotOutput("histPlot"))
           )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$distPlot <- renderPlot({
        f_data |>
          ggplot(aes(x=.data[[input$xvar]], y=.data[[input$yvar]], color=.data[[input$colorvar]])) +
          geom_point()
      
    })
    output$histPlot <- renderPlot({
      hist_plot <- f_data |>
        ggplot(aes(x=.data[[input$histX]])) +
        geom_histogram()
      
      if(input$norm==TRUE){
        hist_plot = hist_plot + aes(y=..count../sum(..count..)) + labs(y="Proportion")
        hist_plot
      } else {
        hist_plot = hist_plot + labs(y="Count")
        hist_plot
      }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
