library("shiny")


source("/srv/shiny-server/gene-surfer/functions.R")


# uniqueID<-"id_860342AX5"

# Define server logic for random distribution application
shinyServer(function(input, output) {
	
	output$table1 <- renderDataTable({ 
		# Take a dependency on input$goButton
		
		if(input$goButton == 0){
			return(NULL)
		}else if(input$goButton > 0) {
			print(paste("Ok",input$goButton))
		}
		
		uniqueID<-isolate(input$uniqueID)
		if(nchar(uniqueID)!=12)stop("uniqueID must have 12 digits")
		if(length(grep("^id_",uniqueID))==0)stop("uniqueID must start with 'id_'")
		pDataFile<-paste("/home/ubuntu/data/",uniqueID,"/pData.txt",sep="")
		
		if(!file.exists(paste("/home/ubuntu/data/",uniqueID,sep=""))){
			Sys.sleep(3) #wait a little to prevent raw-force fishing	
			stop("Did not find a user with this id")
		}
		
		
		#Get gender
		gender<-read.table(pDataFile,header=T,stringsAsFactors=F)[1,"gender"]
		
		
		BRCA_table_file <-"/srv/shiny-server/gene-surfer/BRCA/SNPs_to_analyze.txt"
		BRCA_table<-read.table(BRCA_table_file,sep="\t",header=T,stringsAsFactors=F,row.names=1)

		
		#get genotypes and calculate gheight
		genotypes<-get_genotypes(uniqueID=uniqueID,request=BRCA_table)
		
		BRCA_table[,"Your genotype"]<-genotypes[rownames(BRCA_table),]
		return(BRCA_table)
		
	})
	
})

