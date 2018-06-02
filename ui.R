library(shiny)
library(plotly)
library(shinydashboard)
#library(semantic.dashboard)
library(shinyjs)
library(shinyBS)

dashboardPage(
  header = dashboardHeader(title = "Kalkulator rat kredytu"),
  sidebar = dashboardSidebar(
    sidebarMenu(
      numericInput(
        inputId = 'wibor',
        label = 'WIBOR',
        value = 1.7,
        min = 0,
        max = 100,
        step = 0.01
      ),
      numericInput(
        inputId = 'lata',
        label = 'Na ile lat?',
        value = 30,
        min = 1,
        max = 35,
        step = 1
      ),
      div(id = 'nazwa_kredyt_1',h3(textOutput('nazwa_1_title'))),
      numericInput(
        inputId = 'oprocentowanie1',
        label = 'Oprocentowanie',
        value = 2,
        min = 0,
        max = 100,
        step = 0.01
      ),
      bsTooltip(id = "nazwa_kredyt_1", "Kliknij, aby zmienić nazwę",
                "right"),
      numericInput(
        inputId = 'kwota1',
        label = 'Kwota kredytu',
        value = 549000,
        min = 0,
        max = 1000000,
        step = 1000
      ),
      br(),
      div(id = 'nazwa_kredyt_2',h3(textOutput('nazwa_2_title'))),
      bsTooltip(id = "nazwa_kredyt_2", "Kliknij, aby zmienić nazwę",
                "right"),
      numericInput(
        inputId = 'oprocentowanie2',
        label = 'Oprocentowanie',
        value = 2,
        min = 0,
        max = 100,
        step = 0.01
      ),
      numericInput(
        inputId = 'kwota2',
        label = 'Kwota kredytu',
        value = 549000,
        min = 0,
        max = 1000000,
        step = 1000
      )
    )
  ),
  body = dashboardBody(
    useShinyjs(),
    fluidRow(
      box(
        title = textOutput('nazwa_1_box_title'),
        solidHeader = TRUE,
        modyfikacja_wyswietlanie_UI('tekst_1'),
        actionButton(inputId = 'dodaj_1', label = 'Dodaj modyfikator'),
        actionButton(inputId = 'usun_1', label = 'Usuń modyfikatory')
      ),
      box(
        title = textOutput('nazwa_2_box_title'),
        solidHeader = TRUE,
        modyfikacja_wyswietlanie_UI('tekst_2'),
        actionButton(inputId = 'dodaj_2', label = 'Dodaj modyfikator'),
        actionButton(inputId = 'modyfikuj_2', label = 'Zmień modyfikatory')
      )
    ),
    fluidRow(tabBox(id = 'tabs',title = '',width = 12,
                    tabPanel('Raty',plotlyOutput('plot1')),
                    tabPanel('Różnica',plotlyOutput('plot2')),
                    tabPanel('Suma różnic',plotlyOutput('plot3'))))
  )
)
