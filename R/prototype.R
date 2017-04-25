#' Remove non-variant
#' @param tab [to complete in]
#'
#' @export

remove.nonvariant <- function(tab)
{
    ncols <- ncol(tab)
    i <- 3
    while(i < ncols){
        i <- i + 1
        m <- mean(as.numeric(tab[,i]))
        if (m == 1 | m == 0) {
          tab <- tab[,-i]
          i <- i - 1
          ncols <- ncols - 1
        }
    }
    return (tab)
}

#' Remove make binary
#' @param tab [to complete in]
#'
#' @export

make.binary <- function(tab)
{
  r <- nrow(tab)
  c <- ncol(tab)
  for(i in 1:r)
  {
     print(r)
     for (j in 1:c)
     {
         if(is.na(tab[i,j]))
            tab[i,j] <- 0
         if(tab[i,j] != 0)
           tab[i,j] <- 1
     }
  }

  return (tab)
}

#' @importFrom VA va
#' @export

readme <- function(undergradlist = list(), trainingset = NULL, testset = NULL,
                   formula = NULL, features = NULL, n.subset =
                   NULL, prob.wt = NULL, boot.se = NULL, nboot = NULL,
                   printit = NULL)
{
  if(is.null(testset))
    testset <- undergradlist$testset

  if(is.null(trainingset))
    trainingset <- undergradlist$trainingset

  hospital <- trainingset[,-c(1,3)]
  community <- testset[,-c(1,3)]

  if(is.null(formula))
    formula <- undergradlist$formula

  if(is.null(features))
    features <- undergradlist$features

  if(is.null(n.subset))
    n.subset <- undergradlist$n.subset

  if(is.null(prob.wt))
    prob.wt <- undergradlist$prob.wt

  if(is.null(boot.se))
    boot.se <- undergradlist$boot.se

  if(is.null(printit))
    printit <- undergradlist$printit

  if(is.null(nboot))
    nboot <- undergradlist$nboot

  return (va(formula = formula,
            data = list(hospital = hospital,community = community),
            nsymp = features,
            n.subset = n.subset,
            prob.wt = prob.wt,
            boot.se = boot.se,
            nboot = nboot,
            printit = printit))
}

#' @importFrom stats sd
#' @export

preprocess <- function(undergrad.results){
  if(is.null(undergrad.results$testset))
    cat("Input must be a list with a 'testset' object\n")
  if(is.null(undergrad.results$trainingset))
    cat("Input must be a list with a 'trainingset' object\n")
  v1 <- apply(as.matrix(undergrad.results$trainingset[, 4:dim(undergrad.results$trainingset)[2]]),2,sd)
  rmc1 <- 3 + which(v1 == 0)
  v2 <- apply(as.matrix(undergrad.results$testset[, 4:dim(undergrad.results$testset)[2]]),2, sd)
  rmc2 <- 3 + which(v2 == 0)
  remove.idx <- c(rmc1,rmc2)
  if(length(remove.idx)>0){
    cat("Removed ",length(remove.idx)," Invariant Columns \n")
    undergrad.preprocessed <- undergrad.results
    undergrad.preprocessed$trainingset <- undergrad.results$trainingset[,-remove.idx]
    undergrad.preprocessed$testset <- undergrad.results$testset[,-remove.idx]
    nnn <- dim(undergrad.preprocessed$trainingset)[1]
    txt <- paste("undergrad.preprocessed$formula <- ",
                 colnames(undergrad.preprocessed$trainingset)[4],"+ ... +",
                 colnames(undergrad.preprocessed$trainingset)[nnn],"~TRUTH",
                 sep = "")
    eval(parse(text=txt))
  }else{
    cat("Removed No Invariant Columns \n")
    undergrad.preprocessed <- undergrad.results
  }
  return(undergrad.preprocessed)
}


#' @importFrom stats as.formula
#' @importFrom utils read.csv write.table
#' @export

undergrad <-
  function(control ="control.txt",stem=T,strip.tags=T,ignore.case=T,table.file="tablefile.txt",threshold=0.01,pyexe=NULL,sep=NULL,printit=TRUE, fullfreq=FALSE, python3=FALSE, alphanumeric.only=TRUE, textincontrol=FALSE, remove.regex=NULL)
{
      os.type <- .Platform$OS.type

      if(is.null(pyexe))
        pyexe <- "python"
          if(python3==FALSE){
            call <- paste("'",system.file("makerfile", package = "ReadMe"),"'",sep="")
      }else{
           call <- paste("'",system.file("makerfile3-0.py", package = "ReadMe"),"'",sep="")
          }

      if(!stem)
        call <- paste(call, "--no-stem")
      if(!strip.tags)
        call <- paste(call, "--tags")
      if(!ignore.case)
        call <- paste(call, "--case-sensitive")
      if(!printit)
        call <- paste(call, "--silent")
      if(alphanumeric.only)
    call <- paste(call, "--alphanumeric-only")
      if(textincontrol)
    call <- paste(call, "--in-control-file")

      if(is.data.frame(control))
      {
        write.table(control, "readmetmpctrl.txt", row.names =FALSE, quote =FALSE)
        control <- "readmetmpctrl.txt"
      }

      if(!is.null(sep))
      {
        call <- paste(call, "--separator", paste('"', sep, '"', sep = ""))
      }

      if(!is.null(remove.regex))
      {
        call <- paste(call, " --remove-regex ", "'", remove.regex, "'", sep="")
      }


      call <- paste(call, "--control-file", paste("'",control,"'",sep=""))
      call <- paste(call, "--table-file", paste("'",table.file,"'",sep=""))
      call <- paste(call, '--threshold', threshold)

      print(paste(pyexe, call))
      sysres <- system(paste(pyexe, call))
      if(sysres == -1)
      {
        if(os.type == "unix")
          stop("Python pyexe must be installed and on system path.")
        # Running Windows, paths sometimes bad try common options

        pyexe <- NULL
        for (i in 10:50)
        {
            pyexe <- paste("/python",i,"/python.exe",sep="")
            if(file.exists(pyexe))
            {
                warning(paste("Python not on path. Using", pyexe))
                break
            }
        }

        if(is.null(pyexe))
        {
          stop("Python pyexe must be installed and on system path.")
        }


        sysres <- system(paste(pyexe,call))
       }
       if(sysres != 0)
       {
         stop("Python module failed. Aborting undergrad.")

       }
      tab <- read.csv(table.file)

  #tab <- remove.nonvariant(tab)

  # Return List
  ret <- list()
  ret$trainingset <- tab[tab$TRAININGSET==1,]
  ret$testset <- tab[tab$TRAININGSET==0,]

  cnames <- colnames(tab)
  ncols <- length(cnames)
  formula <- paste(cnames[4],"+...+",cnames[ncols],"~TRUTH",sep="")
  formula <- as.formula(formula)

  ret$formula <- formula
  ret$features <- 15
  ret$n.subset <- 300
  ret$prob.wt <- 1
  ret$boot.se <- FALSE
  ret$nboot = 300
  ret$printit = printit

  return (ret)
}
