shinyUI(pageWithSidebar(
  headerPanel("Wine Quality"),
  sidebarPanel(
    numericInput(inputId="va", label = "Volatile Acidity",0.3,min=0.1,max=1.1,step=0.1),
    numericInput(inputId="al", label = "Alcohol",10,min=8,max=15,step=1),
    selectInput("v","Variety:",choices=c("Red","White"))
  ),
  mainPanel(
    h2("Quality:"),
    verbatimTextOutput('q'),
    verbatimTextOutput('a'),
    br(),
    p("Please wait until quality data appear in the boxes above"),
    p("Then select wine variety, and parameters to get quality predictions")
  )
))