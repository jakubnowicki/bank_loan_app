
modyfikacja_oprocentowania_UI <- function(id, typ) {
  
  ns <- NS(id)
  
  if (typ == 'opr') {
   return({
     div(
       numericInput(
         inputId = ns('mod'),
         label = paste('Modyfikator oprocentowania'),
         value = 0,
         min = -100,
         max = 100,
         step = 0.1
       ),
       sliderInput(
         inputId = ns('mod_time'),
         label = "Czas modyfikacji",
         min = 0,
         max = 60,
         value = c(0, 60),
         step = 1,
         round = T
       )
     )
   }) 
  } else {
    return({
      div(
        numericInput(
          inputId = ns('mod'),
          label = paste('Opłaty'),
          value = 0,
          min = 0,
          max = 2000,
          step = 1
        ),
        sliderInput(
          inputId = ns('mod_time'),
          label = "Czas modyfikacji",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      )
    })
  }
  
}

modyfikacja_oprocentowania_server <- function(input, output, session) {
  modyfikator_val <- reactive({
    list(mod = input$mod, mod_time = input$mod_time)
  })
  
  return(modyfikator_val())
}

modyfikacje_wyswietlanie_server <- function(input, output, session, data) {
  opr <- data[data$typ == 'opr',]
  opl <- data[data$typ == 'opl',]
  
  oprocentowanie <- ''
  
  if (!is.null(opr) && (nrow(opr) > 0)) {
    oprocentowanie <- paste0(h5('Oprocentowanie:'))
    for (i in 1:(nrow(opr)/2)) {
      rows <- c((i*2)-1, (i*2))

      value <- unique(opr[rows,'mod'])
      time_mod <- c(opr[rows[1],'mod_time'], opr[rows[2],'mod_time'])
      tekst <- paste0(strong('Modyfikacja: '),value,'% ',strong('Miesiące: '), time_mod[1],'-',time_mod[2],br())
      oprocentowanie <- paste0(oprocentowanie, tekst)
      
    }
  }
  
  if (nchar(oprocentowanie) == 0) {
    oprocentowanie <- paste0(h5('Oprocentowanie: -'))
  }
  
  oplaty <- ''
  
  if (!is.null(opl) && (nrow(opl) > 0)) {
    oplaty <- paste0(h5('Opłaty:'))
    for (i in 1:(nrow(opl)/2)) {
      rows <- c((i*2)-1, (i*2))
      
      value <- unique(opl[rows,'mod'])
      time_mod <- c(opl[rows[1],'mod_time'], opl[rows[2],'mod_time'])
      tekst <- paste0(strong('Modyfikacja: '),value,'zł ',strong('Miesiące: '), time_mod[1],'-',time_mod[2],br())
      oplaty <- paste0(oplaty, tekst)
      
    }
  }
  
  if (nchar(oplaty) == 0) {
    oplaty <- paste0(h5('Opłaty: -'))
  }
  
  output$tekst <- renderText(paste0(oprocentowanie,oplaty))
}

modyfikacja_wyswietlanie_UI <- function(id) {
  ns <- NS(id)
  
  htmlOutput(ns('tekst'))
}