library(shiny)
library(plotly)
library(shinydashboard)
#library(semantic.dashboard)
library(shinyjs)

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
        step = 0.1
      ),
      h3('Kredyt 1'),
      numericInput(
        inputId = 'oprocentowanie1',
        label = 'Oprocentowanie',
        value = 2,
        min = 0,
        max = 100,
        step = 0.1
      ),
      numericInput(
        inputId = 'kwota1',
        label = 'Kwota kredytu',
        value = 549000,
        min = 0,
        max = 1000000,
        step = 1000
      ),
      br(),
      h3('Kredyt 2'),
      numericInput(
        inputId = 'oprocentowanie2',
        label = 'Oprocentowanie',
        value = 2,
        min = 0,
        max = 100,
        step = 0.1
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
        title = 'Kredyt 1',
        solidHeader = TRUE,
        modyfikacja_wyswietlanie_UI('tekst_1'),
        actionButton(inputId = 'dodaj_1', label = 'Dodaj modyfikator'),
        actionButton(inputId = 'modyfikuj_1', label = 'Zmień modyfikatory'),
        actionButton(inputId = 'usun_1', label = 'Usuń modyfikatory')
      ),
      box(
        title = 'Kredyt 2',
        solidHeader = TRUE,
        modyfikacja_wyswietlanie_UI('tekst_2'),
        actionButton(inputId = 'dodaj_2', label = 'Dodaj modyfikator'),
        actionButton(inputId = 'modyfikuj_2', label = 'Zmień modyfikatory'),
        actionButton(inputId = 'usun_2', label = 'Usuń modyfikatory')
      )
    ),
    fluidRow(tabBox(id = 'tabs',title = '',width = 12,
                    tabPanel('Raty',plotlyOutput('plot1')),
                    tabPanel('Różnica',plotlyOutput('plot2')),
                    tabPanel('Suma różnic',plotlyOutput('plot3'))))
  )
)
