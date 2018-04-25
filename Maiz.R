getwd()

#cargar librerias

library(tidyr)
library(plyr)
library(dplyr)
library(readr)
library(MASS)

fullmat<- read.delim("../meta/maizteocintle_SNP50k_meta_extended.txt")

#Para ver qué clase de objeto es
class(fullmat)

#Para ver las primeras 6 filas del archivo
fullmat[1:6,]

#Contar número de muestras
nrow(fullmat)

#De cuántos estados se tienen muestras
length(levels(fullmat$Estado))

#Muestras colectadas antes de 1980
length(filter(fullmat,A.o._de_colecta<="1980"))

#Muestras por raza
razas<-table(fullmat$Raza)

#Promedio de la altitud a la que fueron colectadas las muestras

altitud<-fullmat$Altitud
mean(altitud)

#altitud máxima y mínima
max(altitud)
min(altitud)

#crear una df de raza Olotillo
Olo_df<-subset(fullmat, Raza == "Olotillo")
class(Olo_df)

#crear df de raza Reventador, Jala y Ancho
razas_otrasdf<-subset(fullmat, Raza == c("Reventador","Jala", "Ancho"))

#Crear matriz con df anterior 
razas_otrasmat<- as.matrix(razas_otrasdf)
is.matrix(razas_otrasmat)

#Guardarla en archivo submat.csv
write.matrix(razas_otrasmat, "../meta/submat.csv", sep = "\t")

