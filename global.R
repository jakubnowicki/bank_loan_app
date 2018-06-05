rata <- function(kwota, liczba_rat, oprocentowanie) {
  q <- 1 + (oprocentowanie/12)
  
  rata <- kwota * q^liczba_rat * (q-1)/(q^liczba_rat - 1)
  
  rata
}

ifelse_long <- function(condition, yes, no) {
  if (condition) {
    return(yes)
  } else {
    return(no)
  }
}

zloty <- scales::dollar_format(prefix = '', suffix = ' zł')

if_colour <- function(data, breakpoint, below, over, equal) {
  if (data == breakpoint) {
    out <- equal
  } else {
    out <- ifelse(data > breakpoint, over, below)
  }
  return(out)
}

# modules
source(file = 'modules.R')