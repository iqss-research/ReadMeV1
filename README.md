ReadMe
========

Daniel Hopkins and Gary King

## Description

The ReadMe software package for R takes as input a set of text
documents (such as speeches, blog posts, newspaper articles, judicial
opinions, movie reviews, etc.), a categorization scheme chosen by the
user (e.g., ordered positive to negative sentiment ratings, unordered
policy topics, or any other mutually exclusive and exhaustive set of
categories), and a small subset of text documents hand classified into
the given categories. If used properly, ReadMe will report,
within sampling error of the truth, the proportion of documents within
each of the given categories among those not hand coded. ReadMe
computes the distribution within categories without the more error
prone intermediate step of classifying individual documents. Various
other procedures are included to make processing text easy.
See Daniel Hopkins and Gary King, "A Method of Automated Nonparametric Content
Analysis for Social Science," American Journal of Political
Science, <http://gking.harvard.edu/files/abs/words-abs.shtml>


## Example

```r
library(ReadMe)

oldwd <- getwd()
setwd(system.file("demofiles/clintonposts",
      package = "ReadMe"))

undergrad.results <- undergrad(sep = ',')

undergrad.preprocess <- preprocess(undergrad.results)

readme.results <- readme(undergrad.preprocess)
setwd(oldwd)
```
