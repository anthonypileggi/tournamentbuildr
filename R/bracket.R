#' Build a single-elimination tournament bracket for `n` ranked teams
#' @param teams a list of teams, from best to worst (character/vector)
#' @param n number of teams (numeric/scalar)
#' @return a tibble with tournament schedule: {game, round, away, home}
#' @export
bracket <- function(teams = NULL, n = length(teams)) {

  # Round 1
  # -- if there is an odd number of teams, add a 'Round 0' play-in game
  m <- n / 2
  if (m %% 2 != 0) {
    tourney <- tibble::tibble(game = 1, round = 0, away = as.character(n), home = n - 1)
    tourney_1 <- tibble::tibble(
      game = 2:(1 + n / 2),
      round = 1,
      away = c(paste0("winner #", n, " vs #", n - 1), (n - 2):(m + 1)),
      home = 1:m
    )
    tourney <- dplyr::bind_rows(tourney, tourney_1)
  } else {
    tourney <- tibble::tibble(
      game = 1:(n / 2),
      round = 1,
      away = as.character(n:(n / 2 + 1)),
      home = as.character(1:(n / 2))
    )
  }

  # Rounds 2+
  this_round <- 2
  ot <- dplyr::filter(tourney, round == this_round - 1)
  while (nrow(ot) > 1) {

    # add games for current round
    next_game <- (max(ot$game) + 1)
    new_tourney <- tibble::tibble(
      game = next_game:(next_game - 1 + nrow(ot) / 2),
      round = this_round,
      away = paste("game", ot$game[1:(nrow(ot) / 2)], "winner"),
      home = paste("game", ot$game[nrow(ot):(nrow(ot) / 2 + 1)], "winner")
    )
    tourney <- dplyr::bind_rows(tourney, new_tourney)

    # prepare for next round
    ot <- new_tourney
    this_round <- this_round + 1
  }

  # replace seeds with team names
  if (!is.null(teams)) {
    id <- suppressWarnings(!is.na(as.integer(tourney$away)))
    tourney$away[id] <- teams[ as.integer(tourney$away[id]) ]
    id <- suppressWarnings(!is.na(as.integer(tourney$home)))
    tourney$home[id] <- teams[ as.integer(tourney$home[id]) ]
  }

  tourney
}