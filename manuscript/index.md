  - [Functional programming and unit testing for data munging](./)

  - 
  - [****1** Why this book?](index.html)
    
      - [****1.1** Motivation](index.html#motivation)
      - [****1.2** Who am I?](index.html#who-am-i)
      - [****1.3** Thanks](index.html#thanks)
      - [****1.4** License](index.html#license)

  - [****2** Introduction](intro.html)
    
      - [****2.1** Getting R](intro.html#get_r)
      - [****2.2** A short overview of functional
        programming](intro.html#fprog_overview)
      - [****2.3** A short overview of unit
        testing](intro.html#unit_overview)

  - [****3** Functional Programming](fprog.html)
    
      - [****3.1** Introduction](fprog.html#fprog_intro)
          - [****3.1.1** Function
            definitions](fprog.html#function-definitions)
          - [****3.1.2** Properties of
            functions](fprog.html#properties-of-functions)
      - [****3.2** Mapping and Reducing: the *base*
        way](fprog.html#mapping-and-reducing-the-base-way)
          - [****3.2.1** Mapping with `Map()` and the `*apply()` family
            of
            functions](fprog.html#mapping-with-map-and-the-apply-family-of-functions)
          - [****3.2.2** `Reduce()`](fprog.html#reduce)
      - [****3.3** Mapping and Reducing: the `purrr`
        way](fprog.html#mapping-and-reducing-the-purrr-way)
          - [****3.3.1** The `map*()` family of
            functions](fprog.html#the-map-family-of-functions)
          - [****3.3.2** Reducing with
            `purrr`](fprog.html#reducing-with-purrr)
          - [****3.3.3** Other useful functions from
            `purrr`](fprog.html#other-useful-functions-from-purrr)
      - [****3.4** Anonymous functions](fprog.html#anonymous-functions)
      - [****3.5** Wrap-up](fprog.html#wrap-up)
      - [****3.6** Exercises](fprog.html#exercises)

  - [****4** Unit testing](unit-testing.html)
    
      - [****4.1** Introduction](unit-testing.html#introduction)
      - [****4.2** Unit testing with the `testthat`
        package](unit-testing.html#unit-testing-with-the-testthat-package)
      - [****4.3** Actually running your
        tests](unit-testing.html#actually-running-your-tests)
      - [****4.4** Wrap-up](unit-testing.html#wrap-up-1)
      - [****4.5** Exercises](unit-testing.html#exercises-1)

  - [****5** Packages](packages.html)
    
      - [****5.1** Why you need your own packages in your
        life](packages.html#why-you-need-your-own-packages-in-your-life)
      - [****5.2** R packages: the
        basics](packages.html#r-packages-the-basics)
      - [****5.3** Writing documentation for your
        functions](packages.html#writing-documentation-for-your-functions)
      - [****5.4** Unit test your
        package](packages.html#unit-test-your-package)
      - [****5.5** Checking the coverage of your unit tests with
        `covr`](packages.html#checking-the-coverage-of-your-unit-tests-with-covr)
      - [****5.6** Wrap-up](packages.html#wrap-up-2)

  - [****6** Putting it all together: writing a package to work on
    data](putting-it-all-together-writing-a-package-to-work-on-data.html)
    
      - [****6.1** Getting the
        data](putting-it-all-together-writing-a-package-to-work-on-data.html#getting-the-data)
      - [****6.2** Your first data munging package:
        `prepareData`](putting-it-all-together-writing-a-package-to-work-on-data.html#your-first-data-munging-package-preparedata)
          - [****6.2.1** Reading a lot of datasets at
            once](putting-it-all-together-writing-a-package-to-work-on-data.html#reading-a-lot-of-datasets-at-once)
          - [****6.2.2** Treating the columns of your
            datasets](putting-it-all-together-writing-a-package-to-work-on-data.html#treating-the-columns-of-your-datasets)

  - [**References](references.html)

  - 
  - [Published with
bookdown](https://github.com/rstudio/bookdown)

# **[Functional programming and unit testing for data munging with R](./)

#### *Bruno Rodrigues*

#### *2016-12-23*

# Chapter 1 Why this book?

This short book serves to show how functional programming and unit
testing can be useful for the task of data munging. This book is not an
in-depth guide to functional programming, nor unit testing with R. If
you want to have an in-depth understanding of the concepts presented in
these books, I can’t but recommend Wickham
([2014](#ref-wickham2014)[a](#ref-wickham2014)), Wickham
([2015](#ref-wickham2015)) and Wickham and Grolemund
([2016](#ref-wickham2016)) enough. Here, I will only briefly present
functional programming, unit testing and building your own R packages.
Just enough to get you (hopefully) interested and going.

This book is not an introduction to R either. I will assume that you
have intermediate knowledge of R.

## 1.1 Motivation

Functional programming has very nice features that make working on data
sets much more pleasant. It is common that you have to repeat the same
instructions over and over again for different data sets that look very
similar (for example, same, or similar column names). Of course, it is
possible to loop over these data sets and repeat a set of instructions
that change these data sets. However, we will see why a functional
programming approach is to be preferred.

Unit testing then allows you to make sure that the functions you want to
apply to your data sets actually do what you really want them to do.
Knowing and applying these two concepts together will make you hopefully
a better data analyst. Then we will learn to develop our own packages;
not with the goal of publishing them in CRAN, but with the goal of
making programming more streamlined.

## 1.2 Who am I?

I use R daily at my current job, and discovered R some years ago while I
was at the [University of
Strasbourg](http://www.unistra.fr/index.php?id=accueil). I’m not an R
developer, and don’t have a CS background. Most, if not everything, that
I know about R is self-taught. I hope however that you will find this
book useful. You can [follow me on
twitter](https://twitter.com/brodriguesco) or check [my
blog](http://brodrigues.co).

## 1.3 Thanks

I’d like to thank [Ross Ihaka](https://www.stat.auckland.ac.nz/~ihaka/)
and [Robert
Gentleman](https://en.wikipedia.org/wiki/Robert_Gentleman_\(statistician\))
for developing the R programming language. Many thanks to [Hadley
Wickham](http://hadley.nz/) for all the wonderful packages he developed
that make R much more pleasant to use. Thanks to [Yihui
Yie](http://yihui.name/) for `bookdown` without which this book would
not exist (at least not in this very nice format).

Thanks to [Hans-Martin von
Gaudecker](https://www.iame.uni-bonn.de/people/hm-gaudecker) for
introducing me to unit testing and writing elegant code. The PEP 8 style
guidelines will forever remain etched in my brain.

Finally I have to thank my wife for putting up with my endless rants
against people not using functional programming nor testing their code
(or worse, using proprietary software\!).

## 1.4 License

This book is licensed under the GNU Free Documentation License, version
1.3. A copy of the license is available on the repo, or you can read it
[online](https://www.gnu.org/licenses/fdl-1.3.txt).

### References

Wickham, Hadley. 2014a. *Advanced R*. CRC Press.

Wickham, Hadley. 2015. *R Packages*. 1st ed. O’Reilly.
<http://r-pkgs.had.co.nz/>.

Wickham, Hadley, and Garrett Grolemund. 2016. *R for Data Science*. 1st
ed. O’Reilly. <http://r4ds.had.co.nz/>.

[**](intro.html)
