shinyUI(pageWithSidebar(
        headerPanel(h4("When to Buy and Sell Occidental Petroleum Stock")),
        sidebarPanel(
                p('This is a simple application that uses a downloaded .csv Excel file
                        from the Yahoo web site for Occidental Petroleum. Historical
                        price data is loaded via the server.R file and daily percentage
                        increases/decreases are calculated for each day and added into
                        the main data frame. The user interface asks for a month and then
                        calculates the best day of the week to buy and/or sell the stock
                        based on the historical data aggregated by month and averaged
                        by the day of the week.'),
                textInput(inputId="Month", label="Enter a month:"),
                submitButton("Submit!")
        ),
        mainPanel(htmlOutput('text1'),
                p(''),
                htmlOutput('text2'),
                p(''),
                htmlOutput('text3')
                )
        )
)
