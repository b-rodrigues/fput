===============================================================
Functional programming and unit testing for data munging with R
===============================================================

:Author: Bruno Rodrigues
:Date:   2016-12-23

.. raw:: html

   <div
   class="book without-animation with-summary font-size-2 font-family-1"
   data-basepath=".">

.. raw:: html

   <div class="book-summary">

-  `Functional programming and unit testing for data munging <./>`__
-  
-  `**\ **1** Why this book? <index.html>`__

   -  `**\ **1.1** Motivation <index.html#motivation>`__
   -  `**\ **1.2** Who am I? <index.html#who-am-i>`__
   -  `**\ **1.3** Thanks <index.html#thanks>`__
   -  `**\ **1.4** License <index.html#license>`__

-  `**\ **2** Introduction <intro.html>`__

   -  `**\ **2.1** Getting R <intro.html#get_r>`__
   -  `**\ **2.2** A short overview of functional
      programming <intro.html#fprog_overview>`__
   -  `**\ **2.3** A short overview of unit
      testing <intro.html#unit_overview>`__

-  `**\ **3** Functional Programming <fprog.html>`__

   -  `**\ **3.1** Introduction <fprog.html#fprog_intro>`__

      -  `**\ **3.1.1** Function
         definitions <fprog.html#function-definitions>`__
      -  `**\ **3.1.2** Properties of
         functions <fprog.html#properties-of-functions>`__

   -  `**\ **3.2** Mapping and Reducing: the *base*
      way <fprog.html#mapping-and-reducing-the-base-way>`__

      -  `**\ **3.2.1** Mapping with ``Map()`` and the ``*apply()``
         family of
         functions <fprog.html#mapping-with-map-and-the-apply-family-of-functions>`__
      -  `**\ **3.2.2** ``Reduce()`` <fprog.html#reduce>`__

   -  `**\ **3.3** Mapping and Reducing: the ``purrr``
      way <fprog.html#mapping-and-reducing-the-purrr-way>`__

      -  `**\ **3.3.1** The ``map*()`` family of
         functions <fprog.html#the-map-family-of-functions>`__
      -  `**\ **3.3.2** Reducing with
         ``purrr`` <fprog.html#reducing-with-purrr>`__
      -  `**\ **3.3.3** Other useful functions from
         ``purrr`` <fprog.html#other-useful-functions-from-purrr>`__

   -  `**\ **3.4** Anonymous
      functions <fprog.html#anonymous-functions>`__
   -  `**\ **3.5** Wrap-up <fprog.html#wrap-up>`__
   -  `**\ **3.6** Exercises <fprog.html#exercises>`__

-  `**\ **4** Unit testing <unit-testing.html>`__

   -  `**\ **4.1** Introduction <unit-testing.html#introduction>`__
   -  `**\ **4.2** Unit testing with the ``testthat``
      package <unit-testing.html#unit-testing-with-the-testthat-package>`__
   -  `**\ **4.3** Actually running your
      tests <unit-testing.html#actually-running-your-tests>`__
   -  `**\ **4.4** Wrap-up <unit-testing.html#wrap-up-1>`__
   -  `**\ **4.5** Exercises <unit-testing.html#exercises-1>`__

-  `**\ **5** Packages <packages.html>`__

   -  `**\ **5.1** Why you need your own packages in your
      life <packages.html#why-you-need-your-own-packages-in-your-life>`__
   -  `**\ **5.2** R packages: the
      basics <packages.html#r-packages-the-basics>`__
   -  `**\ **5.3** Writing documentation for your
      functions <packages.html#writing-documentation-for-your-functions>`__
   -  `**\ **5.4** Unit test your
      package <packages.html#unit-test-your-package>`__
   -  `**\ **5.5** Checking the coverage of your unit tests with
      ``covr`` <packages.html#checking-the-coverage-of-your-unit-tests-with-covr>`__
   -  `**\ **5.6** Wrap-up <packages.html#wrap-up-2>`__

-  `**\ **6** Putting it all together: writing a package to work on
   data <putting-it-all-together-writing-a-package-to-work-on-data.html>`__

   -  `**\ **6.1** Getting the
      data <putting-it-all-together-writing-a-package-to-work-on-data.html#getting-the-data>`__
   -  `**\ **6.2** Your first data munging package:
      ``prepareData`` <putting-it-all-together-writing-a-package-to-work-on-data.html#your-first-data-munging-package-preparedata>`__

      -  `**\ **6.2.1** Reading a lot of datasets at
         once <putting-it-all-together-writing-a-package-to-work-on-data.html#reading-a-lot-of-datasets-at-once>`__
      -  `**\ **6.2.2** Treating the columns of your
         datasets <putting-it-all-together-writing-a-package-to-work-on-data.html#treating-the-columns-of-your-datasets>`__

-  `**\ References <references.html>`__
-  
-  `Published with bookdown <https://github.com/rstudio/bookdown>`__

.. raw:: html

   </div>

.. raw:: html

   <div class="book-body">

.. raw:: html

   <div class="body-inner">

.. raw:: html

   <div class="book-header" role="navigation">

.. rubric:: **\ `Functional programming and unit testing for data
   munging with R <./>`__
   :name: functional-programming-and-unit-testing-for-data-munging-with-r

.. raw:: html

   </div>

.. raw:: html

   <div class="page-wrapper" tabindex="-1" role="main">

.. raw:: html

   <div class="page-inner">

.. raw:: html

   <div id="section-" class="section normal">

