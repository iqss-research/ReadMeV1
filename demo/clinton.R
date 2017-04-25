oldwd <- getwd()
setwd(system.file("demofiles/clintonposts", package="ReadMe"))

undergrad.results <- undergrad(sep = ',')

undergrad.preprocess <- preprocess(undergrad.results)

readme.results <- readme(undergrad.preprocess)
setwd(oldwd)

