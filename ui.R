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
    tags$link(rel="stylesheet", href="https://fonts.googleapis.com/css?family=Rajdhani"),
    tags$link(rel="stylesheet", href="style.css"),
    tabItems(
      tabItem(
        tabName = "overview",
        uiOutput("infoBoxes"),
        fluidRow(
          box(
            title = "Top 10 Games of All Time", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            plotlyOutput("topGamesAllTime")
          ),
          box(
            title = "Top 10 Games of 2016", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            plotlyOutput("topGames2016")
          )
        ),
        
        fluidRow(
          box(
            title = "Number of Games Released Per Year", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            plotlyOutput("numberOfGamesPerYear")
          ),
          box(
            title = "Top 10 Genres of All Time", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            plotlyOutput("topGenresAllTime")
          )
        ),
        
        fluidRow(
          box(
            title = "Top 10 Publishers of All Time", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            plotlyOutput("topPublishersAllTime")
          ),
          box(
            title = "Top 10 Platforms of All Time", solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6,
            plotlyOutput("topPlatformsAllTime")
          )
        )
      ),
      
      tabItem(
        tabName = "games",
        fluidRow(
          box(
            title = 'Top 10 games by Year, Platform, Region and Genre', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 8, height = 500,
            plotlyOutput("top10GamesFiltered")
          ),
          box(
            title = 'Graph Filters', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 4, height = 500,
            uiOutput("topGameFilters")
          )
        ),
        fluidRow(
          box(
            title = 'Top game per year', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 8,
            DTOutput("topGamesPerYear")
          ),
          box(
            title = 'Table Filters', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 4, height = 500,
            uiOutput("topGameYearlyFilters")
          )
        )
      ),
      
      tabItem(
        tabName = "genres",
        fluidRow(
          box(
            title = 'Top 10 Genre by Year, Platform and Region', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 8, height = 500,
            plotlyOutput("top10GenreFiltered")
          ),
          box(
            title = 'Graph Filters', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 4, height = 500,
            uiOutput("topGenreFilters")
          )
        ),
        
        fluidRow(
          box(
            title = 'Genre wise games proportion', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6, height = 650,
            echarts4rOutput("genreGameCount", height = '600px')
          ),
          box(
            title = 'Genre wise sales proportion', solidHeader = TRUE, collapsible = FALSE, status = "primary", width = 6, height = 650,
            echarts4rOutput("genreGameSales", height = '600px')
          )
        )
      )
    )
  )
)