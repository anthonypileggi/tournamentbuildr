
tournamentbuildr <img src="man/figures/logo.png" align="right" />
=================================================================

An R package for building and scheduling tournaments.

### Build

Build your very own tournament!

``` r
library(tournamentbuildr)

# build a round-robin tournament
x <- Tournament$new(teams = LETTERS[1:8], type = "round_robin")

# view the schedule
x$schedule
#> # A tibble: 28 x 4
#>     game home  away  winner
#>    <int> <chr> <chr> <chr> 
#>  1     1 A     B     <NA>  
#>  2     2 A     C     <NA>  
#>  3     3 A     D     <NA>  
#>  4     4 A     E     <NA>  
#>  5     5 A     F     <NA>  
#>  6     6 A     G     <NA>  
#>  7     7 A     H     <NA>  
#>  8     8 B     C     <NA>  
#>  9     9 B     D     <NA>  
#> 10    10 B     E     <NA>  
#> # ... with 18 more rows
```

### Play

Once created, you can also record the results and track progress.

``` r
# play the first few games
x$play(game = 1, winner = "A")
x$play(game = 2, winner = "A")
x$play(game = 3, winner = "D")

# playing is chainable, cool!
x$play(4, "A")$play(5, "F")$play(6, "G")

# how do things stand now?
x$standings()
#> Warning: package 'bindrcpp' was built under R version 3.4.4
#> # A tibble: 8 x 6
#>   team      W     L     T    GP     P
#>   <chr> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 A         3     3     0     6     9
#> 2 D         1     0     0     1     3
#> 3 F         1     0     0     1     3
#> 4 G         1     0     0     1     3
#> 5 B         0     1     0     1     0
#> 6 C         0     1     0     1     0
#> 7 E         0     1     0     1     0
#> 8 H         0     0     0     0     0
```

### Variety

Right now, you can choose from these types of tournaments: - round-robin (`round_robin`) - random-robin (`random_robin`) - single-elimination bracket (`bracket`)

Note that for the single-elimination tournament, teams are assumed to be pre-ranked and ordered from best-to-worst.

``` r
# round-robin
Tournament$new(teams = LETTERS[1:8], type = "round_robin")

# random-robin (i.e., a round-robin that's been cut short!)
Tournament$new(teams = LETTERS[1:8], type = "random_robin", n_games = 10)

# single-elimination bracket
Tournament$new(teams = LETTERS[1:8], type = "bracket")
```

### Future Work

#### Equipment/Facility/Timeslot Scheduling

Given some restrictions on necessary equipment and availability of facilities, how should tournament games be scheduled?

#### Additional Tournament Options

-   games with &gt;2 teams competing (e.g., swim meet, hungry hungry hippos)
-   multiple divisions/leagues
-   double-elimination tournaments
-   capacity for customizable game attributes (e.g., goals for/against, shutouts)
