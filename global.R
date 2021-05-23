library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(echarts4r)
library(readr)
library(dplyr)
library(plotly)
library(DT)

VGData <- read_csv('vgsales.csv') %>%
  mutate(Year=as.numeric(Year)) %>%
  filter(!is.na(Year) & Year<=2016)
