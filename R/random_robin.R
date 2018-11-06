#' Build a random-robin tournament
#' @param teams a list of unranked teams (character/vector)
#' @param n number of teams (numeric/scalar)
#' @param n_games how many total tournament games? (numeric/scalar)
#' @return a tibble with tournament schedule: {game, away, home}
#' @export
random_robin <- function(teams = NULL,
                          n = length(teams),
                          n_games = choose(n, 2)) {

  if (n_games > choose(n, 2))
    stop("Cannot play more than ", choose(n, 2), " games without rematches.")

  # - setup pair matrix
  A <- matrix(1, n, n)
  diag(A) <- 0
  # if (!home_away)
  #   A[lower.tri(A)] <- 0

  # - draw pairs
  games <- sample(which(A == 1), n_games)

  # - convert to home/away
  tourney <- tibble::tibble(
    game = 1:n_games,
    away = (games - 1) %% n + 1,
    home = floor((games - 1) / n) + 1
  )

  # replace seeds with team names
  if (!is.null(teams)) {
    tourney$away <- teams[tourney$away]
    tourney$home <- teams[tourney$home]
  }

  tourney
}