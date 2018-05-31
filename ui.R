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
        step = 1
      ),
      h3('Kredyt 1'),
      numericInput(
        inputId = 'oprocentowanie1',
        label = 'Oprocentowanie',
        value = 2,
        min = 0,
        max = 100,
        step = 1
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
        step = 1
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
        actionButton(inputId = 'dodaj_1', label = 'Dodaj modyfikator'),
        actionButton(inputId = 'modyfikuj_1', label = 'Zmień modyfikatory'),
        actionButton(inputId = 'usun_1', label = 'Usuń modyfikatory')
      ),
      box(
        title = 'Kredyt 2',
        solidHeader = TRUE,
        actionButton(inputId = 'dodaj_2', label = 'Dodaj modyfikator'),
        actionButton(inputId = 'modyfikuj_2', label = 'Zmień modyfikatory'),
        actionButton(inputId = 'usun_2', label = 'Usuń modyfikatory')
      )
    ),
    fluidRow(column(
      width = 3,
      numericInput(
        inputId = 'dodatki1',
        label = 'Dodatkowe płatności',
        value = 0,
        min = 0,
        max = 10000,
        step = 1
      )
    ),
    column(
      width = 3,
      sliderInput(
        inputId = 'dodatki_time1',
        label = 'Czas trwania dodatkowych opłat',
        min = 0,
        max = 60,
        value = c(0, 60),
        step = 1
      )
    )),
    fluidRow(
      column(
        width = 3,
        numericInput(
          inputId = 'mod1',
          label = 'Modyfikator oprocentowania 1',
          value = 0,
          min = 0,
          max = 100,
          step = 1
        ),
        sliderInput(
          inputId = 'mod_time1',
          label = "Czas modyfikacji 1",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      ),
      column(
        width = 3,
        numericInput(
          inputId = 'mod2',
          label = 'Modyfikator oprocentowania 2',
          value = 0,
          min = 0,
          max = 100,
          step = 1
        ),
        sliderInput(
          inputId = 'mod_time2',
          label = "Czas modyfikacji 2",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      ),
      column(
        width = 3,
        numericInput(
          inputId = 'mod3',
          label = 'Modyfikator oprocentowania 3',
          value = 0,
          min = 0,
          max = 100,
          step = 1
        ),
        sliderInput(
          inputId = 'mod_time3',
          label = "Czas modyfikacji 3",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      ),
      column(
        width = 3,
        numericInput(
          inputId = 'mod4',
          label = 'Modyfikator oprocentowania 4',
          value = 0,
          min = 0,
          max = 100,
          step = 1
        ),
        sliderInput(
          inputId = 'mod_time4',
          label = "Czas modyfikacji 4",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      )
    ),
    fluidRow(column(
      width = 3,
      numericInput(
        inputId = 'dodatki2',
        label = 'Dodatkowe płatności',
        value = 0,
        min = 0,
        max = 10000,
        step = 1
      )
    ),
    column(
      width = 3,
      sliderInput(
        inputId = 'dodatki_time2',
        label = 'Czas trwania dodatkowych opłat',
        min = 0,
        max = 60,
        value = c(0, 60),
        step = 1
      )
    )),
    fluidRow(
      column(
        width = 3,
        numericInput(
          inputId = 'mod1_2',
          label = 'Modyfikator oprocentowania 1',
          value = 0,
          min = 0,
          max = 100,
          step = 1
        ),
        sliderInput(
          inputId = 'mod_time1_2',
          label = "Czas modyfikacji 1",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      ),
      column(
        width = 3,
        numericInput(
          inputId = 'mod2_2',
          label = 'Modyfikator oprocentowania 2',
          value = 0,
          min = 0,
          max = 100,
          step = 1
        ),
        sliderInput(
          inputId = 'mod_time2_2',
          label = "Czas modyfikacji 2",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      ),
      column(
        width = 3,
        numericInput(
          inputId = 'mod3_2',
          label = 'Modyfikator oprocentowania 3',
          value = 0,
          min = 0,
          max = 100,
          step = 1
        ),
        sliderInput(
          inputId = 'mod_time3_2',
          label = "Czas modyfikacji 3",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      ),
      column(
        width = 3,
        numericInput(
          inputId = 'mod4_2',
          label = 'Modyfikator oprocentowania 4',
          value = 0,
          min = 0,
          max = 100,
          step = 1
        ),
        sliderInput(
          inputId = 'mod_time4_2',
          label = "Czas modyfikacji 4",
          min = 0,
          max = 60,
          value = c(0, 60),
          step = 1,
          round = T
        )
      )
    ),
    fluidRow(plotlyOutput('plot1')),
    fluidRow(plotlyOutput('plot2')),
    fluidRow(plotlyOutput('plot3'))
  )
)
