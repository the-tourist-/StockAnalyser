library(shiny)
library(lubridate)

shinyUI(
  fluidPage(title="Analyse Stock", theme = "cerulean.css",
    titlePanel("Analyse Stock", "Analyse Stock"),
    fixedPanel(width=1080, left=20, right=20, p("This App uses the quantmod and PortfolioAnalytics packages to do analysis of a stock's price history.  Enter a stock symbol (such as YHOO, AAPL or MSFT) and press the Lookup button (twice initially due to an issue with shinyapps.io). This will download the stocks history and produce the analysis.  Once the symbol has been enter the start date can be modified and the analysis will be updated reactively.")),
    sidebarLayout(
      fixedPanel(width=260, left=20, top=220,
        fluidRow(
          column(tags$b("Symbol:"), width=4),
          column(textInput("Symbol", NULL), width=4),
          column(actionButton("LookupButton", "Lookup", class="btn btn-primary"), width=4)
        ),
        fluidRow(
          column(tags$b("Date:"), width=4),
          column(dateInput("FromDate", NULL, format = "dd-M-yyyy", value = Sys.Date()-365), width=8)
        ),
        tableOutput("MonthlyStats")
      ),
      fixedPanel(left=320, top=200,
        plotOutput("Chart", height=600, width=800),
        tableOutput("MonthlyReturns"),
        textOutput("Message")
      ),
      fluid = F
    )
  )
)