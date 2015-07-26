
library(e1071)
library(caret)

url<- "http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/"
dataWhite <- read.csv(paste(url,"winequality-white.csv",sep=""),sep=";")
dataRed <- read.csv(paste(url,"winequality-red.csv",sep=""),sep=";")

dataWhite$q <- as.factor(dataWhite$quality>5)
summary(dataWhite)

dataRed$q <- as.factor(dataRed$quality>5)
summary(dataRed)

intrainW<-createDataPartition(dataWhite$q,p=0.7,list=FALSE)
trainW <- dataWhite[intrainW,]
testW <- dataWhite[-intrainW,]

intrainR<-createDataPartition(dataRed$q,p=0.7,list=FALSE)
trainR <- dataRed[intrainR,]
testR <- dataRed[-intrainR,]

modelW <- train(q~volatile.acidity+alcohol,data=trainW,method="glm",family=binomial)
predW <- predict(modelW,newdata=testW)
confW <- confusionMatrix(predW,testW$q)

modelR <- train(q~volatile.acidity+alcohol,data=trainR,method="glm",family=binomial)
predR <- predict(modelR,newdata=testR)
confR <- confusionMatrix(predR,testR$q)




shinyServer(
  function(input,output){
    
    output$q<-renderPrint({
      if (input$v=="White")
        p<-predict(modelW,newdata=data.frame(volatile.acidity=input$va,alcohol=input$al))
      else
        p<-predict(modelR,newdata=data.frame(volatile.acidity=input$va,alcohol=input$al))
      if (p==T)  "GOOD" else "REGULAR/BAD"
    })
    
    output$a<-renderPrint({
      if (input$v=="White")
        sprintf("Accuracy: %s%%",round(confW$overall[1]*100,0))
      else
        sprintf("Accuracy:% s%%",round(confR$overall[1]*100,0))
    })
    
  }
)