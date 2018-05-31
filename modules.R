
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