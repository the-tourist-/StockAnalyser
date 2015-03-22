library(shiny)

shinyUI(
  pageWithSidebar(
    headerPanel("Portfolio Analyser"),
    sidebarPanel(
      h3("Enter Stock Symbol")
    ),
    mainPanel(
      h3("Main Panel")
    )
  )
)