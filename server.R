library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
library(shinyjs)
library(shinyBS)
library(DT)
#library(semantic.dashboard)


server <- function(input, output) {
  
  liczba_rat <- reactive({
    input$lata*12
  })
  
  observeEvent(input$dodaj_1, {
    showModal(modalDialog(
      size = 's',
      radioButtons(
        inputId = 'typ_1',
        label = 'Rodzaj modyfikatora',
        choices = list('Oprocentowanie' = 'opr', 'Opłaty' = 'opl'),
        inline = TRUE
      ),
      radioButtons(
        inputId = 'dodaj_odejmij_1',
        label = NULL,
        choices = list('dodaj' = 1, 'odejmij' = -1),selected = 1,
        inline = TRUE
      ),
      div(
        id = 'opr_1',
        modyfikacja_oprocentowania_UI('modyfikacja_1_opr', typ = 'opr', zakres = liczba_rat())
      ),
      shinyjs::hidden(div(
        id = 'opl_1',
        modyfikacja_oprocentowania_UI('modyfikacja_1_opl', typ = 'opl', zakres = liczba_rat())
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
  
  observeEvent(input$dodaj_modal_1, {
    if (input$typ_1 == 'opr') {
      tmp <-
        callModule(modyfikacja_oprocentowania_server, id = 'modyfikacja_1_opr')
      tmp$typ <- 'opr'
    } else {
      tmp <-
        callModule(modyfikacja_oprocentowania_server, id = 'modyfikacja_1_opl')
      tmp$typ <- 'opl'
    }
    tmp <- as.data.frame(tmp)
    tmp$mod <- tmp$mod*as.numeric(input$dodaj_odejmij_1)
    tmp2 <- as.data.frame(kredyt_1_mods())
    
    out <- rbind(tmp2, tmp)
    

    
    kredyt_1_mods(out)
    
    removeModal()
  })
  
  observeEvent(input$usun_1, {
    kredyt_1_mods(NULL)
  })
  
  proc1_v2 <- reactive({
    
    oprocentowanie <- rep(input$oprocentowanie1, times = liczba_rat())
    
    opr <- kredyt_1_mods()[kredyt_1_mods()$typ == 'opr',]
    opl <- kredyt_1_mods()[kredyt_1_mods()$typ == 'opl',]
    
    
    if (!is.null(opr) && (nrow(opr) > 0)) {
      for (i in 1:(nrow(opr) / 2)) {
        rows <- c((i * 2) - 1, (i * 2))
        print(rows)
        value <- unique(opr[rows, 'mod'])
        
        oprocentowanie[opr[rows[1], 'mod_time']:opr[rows[2], 'mod_time']] <-
          oprocentowanie[opr[rows[1], 'mod_time']:opr[rows[2], 'mod_time']] + value
      }
    }
    
    oprocentowanie <- (oprocentowanie + input$wibor) / 100
    
    raty <- data.frame(lp = 1:liczba_rat(), oprocentowanie = oprocentowanie)
    raty <-
      raty %>% mutate(rata = rata(
        kwota = input$kwota1,
        liczba_rat = liczba_rat(),
        oprocentowanie = oprocentowanie
      ))
    
    if (!is.null(opl) && (nrow(opl) > 0)) {
      for (i in 1:(nrow(opl) / 2)) {
        rows <- c((i * 2) - 1, (i * 2))
        
        value <- unique(opl[rows, 'mod'])
        
        raty[opl[rows[1], 'mod_time']:opl[rows[2], 'mod_time'], 'rata'] <-
          raty[opl[rows[1], 'mod_time']:opl[rows[2], 'mod_time'], 'rata'] + value
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
      radioButtons(
        inputId = 'dodaj_odejmij_2',
        label = NULL,
        choices = list('dodaj' = 1, 'odejmij' = -1),selected = 1,
        inline = TRUE
      ),
      div(
        id = 'opr_2',
        modyfikacja_oprocentowania_UI('modyfikacja_2_opr', typ = 'opr', zakres = liczba_rat())
      ),
      shinyjs::hidden(div(
        id = 'opl_2',
        modyfikacja_oprocentowania_UI('modyfikacja_2_opl', typ = 'opl', zakres = liczba_rat())
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
  
  observeEvent(input$dodaj_modal_2, {
    if (input$typ_2 == 'opr') {
      tmp <-
        callModule(modyfikacja_oprocentowania_server, id = 'modyfikacja_2_opr')
      tmp$typ <- 'opr'
    } else {
      tmp <-
        callModule(modyfikacja_oprocentowania_server, id = 'modyfikacja_2_opl')
      tmp$typ <- 'opl'
    }
    
    tmp <- as.data.frame(tmp)
    tmp$mod <- tmp$mod*as.numeric(input$dodaj_odejmij_2)
    tmp2 <- as.data.frame(kredyt_2_mods())
    
    out <- rbind(tmp2, tmp)
    
    kredyt_2_mods(out)
    
    removeModal()
  })
  
  observeEvent(input$usun_2, {
    kredyt_2_mods(NULL)
  })
  
  proc2_v2 <- reactive({
    oprocentowanie <- rep(input$oprocentowanie2, times = liczba_rat())
    
    opr <- kredyt_2_mods()[kredyt_2_mods()$typ == 'opr',]
    opl <- kredyt_2_mods()[kredyt_2_mods()$typ == 'opl',]
    
    
    if (!is.null(opr) && (nrow(opr) > 0)) {
      for (i in 1:(nrow(opr) / 2)) {
        rows <- c((i * 2) - 1, (i * 2))
        print(rows)
        value <- unique(opr[rows, 'mod'])
        
        oprocentowanie[opr[rows[1], 'mod_time']:opr[rows[2], 'mod_time']] <-
          oprocentowanie[opr[rows[1], 'mod_time']:opr[rows[2], 'mod_time']] + value
      }
    }
    
    oprocentowanie <- (oprocentowanie + input$wibor) / 100
    
    raty <- data.frame(lp = 1:liczba_rat(), oprocentowanie = oprocentowanie)
    raty <-
      raty %>% mutate(rata = rata(
        kwota = input$kwota2,
        liczba_rat = liczba_rat(),
        oprocentowanie = oprocentowanie
      ))
    
    if (!is.null(opl) && (nrow(opl) > 0)) {
      for (i in 1:(nrow(opl) / 2)) {
        rows <- c((i * 2) - 1, (i * 2))
        
        value <- unique(opl[rows, 'mod'])
        
        raty[opl[rows[1], 'mod_time']:opl[rows[2], 'mod_time'], 'rata'] <-
          raty[opl[rows[1], 'mod_time']:opl[rows[2], 'mod_time'], 'rata'] + value
      }
    }
    
    raty
  })
  
  
  output$plot1 <- renderPlotly({
    tmp1 <- proc1_v2() %>% mutate(kredyt = nazwa_1())
    tmp2 <- proc2_v2() %>% mutate(kredyt = nazwa_2())
    
    tmp <- rbind(tmp1, tmp2)
    
    
    wykres <- tmp %>% as.data.frame() %>% mutate(`miesiąc` = lp) %>%
      ggplot(aes(x = `miesiąc`, y = rata, colour = kredyt)) + geom_line() + geom_point() + theme_minimal() + scale_y_continuous(labels = scales::dollar_format(prefix = '', suffix = ' zł'))
    ggplotly(wykres) %>% rangeslider(start = 1,end = 60, thickness = 0.1, borderwidth = 1)
  })
  
  
  output$plot2 <- renderPlotly({
    tmp <- proc1_v2()$rata - proc2_v2()$rata
    
    wykres <-data.frame(`miesiąc` = 1:liczba_rat(), `różnica` = tmp) %>%
      ggplot(aes(x = `miesiąc`, y = `różnica`)) + geom_line(colour = 'skyblue3') + geom_point(colour = 'skyblue3') + theme_minimal() + scale_y_continuous(labels = zloty) + labs(y = paste0('Różnica rat (',nazwa_1(),' - ',nazwa_2(),')'))
    ggplotly(wykres) %>% rangeslider(start = 1,end = 60, thickness = 0.1, borderwidth = 1)
    
  })
  
  
  output$plot3 <- renderPlotly({
    tmp <- proc1_v2()$rata - proc2_v2()$rata
    
    wykres <- data.frame(`miesiąc` = 1:liczba_rat(), roznica = tmp) %>%  mutate(suma = cumsum(roznica)) %>%
      ggplot(aes(x = `miesiąc`, y = suma)) + geom_line(colour = 'skyblue3') + geom_point(colour = 'skyblue3') + theme_minimal() + scale_y_continuous(labels = zloty)+ labs(y = paste0('Suma różnic rat (',nazwa_1(),' - ',nazwa_2(),')'))
    ggplotly(wykres) %>% rangeslider(start = 1,end = 60, thickness = 0.1, borderwidth = 1)
    
  })
  
  
  output$tabela_rat <- DT::renderDataTable(
    
    DT::datatable({
      kolumny <- c('miesiąc',paste0(nazwa_1(),': oprocentowanie'),paste0(nazwa_1(),': rata'),paste0(nazwa_2(),': oprocentowanie'),paste0(nazwa_2(),': rata'))
      tmp1 <-
        proc1_v2() %>% transmute(
          `miesiąc` = lp,
          oprocentowanie_1 = oprocentowanie,
          rata_1 = round(rata, 2)
        )
      tmp2 <-
        proc2_v2() %>% transmute(oprocentowanie_2 = oprocentowanie, rata_2 = round(rata, 2))
      cbind(tmp1, tmp2)
    }, rownames = FALSE , colnames = kolumny, options = list(
      lengthMenu = c(12, 24, 36),
      pageLength = 12,
      rowId = NULL
    ))  %>% formatPercentage( ~ oprocentowanie_1 + oprocentowanie_2, 2) %>% formatCurrency( ~ rata_1 + rata_2, currency = ' zł', before = FALSE)
  )
  
  observe({
    callModule(modyfikacje_wyswietlanie_server,
               data = kredyt_1_mods(),
               id = 'tekst_1')
    callModule(modyfikacje_wyswietlanie_server,
               data = kredyt_2_mods(),
               id = 'tekst_2')
  })
  
  nazwa_1 <- reactiveVal('Kredyt 1')
  
  onclick(id = "nazwa_kredyt_1", {
    showModal(modalDialog(
      title = 'Nazwa banku 1',
      textInput(
        inputId = 'input_nazwa_1',
        label = '',
        value = nazwa_1(),
        placeholder = nazwa_1()
      ),
      size = 's',
      easyClose = T,
      footer = div(
        actionButton(inputId = 'dodaj_nazwe_1', label = 'Dodaj'),
        modalButton('Anuluj')
      )
    ))
  })
  
  observeEvent(input$dodaj_nazwe_1, {
    nazwa_1(input$input_nazwa_1)
    removeModal()
  })
  
  output$nazwa_1_box_title <- renderText(nazwa_1())
  
  output$nazwa_1_title <- renderText(nazwa_1())
  
  nazwa_2 <- reactiveVal('Kredyt 2')
  
  onclick(id = "nazwa_kredyt_2",  {
    showModal(modalDialog(
      title = 'Nazwa banku 2',
      textInput(
        inputId = 'input_nazwa_2',
        label = '',
        value = nazwa_2(),
        placeholder = nazwa_2()
      ),
      size = 's',
      easyClose = T,
      footer = div(
        actionButton(inputId = 'dodaj_nazwe_2', label = 'Dodaj'),
        modalButton('Anuluj')
      )
    ))
  })
  
  observeEvent(input$dodaj_nazwe_2, {
    nazwa_2(input$input_nazwa_2)
    removeModal()
  })
  
  output$nazwa_2_box_title <- renderText(nazwa_2())
  
  output$nazwa_2_title <- renderText(nazwa_2())
}


