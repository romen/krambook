%%% markdown %%% `markdown` %%%
%%% kramdown %%% [`kramdown`](http://kramdown.rubyforge.org) %%%
LLL xelatex LLL \XeLaTeX LLL XeLaTeX HTML
LLL xelatex_ LLL \XeLaTeX{} LLL XeLaTeX  HTML
LLL latex LLL \LaTeX LLL LaTeX HTML
LLL latex_ LLL \LaTeX{} LLL LaTeX  HTML
LLL tex LLL \TeX LLL TeX HTML
LLL tex_ LLL \TeX{} LLL TeX  HTML

# Introduction

## What is this project?

This project intends to provide you a cool way to write a book.
You write your book using your editor of choice using a %markdown syntax. 
The book can then be generated as PDF using %xelatex or to an [HTML website]().

You can see examples of standard end result here:

- [PDF](krambook.pdf)
- [HTML](http://yannesposito.com/krambook)

## Why this project?


### Markdown is easier to read than %latex

The best typesetting system I know is [%latex](http://latex-project.org).
Unfortunately %latex was created a long time ago and its syntax is full of backslashes. Here is an example of a standard minimal %latex document:

    
    \documenttype{article}
    \usepackage[utf-8]{inputenc}
    \usepackage{fontenc}
    \usepackage{amsmath}
    
    ... % This is the ritual header
    
    \begin{document} % ---- end of the preamble
    \section{First section}
    I begin by making a list of bullet points:
    \begin{itemize}
    \item the first point is 
        \LaTeX is a bit verbose
    \item the second point is 
        \Latex has \textem{more} \textbackslash{} than Markdown
    \item I believe you understood now.
    \end{itemize}
    \end{document}

Now a markdown file to render with the same meaning:

    First section
    =============

    I begin by making a list of bullet points:
    
    - the first point is LaTeX is a bit verbose
    - the second point is LaTeX has _more_ \ than Markdown
    - I believe you understood now

The HTML end result using the markdown will be:


> First section
> =============
> 
> I begin by making a list of bullet points:
> 
> - the first point is %latex is a bit verbose
> - the second point is %latex has _more_ \ than Markdown
> - I believe you understood now

Then I believe I don't have to convince more you that the markdown syntax is more natural than the %latex one.

### Markdown does not scale

%latex has many incredible properties that makes it scalable even for very long document.
On the other hand Markdown wasn't created for this purpose.
Markdown was done to provide a standard syntax to transform some text file into HTML.
Markdown lack many features that many other project have added to it.
One of this project is [Kramdown]().
There is many other project that expanded the abilities of Markdown.

But I believe not any of these project is scalable because the power of these language is _stricly_ inferior to the power of the TeX language.
In fact TeX is Turing complete -- considering we have the ability to make many compilations until reaching a fixed point.

How can %latex be Turing complete?
Simply with the power of provided by _macros_. 
In %latex you can declare macros like this:

    \newcommand{\un}{\sum_{n=0}^\infty u_n}

And each time you type:

    Here is a formula $\un = \pi$

It will be equivalent to:

    Here is a formula $\sum_{n=0}^\infty u_n = \pi$

Imagine a thesis where this formula is present a hundred times and you begin to understand why macros are a necessity for long documents.
But in %latex you could also declare macros with parameters and that use other declared macros:

    \newcommand{\ratlang}[2]{\mathcal{S}_{#1}^{\mathrm{rat}}(#2)}
    \newcommand{\sr}[2]{\ratlang{\mathbb{R}}(\Sigma)}
    ...
    Let us denote $\sr$ the class of rationnal 
    stochastic language over $\mathbb{R}$ with alphabet $\Sigma$. 

Now you see the power of %latex.

There is also another thing that make %latex scalable. You can include other source files. This make it easy to separate work and also to work with many other people.

Another good point with %latex and markdown is that you write only in text file and you can then version these file using `git` for example.

The purposes of this project are 

- Handle long documents by:
  - adding macros to kramdown
  - working with many small and versionnable text files
- generate high-quality PDF _and_ HTML documents.

For now, the power of this superset of kramdown syntax is _not_ Turing complete.
You can declare macros, but without any parameters and you cannot use already declared macros inside other macros declaration.
But this simple addition to markdown is already powerful enough for most of usage.

