#' Tournament R6 Class
#' @importFrom magrittr "%>%"
#' @export
Tournament <- R6::R6Class("Tournament",
  public = list(
    teams = NULL,
    type = NULL,
    build_fun = NULL,
    schedule = NULL,
    next_game = NULL,
    initialize = function(teams = NA, type = NA) {
      self$teams <- teams
      self$type <- type
      self$build_fun <- eval(parse(text = type))
      self$schedule <- self$build_fun(teams)
      self$schedule$winner <- NA_character_
      self$next_game <- self$schedule$game[1]
      self$schedule
      #self$greet()
    },
    play = function(game, winner) {
      self$schedule$winner[self$schedule$game == game] <- winner
      invisible(self)
    },
    standings = function() {
      self$schedule %>%
        tidyr::gather(location, team, away, home) %>%
        dplyr::filter(!is.na(winner)) %>%
        dplyr::group_by(team) %>%
        dplyr::summarize(
          W = sum(team == winner),
          L = sum(team != winner),
          T = sum(winner == "tie"),
          GP = n(),
          P = (W * 3) + (T * 1)
          ) %>%
        dplyr::right_join(
          tibble::tibble(team = self$teams),
          by = "team"
          ) %>%
        tidyr::replace_na(
          list(W = 0, L = 0, T = 0, GP = 0, P = 0)
        ) %>%
        dplyr::arrange(desc(P))
    },
    get_teams = function(game) {
      paste(dplyr::filter(self$schedule, game == !!game)[c("home", "away")])
    },
    set_hair = function(val) {
      self$hair <- val
    },
    info = function() {
      cat(paste0(self$type, " tournament with ", length(self$teams), " teams.\n"))
    }
  )
)
