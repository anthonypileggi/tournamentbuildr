#' Build a round-robin tournament
#' @param teams a list of teams, from best to worst (character/vector)
#' @param n number of teams (numeric/scalar)
#' @param home_away should each team play twice? (1 home, 1 away) (logical/scalar)
#' @return a tibble with tournament schedule: {game, away, home}
#' @export
round_robin <- function(teams = NULL,
                        n = length(teams),
                        home_away = FALSE) {

  # create all possible pairs
  games <- switch(is.null(teams) + 1, combn(teams, 2), combn(n, 2))
  tourney <- tibble::tibble(
    game = 1:ncol(games),
    home = games[1,],
    away = games[2,]
  )

  # optional: each team is plays both home and away
  if (home_away)
    tourney <- rbind(tourney, setNames(tourney, c("away", "home")))

  tourney
}