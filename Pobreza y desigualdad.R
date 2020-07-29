#DATA RECUPERADA DE: 
#https://databank.bancomundial.org/Poverty-and-GINI/id/b49513bf#advancedDownloadOptions
#https://databank.worldbank.org/source/millennium-development-goals

#IMPORTAR LA DATA: 

#librerias
library(rio)
library(htmltab)
library(stringr)

#IMPORTAR DATA 
#se importa la data por hojas pues cada hoja trabaja un indicador diferente y es inviable hacer un merge entre las 3, dado que cada indicador es observado en un periodo de varios años

data1 ="https://github.com/MilagrosBadillo/TrabajoEAP2/raw/master/gini%20index.xlsx"
gini <- import(data1, sheet = "Data")
View(gini)

data2 ="https://github.com/MilagrosBadillo/TrabajoEAP2/raw/master/literacyrate.xlsx"
literacy <- import(data2, sheet = "Data")
View(literacy)

data3 ="https://github.com/MilagrosBadillo/TrabajoEAP2/raw/master/populationemployment.xlsx"
popuemploy <- import(data3, sheet = "Data")
View(popuemploy)

data4 ="https://github.com/MilagrosBadillo/TrabajoEAP2/raw/master/poverty190.xlsx"
poverty190 <- import(data4, sheet = "Data")
View(poverty190)

data5 ="https://github.com/MilagrosBadillo/TrabajoEAP2/raw/master/povertynational.xlsx"
povertynat <- import(data5, sheet = "Data")
View(povertynat)

data6 ="https://github.com/MilagrosBadillo/TrabajoEAP2/raw/master/selfemployment.xlsx"
selfemployment <- import(data6, sheet = "Data")
View(selfemployment)

data7 ="https://github.com/MilagrosBadillo/TrabajoEAP2/raw/master/vulnerableemployment.xlsx"
vulnemploy <- import(data7, sheet = "Data")
View(vulnemploy)

#LIMPIEZA DE DATA

names(gini)
names(vulnemploy)
names(selfemployment)
names(literacy)
names(popuemploy)
names(poverty190)
names(povertynat)

#como vemos, en cada base de datos existe una columna final llamada "reciente", que reúne los valores registrados más recientes de cada variable para cada país. 
#Se procederá a eliminar el resto de columnas y manrtener solo la columna con el nombre del país y la columna con el valor más reciente

gini[,c(1,2)]=NULL
gini[,c(2:12)]=NULL

povertynat[,c(1,2)]=NULL
povertynat[,c(2:12)]=NULL

vulnemploy[,c(2:19)]=NULL
selfemployment[,c(2:19)]=NULL
poverty190[,c(2:19)]=NULL
popuemploy[,c(2:19)]=NULL
literacy[,c(2:19)]=NULL

#Eliminamos filas sin data

gini=gini[-c(1:16),]
gini=gini[-c(186:190),]

povertynat=povertynat[-c(1:16),]
vulnemploy=vulnemploy[-c(264:268),]
selfemployment=selfemployment[-c(264:268),]
poverty190=poverty190[-c(264:268),]
popuemploy=popuemploy[-c(264:268),]
literacy=literacy[-c(264:268),]

gini[,]=lapply(gini[,], trimws,whitespace = "[\\h\\v]")
povertynat[,]=lapply(povertynat[,], trimws,whitespace = "[\\h\\v]")
vulnemploy[,]=lapply(vulnemploy[,], trimws,whitespace = "[\\h\\v]")
selfemployment[,]=lapply(selfemployment[,], trimws,whitespace = "[\\h\\v]")
poverty190[,]=lapply(poverty190[,], trimws,whitespace = "[\\h\\v]")
popuemploy[,]=lapply(popuemploy[,], trimws,whitespace = "[\\h\\v]")
literacy[,]=lapply(literacy[,], trimws,whitespace = "[\\h\\v]")

str(gini)
str(povertynat)
str(vulnemploy)
str(selfemployment)
str(poverty190)
str(popuemploy)
str(literacy)

#cambiamos el nombre de "país Name" a "Country name". No colocamos "país" porque las demás variables tienen "Country name" y usaremos esta variable para el merge.  
#Luego del merge, cambiaremos solo el nombre de la 1a columna de la base general a "País". Así, nos ahorramos algo de trabajo

names(gini)[names(gini)=="país Name"]="Country Name"
names(povertynat)[names(povertynat)=="país Name"]="Country Name"

names(gini)[names(gini)=="reciente"]="gini"
names(povertynat)[names(povertynat)=="reciente"]="povnat"
names(selfemployment)[names(selfemployment)=='reciente']="selfemp"
names(vulnemploy)[names(vulnemploy)=='reciente']="vulnempl"
names(poverty190)[names(poverty190)=='reciente']="pov190"
names(popuemploy)[names(popuemploy)=='reciente']="popemp"
names(literacy)[names(literacy)=='reciente']="liter"

#merge

merge1=merge(gini,povertynat, by.x='Country Name', by.y='Country Name')
merge2=merge(merge1,selfemployment, by.x='Country Name', by.y='Country Name')
merge3=merge(merge2,vulnemploy, by.x='Country Name', by.y='Country Name')
merge4=merge(merge3,poverty190, by.x='Country Name', by.y='Country Name')
merge5=merge(merge4,popuemploy, by.x='Country Name', by.y='Country Name')
pobydesig=merge(merge5,literacy, by.x='Country Name', by.y='Country Name')

names(pobydesig)
names(pobydesig)[names(pobydesig)=='Country Name']="pais"

#convertir a numérico y trabajr NA

pobydesig[,c(2:8)]=lapply(pobydesig[,c(2:8)],as.numeric)

#si decidimos omitir los NA, nos quedamos únicamente con 96 países
pobydesig=na.omit(pobydesig)


#CORREMOS CLUSTERS

#CORREMOS FACTORIAL



