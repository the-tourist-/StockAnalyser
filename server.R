library(shiny)
library(lubridate)
library(PerformanceAnalytics)
library(quantmod)

getSymbols("^GSPC")

shinyServer(
  function(input, output) {
    #FromDate <- today()
    #year(FromDate) <- year(FromDate) - 1
    #output$Temp <- as.character(FromDate)

    Symbol <- reactive({
      input$LookupButton
      isolate(toupper(input$Symbol))
    })

    FullResults <- reactive({
      if (Symbol() != "") {
        getSymbols(Symbol())
        Intermediate <- get(Symbol())
        adjustOHLC(Intermediate, symbol.name=Symbol())
      }
    })

    Prices <- reactive({
      FullResults()[paste(input$FromDate, "/")]
    })

    GSPCPrices <- reactive({
      GSPC[paste(input$FromDate, "/")]
    })

    Returns <- reactive({
      dailyReturn(Prices())
    })

    GSPCReturns <- reactive({
      dailyReturn(GSPCPrices())
    })

    MonthlyReturns <- reactive({
      monthlyReturn(Prices())
    })

    MonthlyGSPCReturns <- reactive({
      monthlyReturn(GSPCPrices())
    })

    PairedReturns <- reactive({
      Intermediate <- cbind(Returns(), GSPCReturns())
      colnames(Intermediate) <- c(Symbol(), "S&P 500")
      Intermediate
    })

    PairedMonthlyReturns <- reactive({
      Intermediate <- cbind(MonthlyReturns(), MonthlyGSPCReturns())
      colnames(Intermediate) <- c(Symbol(), "S&P 500")
      Intermediate
    })

    output$Chart <- renderPlot({
      if (Symbol() == "")
        NULL
      else {
        #chartSeries(Prices(), log.scale = T, type="bars", name=Symbol(), minor.ticks = F)
        charts.PerformanceSummary(PairedReturns(), colorset=rich6equal[-1], lwd=2, ylog=TRUE)
      }
    },
    res=144)

    output$MonthlyReturns <- renderTable({
      if (Symbol() == "")
        NULL
      else
        table.CalendarReturns(PairedMonthlyReturns())
    })

    output$MonthlyStats <- renderTable({
      if (Symbol() == "")
        NULL
      else
        table.Stats(PairedMonthlyReturns())
    })
  }
)