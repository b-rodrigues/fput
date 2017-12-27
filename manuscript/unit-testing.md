# Chapter 7 Unit testing

## 7.1 Introduction

Let’s take a look at [Wikipedia’s
definition](https://en.wikipedia.org/wiki/Unit_testing) of unit testing:

> In computer programming, unit testing is a software testing method by
> which individual units of source code, sets of one or more computer
> program modules together with associated control data, usage
> procedures, and operating procedures, are tested to determine whether
> they are fit for use. Intuitively, one can view a unit as the smallest
> testable part of an application. In procedural programming, a unit
> could be an entire module, but it is more commonly an individual
> function or procedure. In object-oriented programming, a unit is often
> an entire interface, such as a class, but could be an individual
> method. Unit tests are short code fragments created by programmers or
> occasionally by white box testers during the development process. It
> forms the basis for component testing.

So unit tests are small pieces of code that test your code. They’re
called *unit* tests, because they test the smallest unit composing your
code, in the case of functional programming, the smallest units are
functions. You’ve probably been testing your code *manually* since
you’ve started programming. For example, you would simply do something
like this:

``` sourceCode r
sqrt_newton(4, 1)
```

    ## [1] 2.00061

and check if the result is equal to `2` and stop there. Usually you
would probably write this in the console and then forget about it. If
you need to check again, you would write this small test again in the
console. But what if some of your functions have to work together with
other functions? Maybe changing something in these other functions will
indirectly break in other functions. You would have to retest everything
together again\! In this chapter you will learn the basics of unit
testing, which is simply writing these tests in a file, and running this
file each time you change your code. If all your unit tests still pass,
you can be more confident that your code works as intended.

Unit tests can also be useful to guide you as you program. Some
programmers do test-driven development. These programmers start by
writing the unit tests first, and then the code to make them pass. This
can be useful sometimes, if you don’t really know where you should start
but know what you want.

## 7.2 Unit testing with the `testthat` package

We are going to test the function we wrote in the previous chapter,
`sqrt_newton()`. The basic steps are:

1.  Write a file containing your tests
2.  Run the tests

It’s very simple\! You only need to install the `testthat` package for
this. In this section I’ll only show you how to write tests and try to
illustrate their usefulness. In the next section, we’ll see how we can
run the tests.

Below is the code that we are going to put in the file
`test_my_functions.R`:

``` sourceCode r
library("testthat")

test_that("Test sqrt_newton: positive numeric",{
              expected <- 2
              actual <- sqrt_newton(4, 1)
              expect_equal(expected, actual)
})
```

The syntax of the test is pretty straightforward. We start with a short
description of what the test is about, and then we define two variables:
the result we expect, and the actual result that is returned by the
function we wish to test. When we run this test (we’ll discuss running
tests in the next section), this is what we get:

    Error: Test failed: 'Test sqrt_newton: positive numeric'
    * `expected` not equal to `actual`.
    1/1 mismatches
    [1] 2 - 2 == -0.00061

This is because the value that `sqrt_newton()` returns is not exactly
equal to `2`. How to solve this? We could simply check if the difference
of the value expected and the value returned is smaller than `eps`
(which is actually how the function works):

``` sourceCode r
library("testthat")
```

    ## 
    ## Attaching package: 'testthat'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     matches

    ## The following objects are masked from 'package:magrittr':
    ## 
    ##     equals, is_less_than, not

    ## The following object is masked from 'package:purrr':
    ## 
    ##     is_null

``` sourceCode r
test_that("Test sqrt_newton: positive numeric",{
              eps <- 0.001
              expected <- 2
              actual <- sqrt_newton(4, 1, eps = eps)
              expect_lt(abs(expected - actual), eps)
})
```

There’s no visible output, meaning that the test passes. Don’t worry,
we’ll see how to run these tests in the next section, and we’ll get a
nice output confirming that tests did, indeed, pass.

I didn’t talk about the functions `expect_equal()` and `expect_lt()`,
but now is the moment. These functions are part of the `testthat`
package and these are what allow you to test your functions. There’s a
number of them that allow you to test for a variety of situations. Check
the documentation of `testthat` for more info. Let’s continue to write
more tests\!

``` sourceCode r
library("testthat")

test_that("Test sqrt_newton: negative numeric",{
              expect_error(sqrt_newton(-4, 1))
})
```

We would like our function to return an error message if the user tries
to get the square root of a negative number (let’s say we don’t want to
generalize our function to complex numbers). But what happens here is
that the function runs forever\! This is because we are using a while
loop whose condition is never fulfilled. This test basically allowed us
to find two problems with our function:

  - it doesn’t deal with negative numbers
  - the while loop may run forever if the condition is never fulfilled
    (for example if `eps` is too small

Let’s rewrite our function to take care of this, one problem at a time:

``` sourceCode r
sqrt_newton <- function(a, init, eps = 0.01){
    stopifnot(a >= 0)
    while(abs(init**2 - a) > eps){
        init <- 1/2 *(init + a/init)
    }
    return(init)
}
```

Now let’s run our test again:

``` sourceCode r
library("testthat")

test_that("Test sqrt_newton: negative numeric",{
              expect_error(sqrt_newton(-4, 1))
})
```

Again no output, so things are good. Now to the next issue: we need to
write a safeguard in the function to avoid having the while loop running
for too long. For example if you try to run this:

``` sourceCode r
sqrt_newton(49, 1E100000, 1E-100000)
```

You will see that it takes an awful lot of time\! Let’s limit the number
of iterations to 100.

``` sourceCode r
sqrt_newton <- function(a, init, eps = 0.01){
    stopifnot(a >= 0)
    i <- 1
    while(abs(init**2 - a) > eps){
        init <- 1/2 *(init + a/init)
        i <- i + 1
        if(i > 100) stop("Maximum number of iterations reached")
    }
    return(init)
}
```

Now when we try to run the following expression we get an error message:

``` sourceCode r
sqrt_newton(49, 1E100, 1E-100)
```

    Error in sqrt_newton(49, 1e+100, 1e-100) : 
      Maximum number of iterations reached

But wouldn’t it be better if the user could change the number of
iterations himself?

``` sourceCode r
sqrt_newton <- function(a, init, eps = 0.01, iter = 100){
    stopifnot(a >= 0)
    i <- 1
    while(abs(init**2 - a) > eps){
        init <- 1/2 *(init + a/init)
        i <- i + 1
        if(i > iter) stop("Maximum number of iterations reached")
    }
    return(init)
}
```

We can now write some more tests:

``` sourceCode r
library("testthat")

test_that("Test sqrt_newton: not enough iterations",{
              expect_error(sqrt_newton(4, 1E100, 1E-100, iter = 100))
})
```

## 7.3 Actually running your tests

One of the easiest ways to run your tests is when your developing a
package. We are going to see this in the next chapter, but for now,
let’s suppose that we have a folder called `my_project` with the code
inside of it. There’s a file called `my_functions.R` and another file
called `test_my_functions.R` which contain the functions you programmed
and the unit tests that go with it respectively.

The file `test_my_functions.R` contains the following source code:

    library("testthat")
    
    test_that("Test sqrt_newton: positive numeric",{
        eps <- 0.001
        expected <- 2
        actual <- sqrt_newton(4, 1, eps = eps)
        expect_lt(abs(expected - actual), eps)
    })
    
    test_that("Test sqrt_newton: negative numeric",{
        expect_error(sqrt_newton(-4, 1))
    })
    
    test_that("Test sqrt_newton: not enough iterations",{
        expect_error(sqrt_newton(4, 1E100, 1E-100, iter = 100))
    })

Then you simply run the following in the console:

``` sourceCode r
test_file("test_my_functions.R")
```

of course you have to make sure that you are in the correct working
directory. This can be tricky, and is one of the reasons why it’s easier
to run your tests when you’re developing a package.

This is the output we get:

    ...
    DONE ================================================================================

See the three dots on the first line? Each dot represents a test that
passed successfully. Let’s add a test that will not pass on purpose,
just to see what happens:

    test_that("Test sqrt_newton: wrong on purpose",{
        eps <- 0.001
        expected <- 12
        actual <- sqrt_newton(4, 1, eps = eps)
        expect_lt(abs(expected - actual), eps)
    })

This is the output we get now:

    ...1
    Failed ------------------------------------------------------------------------------
    1. Failure: Test sqrt_newton: wrong on purpose (@test_my_functions.R#22) ------------
    abs(expected - actual) is not strictly less than `eps`. Difference: 10
    
    
    DONE ================================================================================

You can then go back to the file that contains the tests and correct
them. If all your tests are in a separate folder, you can use the
function `test_dir()` to test all the functions in a given folder. The
files containing your tests should all start with the string `test`. You
could have a file called `run_tests.R` on the root of the directory and
this file could contain the following:

``` sourceCode r
library("testthat")

test_dir("tests")
```

You could then run your tests by running this file. You might also be
tempted to write a bash script on GNU/Linux distributions or on macOS:

    #!/bin/sh
    
    Rscript -e "testthat::test_that('/whole/path/to/your/tests')"

but you’ll probably only get burned because when you run this script, a
new R session is started which does not know anything about your
functions in your file `my_functions.R`. Managing the working directory
is quite a pain. This is why in the next chapter we are going to start
learning about packages and why writing our own packages to clean
datasets is the best possible way to write your code.

## 7.4 Wrap-up

  - Unit tests are a way of testing your code, and more specifically
    your functions.
  - The basic workflow is to write your code, write tests, and check if
    your tests pass.
  - You can also start with the tests and then write or modify your code
    to make them pass.
  - We didn’t talk about *coverage* yet. Are you sure that you test
    every line of your function? No you’re not. In the next chapter I’ll
    show you how can be sure to test each line of your function with the
    `covr` package.

## 7.5 Exercises

1.  Write unit tests for the functions you wrote in the previous
    chapter. Just play around a little bit, and get a feeling for unit
    tests.

[**](packages.html)
[**](putting-it-all-together-writing-a-package-to-work-on-data.html)
