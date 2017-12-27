# Chapter 5 Programming with the `tidyverse`

Functions are very powerful because by using them, we avoid repetition.
This means that we must be able to write functions that allow the user
to abstract over certain things, such as columns names of datasets. So
for example, one would like to write a function that would look like
that:

``` sourceCode r
my_function(my_data, column)
```

and in this chapter we will learn how to do that using `dplyr` (version
0.70 or above).

I advise you to also read the “Programming with dplyr” vignette
[here](https://cran.r-project.org/web/packages/dplyr/vignettes/programming.html),
which explains with great detail the concept I will only skim in this
chapter\!

Consider the following code:

``` sourceCode r
data(mtcars)
simple_function = function(dataset, col_name){
  dataset %>%
    group_by(col_name) %>%
    summarise(mean_mpg = mean(mpg)) -> dataset
  return(dataset)
}
```

When you try to run this:

``` sourceCode r
simple_function(mtcars, "cyl")
```

This is the error you get:

``` 
 Error in grouped_df_impl(data, unname(vars), drop) :
  Column `col_name` is unknown
```

R is *literally* looking for a column called `col_name` in the `mtcars`
dataset. How to solve this issue and make R understand to not take “cyl”
literally as a string, but to interpret it?

One way is to use the `enquo()` function (or `quo()` if working
interactively), in conjunction with the `!!` operator introduced with
`dplyr` 0.7 (but actually part of the `rlang` package, which gets used
by `dplyr` seamlessly). First let’s look at the solution and then I’ll
explain how it works:

``` sourceCode r
library(dplyr)

simple_function = function(dataset, col_name){
  col_name = enquo(col_name)
  dataset = dataset %>%
    group_by(!!col_name) %>%
    summarise(mean_mpg = mean(mpg)) 
  return(dataset)
}


simple_function(mtcars, cyl)
```

    ## # A tibble: 3 x 2
    ##     cyl mean_mpg
    ##   <dbl>    <dbl>
    ## 1     4 26.66364
    ## 2     6 19.74286
    ## 3     8 15.10000

In the above example, I wanted the mean of `mpg` but first by grouping
by `cyl`. The `enquo()` to quote the input. This tells your function
that the variable `col_name` should be quoted. However then, `filter()`
(and the other `dplyr` functions) need to have an unquoted variable
name. So `!!()` does this and evaluates its argument.

If you want to use `filter()` with a value that the user has to provide,
you can also do that:

``` sourceCode r
simpleFunction = function(dataset, col_name, value){
  col_name = enquo(col_name)
  dataset = dataset %>%
    filter((!!col_name) == value) %>%
    summarise(mean_cyl = mean(cyl)) 
  return(dataset)
}


simpleFunction(mtcars, am, 1)
```

    ##   mean_cyl
    ## 1 5.076923

There is something that you must pay attention to in the above example.
Notice that I’ve written:

``` sourceCode r
filter((!!col_name) == value)
```

and not:

``` sourceCode r
filter(!!col_name == value)
```

I have enclosed `!!col_name` inside parentheses, because `==` has
precedence over `!!`.

Let’s make this function a bit more general. I hard-coded the variable
`cyl` inside the body of the function, but what if you need more
flexibility and let the user provide the variable to group by to?

``` sourceCode r
simpleFunction = function(dataset, group_col, mean_col, value){
  group_col = enquo(group_col)
  mean_col = enquo(mean_col)
  dataset = dataset %>%
    filter((!!group_col) == value) %>%
    summarise(mean((!!mean_col)))
  return(dataset)
}


simpleFunction(mtcars, am, cyl, 1)
```

    ##   mean((cyl))
    ## 1    5.076923

It is possible to set the name of the column in the output using `:=`
instead of `=`:

``` sourceCode r
simpleFunction = function(dataset, group_col, mean_col, value){
  group_col = enquo(group_col)
  mean_col = enquo(mean_col)
  mean_name = paste0("mean_", mean_col)[2]
  dataset %>%
    filter((!!group_col) == value) %>%
    summarise(!!mean_name := mean((!!mean_col))) -> dataset
  return(dataset)
}


simpleFunction(mtcars, am, cyl, 1)
```

    ##   mean_cyl
    ## 1 5.076923

To get the name of the column I added this line:

``` sourceCode r
mean_name = paste0("mean_", mean_col)[2]
```

To see what it does, try the following inside an R interpreter (remember
to us `quo()` instead of `enquo()` outside functions\!):

``` sourceCode r
paste0("mean_", quo(cyl))
```

    ## [1] "mean_~"   "mean_cyl"

`enquo()` quotes the input, and with `paste0()` it gets converted to a
string that can be used as a column name. However, the `~` is in the way
and the output of `paste0()` is a vector of two strings: the correct
name is contained in the second element, hence the `[2]`. There might be
a more elegant way of doing that, but for now this has been working well
for me.

It is also possible to write functions that take any amount of variables
the user wants:

``` sourceCode r
nice_function = function(dataset, ...){
    variables = quos(...)
    dataset %>% 
    summarise_at(vars(!!!variables), mean)
}

nice_function(mtcars, mpg, cyl)
```

    ##        mpg    cyl
    ## 1 20.09062 6.1875

You can even be more flexible, and let the user define the functions
that will be used by `summarised_at()`:

``` sourceCode r
nice_function = function(dataset, cols, funcs){
  dataset %>% 
    summarise_at(vars(!!!cols), funs(!!!funcs))
}


list_cols = quos(mpg, cyl)


list_funs = quos(mean, sd, sum)


nice_function(mtcars, list_cols, list_funs)
```

    ##   mpg_mean cyl_mean   mpg_sd   cyl_sd mpg_sum cyl_sum
    ## 1 20.09062   6.1875 6.026948 1.785922   642.9     198

In this last example however, the user has to provide a list of quoted
variables and functions.
