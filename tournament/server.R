
shinyServer(function(input, output, session) {

  output$team_inputs <- renderUI({
    div(
      purrr::map(
        1:input$n,
        ~textInput(paste0("team_", .x), label = paste("Team", .x), value = paste("Team", .x))
      )
    )
  })

  output$info <- renderUI({
    strong(
      paste(
        "Are you ready to start the",
        input$n,
        "team",
        input$type,
        "tournament?"
      )
    )
  })

  teams <- reactive({
    purrr::map_chr(paste0("team_", 1:input$n), ~input[[.x]])
  })

  tournament <- eventReactive(input$start, {
    Tournament$new(teams = teams(), type = input$type)
  })

  schedule <- eventReactive(list(input$start, input$record), {
    tournament()$schedule
  })

  standings <- eventReactive(list(input$start, input$record), {
    tournament()$standings()
  })

  # record game result
  observeEvent(input$record, ignoreNULL = FALSE, {
    tournament()$play(input$game, input$winner)
    shinytoastr::toastr_success(paste0("Updated Game #", input$game, ": ", input$winner, " wins!"))
    updateTabsetPanel(session, "results", selected = "schedule")
  })

  output$standings <- DT::renderDataTable({
    DT::datatable(standings(), rownames = FALSE)
  })

  output$schedule <- DT::renderDataTable({
    DT::datatable(schedule(), rownames = FALSE)
  })

  observe({
    updateSelectizeInput(
      session,
      "winner",
      choices = paste(tournament()$schedule[tournament()$schedule$game == input$game, c("home", "away")])
      )
  })

  observe({
    updateSelectizeInput(
      session,
      "game",
      choices = tournament()$schedule$game
    )
  })


})
