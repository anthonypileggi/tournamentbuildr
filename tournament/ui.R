shinyUI(fluidPage(

  shinytoastr::useToastr(),

  titlePanel("Tournament"),

  sidebarLayout(
    sidebarPanel(

      sliderInput("n",
        "Number of teams:",
        min = 2,
        max = 8,
        value = 4
        ),

      radioButtons("type",
        label = "Tournament Type:",
        choices = c("Bracket" = "bracket", "Round-Robin" = "round_robin", "Random-Robin" = "random_robin"),
        selected = "bracket"
      ),
      hr(),
      uiOutput("team_inputs"),
      hr(),
      uiOutput("info"),
      actionButton("start", "Let's start!")
    ),

    mainPanel(
      tabsetPanel(
        id = "results",
        type = "tabs",
        tabPanel("Schedule",
          value = "schedule",
          DT::dataTableOutput("schedule")
        ),
        tabPanel("Standings",
          value = "standings",
          DT::dataTableOutput("standings")
        ),
        tabPanel("Record Results",
          value = "record",
          fluidRow(
            column(width = 4, selectizeInput("game", "Game #:", choices = NULL, selected = NULL)),
            column(width = 4, selectizeInput("winner", "Winner:", choices = NULL, selected = NULL)),
            column(width = 4, actionButton("record", "Record"))
          )
        )
      )
    )
  )
))
