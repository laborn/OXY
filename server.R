library(shiny)
oxy <- read.csv("oxy.csv")
oxy <- as.data.frame(oxy[c(1, 5)])
oxy$Date <- as.Date(oxy$Date)
oxy$Day <- as.factor(weekdays(oxy$Date))
oxy$Month <- as.factor(months(oxy$Date))
i <- 1
while ( i < nrow(oxy) ){
        if ( oxy$Close[i] < oxy$Close[i+1] )
                oxy$Change[i] <- "lower"
        else if ( oxy$Close[i] == oxy$Close[i+1] )
                oxy$Change[i] <- "same"
        else
                oxy$Change[i] <- "higher"
        oxy$Percent[i] <- ((oxy$Close[i]-oxy$Close[i+1])/oxy$Close[i+1])*100
        i <- i + 1
}
oxy$Change <- as.factor(oxy$Change)
dayMeans <- aggregate(Percent ~ Day, oxy, mean)
dayMax <- aggregate(Percent ~ Day, oxy, max)
dayMin <- aggregate(Percent ~ Day, oxy, min)
monthDayPercent <- aggregate(Percent ~ Day + Month, oxy, mean)
monthDayPercent$Percent <- round(monthDayPercent$Percent, digits=2)

shinyServer(
        function(input, output) {
                output$text1 <- renderUI({
                        str1 <- paste("In the month of ", input$Month)
                        HTML(paste(str1, sep = '<br/>'))
                })
                sell <- reactive ({
                        query <- subset(monthDayPercent, Month == input$Month)
                        sub <- subset(query, Percent == max(query$Percent))
                        return(sub$Day)
                })
                buy <- reactive ({
                        query <- subset(monthDayPercent, Month == input$Month)
                        sub <- subset(query, Percent == min(query$Percent))
                        return(sub$Day)
                })
                output$text2 <- renderUI({
                        input$submitButton
                        str2 <- paste("Best day to SELL is on a -----> ", as.character(sell()))
                        HTML(paste(str2, sep = '<br/>'))
                })
                output$text3 <- renderUI({
                        str3 <- paste("Best day to BUY is on a -----> ", as.character(buy()))
                        HTML(paste(str3, sep = '<br/>'))
                })
        }
)
