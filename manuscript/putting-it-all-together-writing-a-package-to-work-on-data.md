# Chapter 6 Putting it all together: writing a package to work on data

Everything we have seen until now allows us to develop our own packages
with the goal of *working* on data. By *working* on data I mean any
operation that involves cleaning, transforming, analyzing or plotting
data. I will summarize why everything we have seen until now helps us in
this task:

1.  Functional programming makes our code easier to test
2.  Unit tests make sure our code is correct
3.  Packages allows us to forget about paths, so unit tests are easier
    to run, makes writing documentation easier and makes sharing our
    code easier

For the rest of this chapter we are going to work with mock datasets
that I created. The data is completely random but for our purposes it
does not matter. In this chapter, we are going to write a number of
functions with the goal of going from these awful, badly formatted
datasets to a nice longitudinal data set.

## 6.1 Getting the data

You can download the data from the [github
repository](https://github.com/b-rodrigues/functional_programming_and_unit_testing_for_data_munging)
of the book. There are 5 `.csv` files that comprise the data sets we are
going to work with:

  - `data_2000.csv`
  - `data_2001.csv`
  - `data_2002.csv`
  - `data_2003.csv`
  - `data_2004.csv`

The first step, of course, is to load these datasets into R. For 5
datasets, I assume that you would simply write the following into
Rstudio:

``` sourceCode r
data_2000 <- read.csv("/path/to/data/data_2000.csv", header = T)
data_2001 <- read.csv("/path/to/data/data_2001.csv", header = T)
data_2002 <- read.csv("/path/to/data/data_2002.csv", header = T)
data_2003 <- read.csv("/path/to/data/data_2003.csv", header = T)
data_2004 <- read.csv("/path/to/data/data_2004.csv", header = T)
```

This might be ok for 5 datasets which are named very similarily,
especially since you can do block editing in Rstudio. However, imagine
that you have hundreds, thousands, of datasets? And image that their
names are not so well formatted as here? We will start our package by
writing a function that reads a lot of datasets at once.

## 6.2 Your first data munging package: `prepareData`

### 6.2.1 Reading a lot of datasets at once

Using Rstudio, create a new project like shown in the previous chapter,
and select *R package*. Give it a name, for example `prepareData`. If
you are working with datasets that have a name, for example the *Penn
World Tables*, you could call your package `preparePWT`, or something
similar. By the way, we are going to work on some test data sets that I
created for illustration purposes. When you will develop your own
package to work on your own data, you do not have to write unit tests
that use you original data. A subset can be enough, or taking the time
to create a small test dataset might be preferable. It depends on what
features of your functions you want to test. The first function I will
show you is actually very general and could work with any datasets. This
means that I created a package called `broTools`[<sup>3</sup>](#fn3)
that contains all the little functions that I use daily. But for
illustration purposes, we will put this function inside `prepareData`,
even if it does not have anything directly to do with it. I have called
this function `read_list()` and here is the source code:

``` sourceCode r
#' Reads a list of datasets
#' @param list_of_datasets A list of datasets (names of datasets are strings)
#' @param read_func A function, the read function to use to read the data
#' @return Returns a list of the datasets
#' @export
#' @examples
#' \dontrun{
#' setwd("path/to/datasets/")
#' list_of_datasets <- list.files(pattern = "*.csv")
#' list_of_loaded_datasets <- read_list(list_of_datasets, read_func = read.csv)
#' }
read_list <- function(list_of_datasets, read_func, ...){

    stopifnot(length(list_of_datasets)>0)

    read_and_assign <- function(dataset, read_func){
        dataset_name <- as.name(dataset)
        dataset_name <- read_func(dataset, ...)
}

    # invisible is used to suppress the unneeded output
    output <- invisible(
        purrr::map(list_of_datasets,
                   read_and_assign,
                   read_func = read_func)
                   )

    # Remove the ".csv" at the end of the data set names
    names_of_datasets <- c(unlist(strsplit(list_of_datasets, "[.]"))[c(T, F)])
    names(output) <- names_of_datasets
    return(output)
}
```

The basic idea of `read_list()` is that it takes a list of datasets as
the first argument, then a functon to read in the datasets as a second
argument and as a third argument the famous `...`, which allows the user
to specify further options to other functions that are contained in the
body of the main function. In this case, further arguments are passed to
the `read_func` function, for example if your data does not contains
headers, you could pass the option `header = FALSE` to `read_list()`
which would then get passed to `read_func`. I use `purrr::map()` to
apply `read_and_assign()`; a helper function whose role is to read in a
dataset and save it with its name, to the whole list of datasets. This
step is wrapped inside `invisible()` as to remove unecessary output.
Finally I use `strsplit()` with a regular expression to remove the
extension of the dataset from its name. The output is thus a list of
datasets where each dataset is named as it is on your hard drive. Save
this function in a script called `read_list.R` and save it in the `R`
folder of your package. Now you need to invoke `roxygen2::roxygenise()`
to create the documentation of your function. I suggest you also run
`devtools::use_testtthat`. This creates the necessary folder to hold
your tests as well as creating a small `testthat.R` file with the code
that gets called to run your tests. Without this, you might encounter
weird issues (for example, `covr` not finding your tests\!).

``` sourceCode r
roxygen2::roxygenise()
```

    First time using roxygen2. Upgrading automatically...
    Updating roxygen version in  /home/bro/Dropbox/prepareData/DESCRIPTION
    Writing NAMESPACE
    Writing read_list.Rd

``` sourceCode r
devtools::use_testthat()
```

    * Adding testthat to Suggests
    * Creating `tests/testthat`.
    * Creating `tests/testthat.R` from template.

Now let us check the coverage of our package:

``` sourceCode r
library("covr")

cov <- package_coverage()

shine(cov)
```

Unsurprisingly we get a coverage of 0% for our package. We will now
write a unit test for this function. For example, let us see if the
condition `stopifnot(length(list_of_datasets)>0)` works. Because you ran
`detools::use_testthat()` you should have a folder called `tests` on the
root of your project directory. In it, there is a folder called
`testthat`. This is were you will save your unit tests, and any file
needed for the tests to run (for example, mock datasets that are used by
tests).

``` sourceCode r
library("testthat")
library("prepareData")

test_that("Try to import empty list of datasets: this may be caused because
          the path to the datasets is wrong for instance",{

    list_datasets <- NULL

    expect_error(read_list(list_datasets, read_csv, col_types = cols()))
})
```

Run the test using `CTRL-SHIFT-T` if you are on Rstudio.

    ==> devtools::test()
    
    Loading prepareData
    Loading required package: testthat
    Testing prepareData
    .
    DONE ===========================================================================

This is the output you should see. If you check the coverage of your
package, you should see that the line
`stopifnot(length(list_of_datasets)>0)` is highlightened in green and
you should have around 9% of coverage for your package. You can spend
some to to get the coverage as high as possible, but you have to take
into account the time it will take you to write tests vs the benefits
you are going to get from them. In the case of this function, I do not
really see what more you could test.

Let us use this function to read in the datasets:

``` sourceCode r
library("readr")
library("purrr")
library("tibble")

list_of_data <- Sys.glob("assets/*.csv")

datasets <- read_list(list_of_data, read_csv, col_type = cols())
```

`list_of_data` is a variable that contains the path to the datasets. I
used `Sys.glob("assets/*.csv")` to find the datasets. The datasets are
saved in the `assets` folder of the book and end with the `.csv`
extension. You could also use `list.files("*.csv")` to achieve the same.
Let’s take a look inside this list using `head()`. Since `head()` only
works on single data frames or tibbles, we use `map()` to apply `head()`
to each data frame on the list.

``` sourceCode r
map(datasets, head)
```

    ## $`assets/data_2000`
    ## # A tibble: 6 × 6
    ##      id Variable1 other2000 gender2000 eggs2000      spam2000
    ##   <int>     <int>     <int>      <chr>    <int>         <chr>
    ## 1     1        32         3          F       80 -1.5035369157
    ## 2     2        28         2          F       20 -0.1836726393
    ## 3     3        36         4          M       58 -0.6851988608
    ## 4     4        28         1          F       30  1.9900760191
    ## 5     5        34         3          F       14  0.4324725273
    ## 6     6        30         3          F       40   -0.79001853
    ## 
    ## $`assets/data_2001`
    ## # A tibble: 6 × 6
    ##      id VARIABLE1 other2001 Gender2001 eggs2001   spam2001
    ##   <int>     <int>     <int>      <chr>    <int>      <dbl>
    ## 1     1        32         3          F       80 -1.5035369
    ## 2     2        28         2          F       20 -0.1836726
    ## 3     3        36         4          M       58 -0.6851989
    ## 4     4        28         1          F       30  1.9900760
    ## 5     5        34         3          F       14  0.4324725
    ## 6     6        30         3          F       40 -0.7900185
    ## 
    ## $`assets/data_2002`
    ## # A tibble: 6 × 6
    ##      ID variable1 Other2002 gender2002 eggs2002   Spam2002
    ##   <int>     <int>     <int>      <chr>    <int>      <dbl>
    ## 1     1        32         3          F       80 -1.5035369
    ## 2     2        28         2          F       20 -0.1836726
    ## 3     3        36         4          M       58 -0.6851989
    ## 4     4        28         1          F       30  1.9900760
    ## 5     5        34         3          F       14  0.4324725
    ## 6     6        30         3          F       40 -0.7900185
    ## 
    ## $`assets/data_2003`
    ## # A tibble: 6 × 6
    ##      id variable1 other2003 gender2003 EGGS2003   spam2003
    ##   <int>     <int>     <int>      <chr>    <int>      <dbl>
    ## 1     1        32         3          F       80 -1.5035369
    ## 2     2        28         2          F       20 -0.1836726
    ## 3     3        36         4          M       58 -0.6851989
    ## 4     4        28         1          F       30  1.9900760
    ## 5     5        34         3          F       14  0.4324725
    ## 6     6        30         3          F       40 -0.7900185
    ## 
    ## $`assets/data_2004`
    ## # A tibble: 6 × 6
    ##      Id Variable1 Other2004 Gender2004 Eggs2004   Spam2004
    ##   <int>     <int>     <int>      <chr>    <int>      <dbl>
    ## 1     1        32         3          F       80 -1.5035369
    ## 2     2        28         2          F       20 -0.1836726
    ## 3     3        36         4          M       58 -0.6851989
    ## 4     4        28         1          F       30  1.9900760
    ## 5     5        34         3          F       14  0.4324725
    ## 6     6        30         3          F       40 -0.7900185

The datasets we will work with all have the the same variables and the
same inviduals. We have datasets for the years 2000 to 2004. It would be
much better for analysis if we could have clean variable names and merge
every datasets together in a single, longitudinal dataset. In short,
what we need:

  - Have nice names for the columns.
  - Remove the year from the name of the columns and add a column
    containing the year.
  - Merge every dataset together.

This is to make the dataset tidy, as explained Wickham
([2014](#ref-wickham2014tidy)[b](#ref-wickham2014tidy)). Of course,
depending on your needs, you might need to add further operations, for
example creating new variables etc. For now, we are going to focus on
these three steps.

### 6.2.2 Treating the columns of your datasets

Let us take a look at the column names of the datasets:

``` sourceCode r
map(datasets, colnames)
```

    ## $`assets/data_2000`
    ## [1] "id"         "Variable1"  "other2000"  "gender2000" "eggs2000"  
    ## [6] "spam2000"  
    ## 
    ## $`assets/data_2001`
    ## [1] "id"         "VARIABLE1"  "other2001"  "Gender2001" "eggs2001"  
    ## [6] "spam2001"  
    ## 
    ## $`assets/data_2002`
    ## [1] "ID"         "variable1"  "Other2002"  "gender2002" "eggs2002"  
    ## [6] "Spam2002"  
    ## 
    ## $`assets/data_2003`
    ## [1] "id"         "variable1"  "other2003"  "gender2003" "EGGS2003"  
    ## [6] "spam2003"  
    ## 
    ## $`assets/data_2004`
    ## [1] "Id"         "Variable1"  "Other2004"  "Gender2004" "Eggs2004"  
    ## [6] "Spam2004"

This is very messy, we would need to have a function that would clean
all this mess and “normalize” these column names. Turns out that we’re
lucky, and there is exactly what we are looking for in the `janitor`
package. The function `janitor::clean_names()` does exactly this. Let’s
use it and see the output:

``` sourceCode r
library("janitor")

datasets <- map(datasets, clean_names)

map(datasets, colnames)
```

    ## $`assets/data_2000`
    ## [1] "id"         "variable1"  "other2000"  "gender2000" "eggs2000"  
    ## [6] "spam2000"  
    ## 
    ## $`assets/data_2001`
    ## [1] "id"         "variable1"  "other2001"  "gender2001" "eggs2001"  
    ## [6] "spam2001"  
    ## 
    ## $`assets/data_2002`
    ## [1] "id"         "variable1"  "other2002"  "gender2002" "eggs2002"  
    ## [6] "spam2002"  
    ## 
    ## $`assets/data_2003`
    ## [1] "id"         "variable1"  "other2003"  "gender2003" "eggs2003"  
    ## [6] "spam2003"  
    ## 
    ## $`assets/data_2004`
    ## [1] "id"         "variable1"  "other2004"  "gender2004" "eggs2004"  
    ## [6] "spam2004"

This is much better. If `clean_names()` didn’t exist, you would have to
have written your own function for this. This could have been a
complicated exercise, depending on how messy and heterogenous the
variable names would have been in your data. However `clean_names()`
does a great job, so there’s no need to reivent the wheel\!

Now we would like to remove the years from the column names and add a
column with the name of each dataset. Let us start by removing the years
from the column names by writing a function. For this function, a little
regular expression knowledge will not hurt. Here is what the function
looks like:

``` sourceCode r
#' Remove year strings from column names
#' @param list_of_datasets A list containing named datasets
#' @return A list of datasets with the supplied string prepended to the column names
#' @description This function removes year strings from column names, meaning that a column called
#' "eggs9000" gets renamed into "eggs"
#' @export
#' @examples
#' \dontrun{
#' #`list_of_data_sets` is a list containing named data sets
#' # For example, to access the first data set, called dataset_1 you would
#' # write
#' list_of_data_sets$dataset_1
#' remove_years_from_strings(list_of_data_sets)
#' }
remove_years_from_strings <- function(list_of_datasets){

  for_one_dataset <- function(dataset){
    # strsplit() accepts regular expressions, so it's easy to get rid of a number made up of
    # *exactly* 4 digits

    colnames(dataset) <- unlist(strsplit(colnames(dataset), "\\d{4}", perl = TRUE))
    return(dataset)
  }

  output <- purrr::map(list_of_datasets, for_one_dataset)

  return(output)
}
```

and here is the accompanying unit test:

``` sourceCode r
library("testthat")
library("prepareData")
library("readr")

data_sets <- list.files(pattern = "2001")

data_list <- read_list(data_sets, read_csv, col_types = cols())

test_that("Test remove years from srings",{
    data_list_result <- purr::map(data_list, janitor::clean_names)
    data_list_result <- remove_years_from_strings(data_list_result)
    expect <- c("id", "year_", "variable1", "other", "gender", "eggs", "spam")
    actual <- colnames(data_list_result[[1]])
    expect_equal(expect, actual)
})
```

For the unit test to work, I had to add the dataset for the year 2001 in
the `tests/testthat` directory. Again, this dataset does not have to be
the real dataset you will ultimately be working on. A mock dataset with
simulated data on 10 rows and with the same column names works exactly
the same\!

Let’s take a look at the output:

``` sourceCode r
datasets <- remove_years_from_strings(datasets)

map(datasets, colnames)
```

    ## $`assets/data_2000`
    ## [1] "id"        "variable1" "other"     "gender"    "eggs"      "spam"     
    ## 
    ## $`assets/data_2001`
    ## [1] "id"        "variable1" "other"     "gender"    "eggs"      "spam"     
    ## 
    ## $`assets/data_2002`
    ## [1] "id"        "variable1" "other"     "gender"    "eggs"      "spam"     
    ## 
    ## $`assets/data_2003`
    ## [1] "id"        "variable1" "other"     "gender"    "eggs"      "spam"     
    ## 
    ## $`assets/data_2004`
    ## [1] "id"        "variable1" "other"     "gender"    "eggs"      "spam"

This is starting to look like something\!

Now, since we removed the years from the column names, we need to add a
column containing the year to our datasets. And now to add the year
column:

``` sourceCode r
#' Adds the year column
#' @param list_of_datasets A list containing named datasets
#' @return A list of datasets with the year column
#' @description This function works by extracting the year string contained in
#' the data set name and appending a new column to the data set with the numeric
#' value of the year. This means that the data sets have to have a name of the
#' form data_set_2001 or data_2001_europe, etc
#' @export
#' @examples
#' \dontrun{
#' #`list_of_data_sets` is a list containing named data sets
#' # For example, to access the first data set, called dataset_1 you would
#' # write
#' list_of_data_sets$dataset_1
#' add_year_column(list_of_data_sets)
#' }
add_year_column <- function(list_of_datasets){

  for_one_dataset <- function(dataset, dataset_name){

    # Split the name of the dataset at the "_". The datasets must have a name of the
    # form "data_2000" (notice the underscore).
    name_year <- unlist(strsplit(dataset_name, "[_.]"))
    # Get the index of the string that contains digits
    index <- grep("\\d+", name_year)

    # Get the year
    year <- as.numeric(name_year[index])

    # Add it to the data set
    dataset$year <- year
    return(dataset)
  }

  output <- purrr::map2(list_of_datasets, names(list_of_datasets), for_one_dataset)
  return(output)
}
```

And its unit test:

``` sourceCode r
library("testthat")
library("prepareData")
library("readr")


data_sets <- list.files(pattern = "data")

data_list <- read_list(data_sets, read_csv, col_types = cols())

test_that("Test add year column",{
    data_list_result <- purrr::map(data_list, janitor::clean_names)
    data_list_result <- add_year_column(data_list_result)
    expect <- list(rep(2001, 1000), rep(2002, 1000))
    actual <- list(data_list_result[[1]]$year, data_list_result[[2]]$year)
    expect_equal(expect, actual)
})
```

This function does not work if the names of the datasets are not of the
form “data\_2000”. This means that this function should have either an
additional argument, where you specify the separator (for example “\_"
or “.” or even “-”) or fail if the name does not contain an “\_“. I like
the second solution better:

``` sourceCode r
#' Adds the year column
#' @param list_of_datasets A list containing named datasets
#' @return A list of datasets with the year column
#' @description This function works by extracting the year string contained in
#' the data set name and appending a new column to the data set with the numeric
#' value of the year. This means that the data sets have to have a name of the
#' form data_set_2001 or data_2001_europe, etc
#' @export
#' @examples
#' \dontrun{
#' #`list_of_data_sets` is a list containing named data sets
#' # For example, to access the first data set, called dataset_1 you would
#' # write
#' list_of_data_sets$dataset_1
#' add_year_column(list_of_data_sets)
#' }
add_year_column <- function(list_of_datasets){

  for_one_dataset <- function(dataset, dataset_name){

    if(!("_" %in% unlist(strsplit(dataset_name, split = "")))){
    stop("Make sure that your datasets are named like
         `data_2000.csv` or similar. The `_` between `data`
         and `2000` is what matters")}

    # Split the name of the dataset at the "_". The datasets must have a name of the
    # form "data_2000" (notice the underscore).
    name_year <- unlist(strsplit(dataset_name, split = "[_.]"))
    # Get the index of the string that contains digits
    index <- grep("\\d+", name_year)

    # Get the year
    year <- as.numeric(name_year[index])

    # Add it to the data set
    dataset$year <- year
    return(dataset)
  }

  output <- purrr::map2(list_of_datasets, names(list_of_datasets), for_one_dataset)
  return(output)
}
```

If you check the coverage of this function, you will see that the lines
that test if the datasets are correctly named do not get called. Let’s
add a unit test that does this, but first, we need to create *wrong*
datasets. Just copy the datasets you have in your tests folder, and
rename them to `wrongdata2001.csv` and `wrongdata2002.csv`. We expect
our function to stop with an error message if it tries anything on these
datasets:

``` sourceCode r
data_sets <- list.files(pattern = "wrong")

data_list <- read_list(data_sets, read_csv, col_types = cols())

test_that("Test add year column: wrong name",{
    data_list_result <- purrr::map(data_list, janitor::clean_names)
    expect_error(add_year_column(data_list_result))
})
```

Now have fully covered your function, and you also know when the
function breaks. With the informative error message, future you or your
coworkers will know how to correctly name the datasets. Let’s try
`add_year_column()` to see how it behaves on our data:

``` sourceCode r
datasets <- add_year_column(datasets)

map(datasets, head)
```

    ## $`assets/data_2000`
    ## # A tibble: 6 × 7
    ##      id variable1 other gender  eggs          spam  year
    ##   <int>     <int> <int>  <chr> <int>         <chr> <dbl>
    ## 1     1        32     3      F    80 -1.5035369157  2000
    ## 2     2        28     2      F    20 -0.1836726393  2000
    ## 3     3        36     4      M    58 -0.6851988608  2000
    ## 4     4        28     1      F    30  1.9900760191  2000
    ## 5     5        34     3      F    14  0.4324725273  2000
    ## 6     6        30     3      F    40   -0.79001853  2000
    ## 
    ## $`assets/data_2001`
    ## # A tibble: 6 × 7
    ##      id variable1 other gender  eggs       spam  year
    ##   <int>     <int> <int>  <chr> <int>      <dbl> <dbl>
    ## 1     1        32     3      F    80 -1.5035369  2001
    ## 2     2        28     2      F    20 -0.1836726  2001
    ## 3     3        36     4      M    58 -0.6851989  2001
    ## 4     4        28     1      F    30  1.9900760  2001
    ## 5     5        34     3      F    14  0.4324725  2001
    ## 6     6        30     3      F    40 -0.7900185  2001
    ## 
    ## $`assets/data_2002`
    ## # A tibble: 6 × 7
    ##      id variable1 other gender  eggs       spam  year
    ##   <int>     <int> <int>  <chr> <int>      <dbl> <dbl>
    ## 1     1        32     3      F    80 -1.5035369  2002
    ## 2     2        28     2      F    20 -0.1836726  2002
    ## 3     3        36     4      M    58 -0.6851989  2002
    ## 4     4        28     1      F    30  1.9900760  2002
    ## 5     5        34     3      F    14  0.4324725  2002
    ## 6     6        30     3      F    40 -0.7900185  2002
    ## 
    ## $`assets/data_2003`
    ## # A tibble: 6 × 7
    ##      id variable1 other gender  eggs       spam  year
    ##   <int>     <int> <int>  <chr> <int>      <dbl> <dbl>
    ## 1     1        32     3      F    80 -1.5035369  2003
    ## 2     2        28     2      F    20 -0.1836726  2003
    ## 3     3        36     4      M    58 -0.6851989  2003
    ## 4     4        28     1      F    30  1.9900760  2003
    ## 5     5        34     3      F    14  0.4324725  2003
    ## 6     6        30     3      F    40 -0.7900185  2003
    ## 
    ## $`assets/data_2004`
    ## # A tibble: 6 × 7
    ##      id variable1 other gender  eggs       spam  year
    ##   <int>     <int> <int>  <chr> <int>      <dbl> <dbl>
    ## 1     1        32     3      F    80 -1.5035369  2004
    ## 2     2        28     2      F    20 -0.1836726  2004
    ## 3     3        36     4      M    58 -0.6851989  2004
    ## 4     4        28     1      F    30  1.9900760  2004
    ## 5     5        34     3      F    14  0.4324725  2004
    ## 6     6        30     3      F    40 -0.7900185  2004

Just as expected\!

TBC…

### References

Wickham, Hadley. 2014b. “Tidy Data.” *Journal of Statistical Software*
59 (1): 1–23.
doi:[10.18637/jss.v059.i10](https://doi.org/10.18637/jss.v059.i10).

-----

3.  It stands for `Bruno Rodrigues' Tools`. I’m still working on
    releasing the package on Github, and maybe
    CRAN.[↩](putting-it-all-together-writing-a-package-to-work-on-data.html#fnref3)
