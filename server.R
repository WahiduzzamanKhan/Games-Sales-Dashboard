server <- function(input, output){
  ##### overview #####
  output$infoBoxes <- renderUI({
    games <- nrow(VGData)
    publishers <- length(unique(VGData$Publisher))
    platforms <- length(unique(VGData$Platform))
    genres <- length(unique(VGData$Genre))
    fluidRow(
      infoBox(
        title = "Games",
        value = games,
        icon = icon("gamepad"),
        fill = TRUE,
        width = 3
      ),
      infoBox(
        title = "Publishers",
        value = publishers,
        icon = icon("copyright"),
        fill = TRUE,
        width = 3
      ),
      infoBox(
        title = "Platforms",
        value = platforms,
        icon = icon("layer-group"),
        fill = TRUE,
        width = 3
      ),
      infoBox(
        title = "Genres",
        value = genres,
        icon = icon("th"),
        fill = TRUE,
        width = 3
      )
    )
  })

  output$topGamesAllTime <- renderPlotly({
    data <- head(VGData %>% arrange(desc(Global_Sales)), 10)
    data$Global_Sales <- data$Global_Sales*1000000
    plot_ly(
      data = data,
      x = ~reorder(Name, desc(Global_Sales)),
      y = ~Global_Sales,
      type = "bar",
      marker = list(color = c("#11174b", "#18216b", "#203686", "#2a5599", "#3474ac", "#3e94c0", "#48b3d3", "#78c6d0", "#aadacc", "#dcecc9"))
    ) %>%
      layout(
        yaxis = list(title = "Global Salse"),
        xaxis = list(title = "Game")
      )
  })

  output$topGames2016 <- renderPlotly({
    data <- head(VGData %>% arrange(desc(Global_Sales)) %>% filter(Year==2016), 10)
    data$Global_Sales <- data$Global_Sales*1000000
    plot_ly(
      data = data,
      x = ~reorder(Name, desc(Global_Sales)),
      y = ~Global_Sales,
      type = "bar",
      marker = list(color = c("#11174b", "#18216b", "#203686", "#2a5599", "#3474ac", "#3e94c0", "#48b3d3", "#78c6d0", "#aadacc", "#dcecc9"))
    ) %>%
      layout(
        yaxis = list(title = "Global Salse"),
        xaxis = list(title = "Game")
      )
  })

  output$topGenresAllTime <- renderPlotly({
    data <- head(
      VGData %>%
        group_by(Genre) %>%
        summarise(Global_Sales=sum(Global_Sales, na.rm = TRUE)) %>%
        ungroup() %>%
        arrange(desc(Global_Sales)),
      10
    )
    data$Global_Sales <- data$Global_Sales*1000000
    plot_ly(
      data = data,
      x = ~reorder(Genre, desc(Global_Sales)),
      y = ~Global_Sales,
      type = "bar",
      marker = list(color = c("#11174b", "#18216b", "#203686", "#2a5599", "#3474ac", "#3e94c0", "#48b3d3", "#78c6d0", "#aadacc", "#dcecc9"))
    ) %>%
      layout(
        yaxis = list(title = "Global Salse"),
        xaxis = list(title = "Genre")
      )
  })

  output$topPlatformsAllTime <- renderPlotly({
    data <- head(
      VGData %>%
        group_by(Platform) %>%
        summarise(Global_Sales=sum(Global_Sales, na.rm = TRUE)) %>%
        ungroup() %>%
        arrange(desc(Global_Sales)),
      10
    )
    data$Global_Sales <- data$Global_Sales*1000000
    plot_ly(
      data = data,
      x = ~reorder(Platform, desc(Global_Sales)),
      y = ~Global_Sales,
      type = "bar",
      marker = list(color = c("#11174b", "#18216b", "#203686", "#2a5599", "#3474ac", "#3e94c0", "#48b3d3", "#78c6d0", "#aadacc", "#dcecc9"))
    ) %>%
      layout(
        yaxis = list(title = "Global Salse"),
        xaxis = list(title = "Platform")
      )
  })

  output$topPublishersAllTime <- renderPlotly({
    data <- head(
      VGData %>%
        group_by(Publisher) %>%
        summarise(Global_Sales=sum(Global_Sales, na.rm = TRUE)) %>%
        ungroup() %>%
        arrange(desc(Global_Sales)),
      10
    )
    data$Global_Sales <- data$Global_Sales*1000000
    plot_ly(
      data = data,
      x = ~reorder(Publisher, desc(Global_Sales)),
      y = ~Global_Sales,
      type = "bar",
      marker = list(color = c("#11174b", "#18216b", "#203686", "#2a5599", "#3474ac", "#3e94c0", "#48b3d3", "#78c6d0", "#aadacc", "#dcecc9"))
    ) %>%
      layout(
        yaxis = list(title = "Global Salse"),
        xaxis = list(title = "Publisher")
      )
  })

  output$numberOfGamesPerYear <- renderPlotly({
    plot_ly(
      data = VGData %>% group_by(Year) %>% count() %>% ungroup(),
      x = ~Year,
      y = ~n,
      type = 'scatter',
      mode = 'lines'
    ) %>%
      layout(
        yaxis = list(title = "# of Games"),
        xaxis = list(title = "Year")
      )
  })
  ##### end overview #####

  ##### Games #####
  output$topGameFilters <- renderUI(
    tagList(
      sliderInput(
        inputId = "topGameYears",
        label = "Select year range:",
        min = min(VGData$Year),
        max = max(VGData$Year),
        value = c(min(VGData$Year), max(VGData$Year))
      ),
      pickerInput(
        inputId = "topGamePlatforms",
        label = "Select platforms",
        choices = unique(VGData$Platform),
        selected = unique(VGData$Platform),
        options = list(
          `actions-box` = TRUE,
          `live-search` = TRUE,
          size = 6
        ),
        multiple = TRUE
      ),
      pickerInput(
        inputId = "topGameGenres",
        label = "Select genres",
        choices = unique(VGData$Genre),
        selected = unique(VGData$Genre),
        options = list(
          `actions-box` = TRUE,
          `live-search` = TRUE,
          size = 6
        ),
        multiple = TRUE
      ),
      selectInput(
        inputId = 'topGameRegion',
        label = 'Select Region',
        choices = c("Global", "North America", "Europe", "Japan", "Other"),
        selected = "Global",
        multiple = FALSE
      )
    )
  )

  output$top10GamesFiltered <- renderPlotly({
    req(input$topGameYears)
    req(input$topGamePlatforms)
    req(input$topGameGenres)
    req(input$topGameRegion)

    data <- VGData %>%
      filter(Year >= input$topGameYears[1] & Year <= input$topGameYears[2]) %>%
      filter(Platform %in% input$topGamePlatforms) %>%
      filter(Genre %in% input$topGameGenres)

    if(input$topGameRegion=="North America"){
      data <- data %>%
      mutate(Sales=NA_Sales*1000000) %>%
      arrange(desc(Sales))
    }
    else if(input$topGameRegion=="Europe"){
      data <- data %>%
        mutate(Sales=EU_Sales*1000000) %>%
        arrange(desc(Sales))
    }
    else if(input$topGameRegion=="Japan"){
      data <- data %>%
        mutate(Sales=JP_Sales*1000000) %>%
        arrange(desc(Sales))
    }
    else if(input$topGameRegion=="Other"){
      data <- data %>%
        mutate(Sales=Other_Sales) %>%
        arrange(desc(Sales))
    }
    else{
      data <- data %>%
        mutate(Sales=Global_Sales) %>%
        arrange(desc(Sales))
    }

    plot_ly(
      data = data[1:10,],
      x = ~reorder(Name, desc(Sales)),
      y = ~Sales,
      type = "bar",
      marker = list(color = c("#11174b", "#18216b", "#203686", "#2a5599", "#3474ac", "#3e94c0", "#48b3d3", "#78c6d0", "#aadacc", "#dcecc9"))
    ) %>%
      layout(
        yaxis = list(title = paste0(input$gameRegion, " Sales")),
        xaxis = list(title = "Game")
      )
  })

  output$topGameYearlyFilters <- renderUI(
    tagList(
      pickerInput(
        inputId = "topGameYearlyPlatforms",
        label = "Select platforms",
        choices = unique(VGData$Platform),
        selected = unique(VGData$Platform),
        options = list(
          `actions-box` = TRUE,
          `live-search` = TRUE,
          size = 6
        ),
        multiple = TRUE
      ),
      pickerInput(
        inputId = "topGameYearlyGenres",
        label = "Select genres",
        choices = unique(VGData$Genre),
        selected = unique(VGData$Genre),
        options = list(
          `actions-box` = TRUE,
          `live-search` = TRUE,
          size = 6
        ),
        multiple = TRUE
      ),
      selectInput(
        inputId = 'topGameYearlyRegion',
        label = 'Select Region',
        choices = c("Global", "North America", "Europe", "Japan", "Other"),
        selected = "Global",
        multiple = FALSE
      )
    )
  )

  output$topGamesPerYear <- renderDT({
    req(input$topGameYearlyGenres)
    req(input$topGameYearlyPlatforms)
    req(input$topGameYearlyRegion)

    Sys.sleep(5)

    data <- VGData %>%
      filter(Platform %in% input$topGameYearlyPlatforms) %>%
      filter(Genre %in% input$topGameYearlyGenres)

    if(input$topGameYearlyRegion=="North America"){
      data <- data %>%
        mutate(Sales=NA_Sales)
    }
    else if(input$topGameYearlyRegion=="Europe"){
      data <- data %>%
        mutate(Sales=EU_Sales)
    }
    else if(input$topGameYearlyRegion=="Japan"){
      data <- data %>%
        mutate(Sales=JP_Sales)
    }
    else if(input$topGameYearlyRegion=="Other"){
      data <- data %>%
        mutate(Sales=Other_Sales)
    }
    else{
      data <- data %>%
        mutate(Sales=Global_Sales)
    }

    data <- data %>%
      group_by(Year) %>%
      filter(Sales == max(Sales)) %>%
      ungroup() %>%
      arrange(desc(Year)) %>%
      select(Year, Name, everything(), -Rank, -Sales)

    datatable(
      data = data,
      style = 'bootstrap',
      class = 'compact stripe row-border hover',
      filter = 'none',
      selection = 'none',
      options = list(
        ordering = TRUE,
        info = TRUE,
        bLengthChange = FALSE,
        searching = FALSE,
        scrollY= 370,
        scroller = TRUE
      ),
      extensions = list('Responsive'=NULL, "Scroller"=NULL),
      width = '100%'
    )
  })
  ##### end Games #####

  ##### Genres #####
  output$topGenreFilters <- renderUI(
    tagList(
      sliderInput(
        inputId = "topGenreYears",
        label = "Select year range:",
        min = min(VGData$Year),
        max = max(VGData$Year),
        value = c(min(VGData$Year), max(VGData$Year))
      ),
      pickerInput(
        inputId = "topGenrePlatforms",
        label = "Select platforms",
        choices = unique(VGData$Platform),
        selected = unique(VGData$Platform),
        options = list(
          `actions-box` = TRUE,
          `live-search` = TRUE,
          size = 6
        ),
        multiple = TRUE
      ),
      selectInput(
        inputId = 'topGenreRegion',
        label = 'Select Region',
        choices = c("Global", "North America", "Europe", "Japan", "Other"),
        selected = "Global",
        multiple = FALSE
      )
    )
  )

  output$top10GenreFiltered <- renderPlotly({
    req(input$topGenreYears)
    req(input$topGenrePlatforms)
    req(input$topGenreRegion)

    data <- VGData %>%
      filter(Year >= input$topGenreYears[1] & Year <= input$topGenreYears[2]) %>%
      filter(Platform %in% input$topGenrePlatforms)

    if(input$topGenreRegion=="North America"){
      data <- data %>%
        mutate(Sales=NA_Sales*1000000)
    }
    else if(input$topGenreRegion=="Europe"){
      data <- data %>%
        mutate(Sales=EU_Sales*1000000)
    }
    else if(input$topGenreRegion=="Japan"){
      data <- data %>%
        mutate(Sales=JP_Sales*1000000) %>%
        arrange(desc(Sales))
    }
    else if(input$topGenreRegion=="Other"){
      data <- data %>%
        mutate(Sales=Other_Sales)
    }
    else{
      data <- data %>%
        mutate(Sales=Global_Sales)
    }

    data <- data %>%
      group_by(Genre) %>%
      summarise(Sales = sum(Sales, na.rm = T)) %>%
      ungroup() %>%
      arrange(desc(Sales))

    plot_ly(
      data = data[1:10,],
      x = ~reorder(Genre, desc(Sales)),
      y = ~Sales,
      type = "bar",
      marker = list(color = c("#11174b", "#18216b", "#203686", "#2a5599", "#3474ac", "#3e94c0", "#48b3d3", "#78c6d0", "#aadacc", "#dcecc9"))
    ) %>%
      layout(
        yaxis = list(title = paste0(input$gameRegion, " Sales")),
        xaxis = list(title = "Genre")
      )
  })

  output$genreGameCount <- renderEcharts4r({
    req(input$topGenreYears)
    req(input$topGenrePlatforms)
    req(input$topGenreRegion)

    VGData %>%
      filter(Year >= input$topGenreYears[1] & Year <= input$topGenreYears[2]) %>%
      filter(Platform %in% input$topGenrePlatforms) %>%
      group_by(Genre) %>%
      count() %>%
      ungroup() %>%
      e_charts(Genre) %>%
      e_pie(n, roseType = "radius")
  })

  output$genreGameSales <- renderEcharts4r({
    req(input$topGenreYears)
    req(input$topGenrePlatforms)
    req(input$topGenreRegion)

    VGData %>%
      filter(Year >= input$topGenreYears[1] & Year <= input$topGenreYears[2]) %>%
      filter(Platform %in% input$topGenrePlatforms) %>%
      group_by(Genre) %>%
      summarise(Sales=sum(Global_Sales, na.rm = TRUE)) %>%
      ungroup() %>%
      e_charts(Genre) %>%
      e_pie(Sales, roseType = "radius")
  })
  ##### End Genres #####
}
