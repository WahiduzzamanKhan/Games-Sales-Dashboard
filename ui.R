ui <- dashboardPage(
  dashboardHeader(
    title = "Video Games Dahsboard",
    titleWidth = "300px"
  ),

  dashboardSidebar(
    width = "300px",
    sidebarMenu(
      menuItem(text = "Overview", tabName = "overview"),
      menuItem(text = "Top Games", tabName = "games"),
      menuItem(text = "Top Genres", tabName = "genres")
    )
  ),

  dashboardBody(
    tags$head(includeHTML("google-analytics.html")),
    tags$link(rel="stylesheet", href="https://fonts.googleapis.com/css?family=Rajdhani"),
    tags$link(rel="stylesheet", href="style.css"),
    add_busy_bar(color = "#11174B"),
    tabItems(
      tabItem(
        tabName = "overview",
        uiOutput("infoBoxes"),
        fluidRow(
          box(
            title = "Top 10 Games of All Time", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            withSpinner(plotlyOutput("topGamesAllTime"), type = 8)
          ),
          box(
            title = "Top 10 Games of 2016", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            withSpinner(plotlyOutput("topGames2016"), type = 8)
          )
        ),

        fluidRow(
          box(
            title = "Number of Games Released Per Year", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            withSpinner(plotlyOutput("numberOfGamesPerYear"), type = 8)
          ),
          box(
            title = "Top 10 Genres of All Time", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            withSpinner(plotlyOutput("topGenresAllTime"), type = 8)
          )
        ),

        fluidRow(
          box(
            title = "Top 10 Publishers of All Time", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            withSpinner(plotlyOutput("topPublishersAllTime"), type = 8)
          ),
          box(
            title = "Top 10 Platforms of All Time", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            withSpinner(plotlyOutput("topPlatformsAllTime"), type = 8)
          )
        )
      ),

      tabItem(
        tabName = "games",
        fluidRow(
          box(
            title = 'Top 10 games by Year, Platform, Region and Genre', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 8, height = 500,
            withSpinner(plotlyOutput("top10GamesFiltered"), type = 8)
          ),
          box(
            title = 'Graph Filters', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 4, height = 500,
            withSpinner(uiOutput("topGameFilters"), type = 8)
          )
        ),
        fluidRow(
          box(
            title = 'Top game per year', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 8,
            withSpinner(DTOutput("topGamesPerYear"), type = 8)
          ),
          box(
            title = 'Table Filters', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 4, height = 500,
            withSpinner(uiOutput("topGameYearlyFilters"), type = 8)
          )
        )
      ),

      tabItem(
        tabName = "genres",
        fluidRow(
          box(
            title = 'Top 10 Genre by Year, Platform and Region', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 8, height = 500,
            withSpinner(plotlyOutput("top10GenreFiltered"), type = 8)
          ),
          box(
            title = 'Graph Filters', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 4, height = 500,
            withSpinner(uiOutput("topGenreFilters"), type = 8)
          )
        ),

        fluidRow(
          box(
            title = 'Genre wise games proportion', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6, height = 650,
            withSpinner(echarts4rOutput("genreGameCount", height = '600px'), type = 8)
          ),
          box(
            title = 'Genre wise sales proportion', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6, height = 650,
            withSpinner(echarts4rOutput("genreGameSales", height = '600px'), type = 8)
          )
        )
      )
    )
  )
)
