# Chapter 1 Why this book?

This short book serves to show how functional programming and unit
testing can be useful for the task of data munging. This book is not an
in-depth guide to functional programming, nor unit testing with R. If
you want to have an in-depth understanding of the concepts presented in
these books, I can’t but recommend Wickham (2014a), Wickham (2015) and Wickham and Grolemund
(2016) enough. Here, I will only briefly present
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
was at the [University of Strasbourg](http://www.unistra.fr/index.php?id=accueil).
I’m not an R developer, and don’t have a CS background. Most, if not everything, that
I know about R is self-taught. I hope however that you will find this
book useful. You can [follow me on twitter](https://twitter.com/brodriguesco) or
check [my blog](http://brodrigues.co).

## 1.3 Thanks


Thanks to [Hans-Martin von Gaudecker](https://www.iame.uni-bonn.de/people/hm-gaudecker) for
introducing me to unit testing and writing elegant code. The PEP 8 style
guidelines will forever remain etched in my brain.

Finally I have to thank my wife for putting up with my endless rants
against people not using functional programming nor testing their code
(or worse, using proprietary software!).

## 1.4 License

This book is licensed under the GNU Free Documentation License, version
1.3. A copy of the license is available on the repo, or you can read it
[online](https://www.gnu.org/licenses/fdl-1.3.txt).
