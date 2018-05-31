library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
library(shinyjs)
#library(semantic.dashboard)


server <- function(input, output) {
  observeEvent(input$dodaj_1, {
    showModal(modalDialog(
      size = 's',
      radioButtons(
        inputId = 'typ_1',
        label = 'Rodzaj modyfikatora',
        choices = list('Oprocentowanie' = 'opr', 'Opłaty' = 'opl'),
        inline = TRUE
      ),
      div(
        id = 'opr_1',
        modyfikacja_oprocentowania_UI('modyfikacja_1_opr', typ = 'opr')
      ),
      shinyjs::hidden(div(
        id = 'opl_1',
        modyfikacja_oprocentowania_UI('modyfikacja_1_opl', typ = 'opl')
      )),
      footer = div(
        actionButton(inputId = 'dodaj_modal_1', label = 'Dodaj'),
        modalButton('Anuluj')
      )
    ))
  })
  
  observeEvent(input$typ_1, {
    if (input$typ_1 == 'opr') {
      shinyjs::show(id = 'opr_1')
      shinyjs::hide(id = 'opl_1')
    } else {
      shinyjs::show(id = 'opl_1')
      shinyjs::hide(id = 'opr_1')
    }
  })
  
  kredyt_1_mods <- reactiveVal(NULL)
  
  observeEvent(input$dodaj_modal_1,{
    if (input$typ_1 == 'opr') {
      tmp <- callModule(modyfikacja_oprocentowania_server, id = 'modyfikacja_1_opr')
      tmp$typ <- 'opr'
    } else {
      tmp <- callModule(modyfikacja_oprocentowania_server, id = 'modyfikacja_1_opl')
      tmp$typ <- 'opl'
    }
    
    tmp <- as.data.frame(tmp)
    
    tmp2 <- as.data.frame(kredyt_1_mods())
    
    out <- rbind(tmp2, tmp)
    
    print(out)
    
    kredyt_1_mods(out)
    
    removeModal()
  })
  
  observeEvent(input$usun_1, {
    kredyt_1_mods(NULL)
  })
  
  proc1_v2 <- reactive({
    oprocentowanie <- rep(input$oprocentowanie1, times = 60)
    
    opr <- kredyt_1_mods()[kredyt_1_mods()$typ == 'opr',]
    opl <- kredyt_1_mods()[kredyt_1_mods()$typ == 'opl',]
    
    
    if (!is.null(opr) && (nrow(opr) > 0)) {
      for (i in 1:(nrow(opr)/2)) {
        rows <- c((i*2)-1, (i*2))
        print(rows)
        value <- unique(opr[rows,'mod'])
        
        oprocentowanie[opr[rows[1],'mod_time']:opr[rows[2],'mod_time']] <-
          oprocentowanie[opr[rows[1],'mod_time']:opr[rows[2],'mod_time']] + value
      }
    }
    
    oprocentowanie <- (oprocentowanie + input$wibor) / 100
    
    raty <- data.frame(lp = 1:60, oprocentowanie = oprocentowanie)
    raty <-
      raty %>% mutate(rata = rata(
        kwota = input$kwota1,
        liczba_rat = 360,
        oprocentowanie = oprocentowanie
      ))
    
    if(!is.null(opl) && (nrow(opl) > 0)) {
      for (i in 1:(nrow(opl)/2)) {
        rows <- c((i*2)-1, (i*2))
        
        value <- unique(opl[rows,'mod'])
        
        raty[opl[rows[1],'mod_time']:opl[rows[2],'mod_time'], 'rata'] <-
          raty[opl[rows[1],'mod_time']:opl[rows[2],'mod_time'],'rata'] + value
      }
    }
    
    raty
  })
  
  
  observeEvent(input$dodaj_2, {
    showModal(modalDialog(
      size = 's',
      radioButtons(
        inputId = 'typ_2',
        label = 'Rodzaj modyfikatora',
        choices = list('Oprocentowanie' = 'opr', 'Opłaty' = 'opl'),
        inline = TRUE
      ),
      div(
        id = 'opr_2',
        modyfikacja_oprocentowania_UI('modyfikacja_2_opr', typ = 'opr')
      ),
      shinyjs::hidden(div(
        id = 'opl_2',
        modyfikacja_oprocentowania_UI('modyfikacja_2_opl', typ = 'opl')
      )),
      footer = div(
        actionButton(inputId = 'dodaj_modal_2', label = 'Dodaj'),
        modalButton('Anuluj')
      )
    ))
  })
  
  observeEvent(input$typ_2, {
    if (input$typ_2 == 'opr') {
      shinyjs::show(id = 'opr_2')
      shinyjs::hide(id = 'opl_2')
    } else {
      shinyjs::show(id = 'opl_2')
      shinyjs::hide(id = 'opr_2')
    }
  })
  
  kredyt_2_mods <- reactiveVal(NULL)
  
  observeEvent(input$dodaj_modal_2,{
    if (input$typ_2 == 'opr') {
      tmp <- callModule(modyfikacja_oprocentowania_server, id = 'modyfikacja_2_opr')
      tmp$typ <- 'opr'
    } else {
      tmp <- callModule(modyfikacja_oprocentowania_server, id = 'modyfikacja_2_opl')
      tmp$typ <- 'opl'
    }
    
    tmp <- as.data.frame(tmp)
    
    tmp2 <- as.data.frame(kredyt_2_mods())
    
    out <- rbind(tmp2, tmp)
    
    print(out)
    
    kredyt_2_mods(out)
    
    removeModal()
  })
  
  observeEvent(input$usun_2, {
    kredyt_2_mods(NULL)
  })
  
  proc2_v2 <- reactive({
    oprocentowanie <- rep(input$oprocentowanie2, times = 60)
    
    opr <- kredyt_2_mods()[kredyt_2_mods()$typ == 'opr',]
    opl <- kredyt_2_mods()[kredyt_2_mods()$typ == 'opl',]
    
    
    if (!is.null(opr) && (nrow(opr) > 0)) {
      for (i in 1:(nrow(opr)/2)) {
        rows <- c((i*2)-1, (i*2))
        print(rows)
        value <- unique(opr[rows,'mod'])
        
        oprocentowanie[opr[rows[1],'mod_time']:opr[rows[2],'mod_time']] <-
          oprocentowanie[opr[rows[1],'mod_time']:opr[rows[2],'mod_time']] + value
      }
    }
    
    oprocentowanie <- (oprocentowanie + input$wibor) / 100
    
    raty <- data.frame(lp = 1:60, oprocentowanie = oprocentowanie)
    raty <-
      raty %>% mutate(rata = rata(
        kwota = input$kwota2,
        liczba_rat = 360,
        oprocentowanie = oprocentowanie
      ))
    
    if(!is.null(opl) && (nrow(opl) > 0)) {
      for (i in 1:(nrow(opl)/2)) {
        rows <- c((i*2)-1, (i*2))
        
        value <- unique(opl[rows,'mod'])
        
        raty[opl[rows[1],'mod_time']:opl[rows[2],'mod_time'], 'rata'] <-
          raty[opl[rows[1],'mod_time']:opl[rows[2],'mod_time'],'rata'] + value
      }
    }
    
    raty
  })


  output$plot1 <- renderPlotly({
    tmp1 <- proc1_v2() %>% mutate(kredyt = '1')
    tmp2 <- proc2_v2() %>% mutate(kredyt = '2')
    
    tmp <- rbind(tmp1, tmp2)
    
    
    tmp %>% as.data.frame() %>%
      ggplot(aes(x = lp, y = rata, colour = kredyt)) + geom_line() + geom_point() + theme_minimal()
    
  })
  
  output$plot2 <- renderPlotly({
    tmp <- proc1_v2()$rata - proc2_v2()$rata
    
    data.frame(lp = 1:60, roznica = tmp) %>%
      ggplot(aes(x = lp, y = roznica)) + geom_line() + geom_point() + theme_minimal() + scale_y_continuous(limits = c(0, NA))
    
    
  })
  
  
  output$plot3 <- renderPlotly({
    tmp <- proc1_v2()$rata - proc2_v2()$rata
    
    data.frame(lp = 1:60, roznica = tmp) %>%  mutate(kumul = cumsum(roznica)) %>%
      ggplot(aes(x = lp, y = kumul)) + geom_line() + geom_point() + theme_minimal()
    
    
  })
}