.. raw:: html

   <div id="intro" class="section level1">

.. rubric:: Chapter 2 Introduction
   :name: chapter-2-introduction

.. raw:: html

   <div id="get_r" class="section level2">

.. rubric:: 2.1 Getting R
   :name: getting-r

Since I’m assuming you have an intermediate level in R, you already
should have R and Rstudio installed on your machine. However, you may
lack some of the following packages that are needed to follow the
examples in this book:

-  covr: to check the coverage of your unit tests
-  dplyr: to clean, transform, prepare data
-  lazyeval: for lazy evaluation
-  lubridate: makes working with dates easier
-  memoise: makes your function remember intermediate results
-  purrr: extends R’s functional programming capabilities
-  readr: provides alternative functions to ``read.csv()`` and such
-  roxygen2: creates documentation files from comments
-  stringr: makes working with characters easier
-  testthat: the library we are going to use for unit testing
-  tibble: provides a nice, cleaner alternative to ``data.frame``
-  tidyr: works hand in hand with ``dplyr``

If you’re missing some or all of these packages, install them. You’ll
notice that most, if not all, of these packages were authored or
co-authored by Hadley Wickham, currently chief scientist at Rstudio, so
you can install most of these packages by installing a single package
called ``tidyverse``:

.. raw:: html

   <div class="sourceCode">

.. code:: r

    install.packages("tidyverse")

.. raw:: html

   </div>

The ``tidyverse`` package installs some other useful packages that we
will not use, but you should check them out anyways!

.. raw:: html

   </div>

.. raw:: html

   <div id="fprog_overview" class="section level2">

.. rubric:: 2.2 A short overview of functional programming
   :name: a-short-overview-of-functional-programming

What is functional programming? Wikipedia tells us the following:

    In computer science, functional programming is a programming
    paradigm —a style of building the structure and elements of computer
    programs— that treats computation as the evaluation of mathematical
    functions and avoids changing state and mutable data. It is a
    declarative programming paradigm, which means programming is done
    with expressions or declarations instead of statements. In
    functional code, the output value of a function depends only on the
    arguments that are input to the function, so calling a function f
    twice with the same value for an argument x will produce the same
    result f(x) each time. Eliminating side effects, i.e. changes in
    state that do not depend on the function inputs, can make it much
    easier to understand and predict the behavior of a program, which is
    one of the key motivations for the development of functional
    programming.

That’s the first paragraph of the `Wikipedia
page <https://en.wikipedia.org/wiki/Functional_programming>`__ and it’s
quite heavy already!

So let’s try to decrypt what is said in this paragraph. Functional
programming is a programming paradigm. You may have heard of object
oriented programming, or imperative programming before. You actually
probably program in an imperative way without knowing it. Imperative
programming is usually how programming is taught at universities, and
most people then keep on programming in this way, especially in applied
sciences like applied econometrics. Usually, people that write code in
an imperative way tend to write very long scripts that change the state
of the program gradually. In the case of a statistician (I will use the
word ‘statistician’ to mean any person that works with datasets. Be it
an economist, biologist, data scientist, etc.) this usually means
loading a dataset, doing whatever has to be done by writing each
instruction in a file, then running everything. Sometimes this
statistician has to save temporary datasets, and then write other
scripts that do a series of computations on these temporary datasets and
then not forget to delete said temporary datasets. Functional
programming is different, in that you write functions that do one single
task and then call these functions successively on your data set. These
functions can be used for any other project, can be easily documented
and tested (more on this below). Because each function performs a single
task and is well documented, it is also easier to understand what the
program is supposed to do. Comments in a thousand-lines file are
actually not that much useful. The file is so long, that even when
commented you simply cannot make any sense of what is going on. It is
also easier to automate tasks and navigate through the code. Since one
function does one single task, if you’re looking for the line of code
that creates variable ``X``, just look in the function called
``create_var_X()``, instead of ``CTRL-F``\ ing around. 1000 lines long
script. You can also be sure that your functions do not do anything else
(basically, this is what is meant by “eliminating side effects”) than
the single task you gave them. You can *trust your functions*.

.. raw:: html

   </div>

.. raw:: html

   <div id="unit_overview" class="section level2">

.. rubric:: 2.3 A short overview of unit testing
   :name: a-short-overview-of-unit-testing

At the end of the last section I wrote that you can *trust your
functions*. Is that true though? Functional programming can make your
life easier, but it does not prevent you from introducing bugs in your
code. However, what functional programming makes easily possible, is to
very easily and effectively test your code thanks to unit testing. You
probably already test your code, by hand. You write some loop that is
supposed to sum the first 10 integers and then you try it out and check
if, indeed, your loop returns 55. Because this is the correct result,
you save your work and continue programming something else, and so on.
Unit testing is this, but in an automated way. Instead of just trying
things out in the interpreter, you write unit tests. You write code that
actually checks your functions. You save this unit tests somewhere, and
then re-run them whenever you make changes to your code. Even if you
don’t change some parts of your code, you re-run every unit test.
Because you actually never know what may happen. Maybe changing a single
line in one of your functions introduced some unforeseen consequences
that breaks functionality some place else. When you change code, and
*all* your unit tests still pass, then you can be confident that your
code is correct (actually, don’t be too confident, because maybe you
didn’t write enough unit tests to cover every case. But we will see how
we can be sure there is enough *coverage*).

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>

.. raw:: html

   </div>

`** <index.html>`__ `** <fprog.html>`__

.. raw:: html

   </div>

.. raw:: html

   </div>
