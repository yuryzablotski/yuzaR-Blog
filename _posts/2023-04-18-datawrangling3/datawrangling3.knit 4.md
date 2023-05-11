---
title: "(in progress) Transform Your Data Like a Pro with {tidyr} and Say Goodbye to Messy Data!"
description: |
  Every data scientist dreams of creating beautiful visualizations, conducting complex modeling, and diving into machine learning methods. However, most of the time, messy data hinders our ability to do really cool stuff. Thus, tidying up the data is the key to unlocking your full potential. Unfortunately, reshaping data in Excel can be a tedious and error-prone task. Do you remember the time when you needed to quickly transform columns to rows or rows to columns, split or combine columns, or handle missing values? With the {tidyr} package, you'll be able to transform your data quickly, accurately, and efficiently, preparing yourself for the stuff that really matters ;) 
author:
  - name: Yury Zablotski
    url: https://yuzar-blog.netlify.app/
date: "May 09, 2023"
categories:
  - videos
  - statistics
  - data wrangling
  - R package reviews
preview: dplyr_3_thumbnail.png
output:
  distill::distill_article:
    self_contained: false
    toc: true
    toc_float: true
    toc_depth: 6
    code_download: true
bibliography: /Users/zablotski/Documents/library.bib
#csl: american-political-science-association.csl
biblio-style: apalike
link-citations: yes
linkcolor: blue
#draft: true
---






    
    “Happy families are all alike; every unhappy family is unhappy in its own way.” 
    – Leo Tolstoy

    “Tidy datasets are all alike, but every messy dataset is messy in its own way.” 
    – Hadley Wickham


![](tidy-1.png)

This picture shows three simple rules which make a dataset tidy[^1]:

[^1]: Amazing and Free Book by Garrett Grolemund and Hadley Wickham: [“R for Data Science”](https://r4ds.had.co.nz/)

1. Each column is a variable
2. Each row is an observation
3. Each cell is a single value

But it’s surprising, how rare these three rules are followed.
    

# This post as a video

To maximize the effect of this post you should definitely work through [Data Wrangling Vol. 1](https://yuzar-blog.netlify.app/posts/2023-01-31-datawrangling1/) and [Data Wrangling Vol. 2](https://yuzar-blog.netlify.app/posts/2023-02-07-datawrangling2/) before. And I also recommend to watch a video first, because I highlight things I talk about. It's ca. 13 minutes long. 

<div class="layout-chunk" data-layout="l-body">

```{=html}
<div class="vembedr">
<div>
<iframe src="https://www.youtube.com/embed/DotnsqCoa7I" width="533" height="300" frameborder="0" allowfullscreen="" data-external="1"></iframe>
</div>
</div>
```

</div>



<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span><span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='op'>)</span></span></code></pre></div>

</div>





# Reshape data: make then wider or longer

<div class="layout-chunk" data-layout="l-body">
![](datawrangling3_files/figure-html5/unnamed-chunk-3-1.gif)<!-- -->

</div>


## pivot_wider & spread

Imagine the situation where various types of information are combined into one column, but you need to "spread" them out into separate columns, because the information they convey cannot coexist, like in columns `type` and `count`. The "cases" and "population" values have nothing in common and therefore, don't belong in the same column. So, we have to broaden our table by taking the column "names from" the "type" and the "values from" the "count" column. Simply put, **we need to make our table wider**. And while it's easy to manually copy and paste the data for two categories, you wouldn't want to do that with 100 categories.


![](tidy-8.png)

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span><span class='va'>table2</span> <span class='op'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='fu'><a href='https://tidyr.tidyverse.org/reference/pivot_wider.html'>pivot_wider</a></span><span class='op'>(</span>names_from <span class='op'>=</span> <span class='va'>type</span>, values_from <span class='op'>=</span> <span class='va'>count</span><span class='op'>)</span></span></code></pre></div>

```
# A tibble: 6 × 4
  country      year  cases population
  <chr>       <dbl>  <dbl>      <dbl>
1 Afghanistan  1999    745   19987071
2 Afghanistan  2000   2666   20595360
3 Brazil       1999  37737  172006362
4 Brazil       2000  80488  174504898
5 China        1999 212258 1272915272
6 China        2000 213766 1280428583
```

</div>



A "pivot_wider" is amazing, but if you work with real-world data (which is often dirty), you'll certainly encounter two common problems. The first one is that "pivot_wider" will eventually produce missing values. For this case, "pivot_wider" has an useful argument that fills in the missing values.

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span><span class='va'>x</span> <span class='op'>&lt;-</span> <span class='fu'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='op'>(</span>A <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='st'>"a"</span>, <span class='st'>"b"</span>, <span class='st'>"c"</span><span class='op'>)</span>, B <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='st'>"one"</span>, <span class='st'>"two"</span>, <span class='st'>"three"</span><span class='op'>)</span>, C <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='fl'>1</span>, <span class='fl'>2</span>, <span class='fl'>3</span><span class='op'>)</span> <span class='op'>)</span></span>
<span></span>
<span><span class='va'>x</span> <span class='op'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='fu'><a href='https://tidyr.tidyverse.org/reference/pivot_wider.html'>pivot_wider</a></span><span class='op'>(</span>names_from <span class='op'>=</span> <span class='va'>B</span>, values_from <span class='op'>=</span> <span class='va'>C</span><span class='op'>)</span></span></code></pre></div>

```
# A tibble: 3 × 4
  A       one   two three
  <chr> <dbl> <dbl> <dbl>
1 a         1    NA    NA
2 b        NA     2    NA
3 c        NA    NA     3
```

<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span><span class='va'>x</span> <span class='op'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='fu'><a href='https://tidyr.tidyverse.org/reference/pivot_wider.html'>pivot_wider</a></span><span class='op'>(</span>names_from <span class='op'>=</span> <span class='va'>B</span>, values_from <span class='op'>=</span> <span class='va'>C</span>, values_fill <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='op'>(</span>C <span class='op'>=</span> <span class='fl'>0</span><span class='op'>)</span><span class='op'>)</span></span></code></pre></div>

```
# A tibble: 3 × 4
  A       one   two three
  <chr> <dbl> <dbl> <dbl>
1 a         1     0     0
2 b         0     2     0
3 c         0     0     3
```

</div>


The second problem is that widening a table can lead to several values being put into one cell, resulting in a list of values that violates the third principle of tidy data - each cell is a single measurement. 

![](tidy_data.jpg)

To address this problem, you can utilize the "values_fn" argument, which enables you to fill this cell with an aggregation function such as "mean". If there are still missing values after aggregation (because there was nothing to aggregate), you can fill them with a value of your choice using the "values_fill" argument.

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span><span class='va'>mtcars</span> <span class='op'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='fu'><a href='https://tidyr.tidyverse.org/reference/pivot_wider.html'>pivot_wider</a></span><span class='op'>(</span></span>
<span>    id_cols <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='va'>vs</span>, <span class='va'>am</span><span class='op'>)</span>, </span>
<span>    names_from <span class='op'>=</span> <span class='va'>cyl</span>, </span>
<span>    values_from <span class='op'>=</span> <span class='va'>mpg</span><span class='op'>)</span></span></code></pre></div>

```
# A tibble: 4 × 5
     vs    am `6`       `4`       `8`       
  <dbl> <dbl> <list>    <list>    <list>    
1     0     1 <dbl [3]> <dbl [1]> <dbl [2]> 
2     1     1 <NULL>    <dbl [7]> <NULL>    
3     1     0 <dbl [4]> <dbl [3]> <NULL>    
4     0     0 <NULL>    <NULL>    <dbl [12]>
```

<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span><span class='va'>mtcars</span> <span class='op'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='fu'><a href='https://tidyr.tidyverse.org/reference/pivot_wider.html'>pivot_wider</a></span><span class='op'>(</span></span>
<span>    id_cols <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='va'>am</span>, <span class='va'>vs</span><span class='op'>)</span>, </span>
<span>    names_from <span class='op'>=</span> <span class='va'>cyl</span>, </span>
<span>    values_from <span class='op'>=</span> <span class='va'>mpg</span>, </span>
<span>    values_fn <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='op'>(</span>mpg <span class='op'>=</span> <span class='va'>mean</span><span class='op'>)</span>,</span>
<span>    values_fill <span class='op'>=</span> <span class='fu'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='op'>(</span>mpg <span class='op'>=</span> <span class='fl'>9999</span><span class='op'>)</span> <span class='op'>)</span></span></code></pre></div>

```
# A tibble: 4 × 5
     am    vs    `6`    `4`    `8`
  <dbl> <dbl>  <dbl>  <dbl>  <dbl>
1     1     0   20.6   26     15.4
2     1     1 9999     28.4 9999  
3     0     1   19.1   22.9 9999  
4     0     0 9999   9999     15.0
```

</div>


A "pivot_wider" is the more intuitive next-generation version of the "spread" command. However, "spread" is still commonly used, so it remains in the package. Knowing how "spread" works can help in understanding older code.

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span><span class='va'>table2</span> <span class='op'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='fu'><a href='https://tidyr.tidyverse.org/reference/spread.html'>spread</a></span><span class='op'>(</span>key <span class='op'>=</span> <span class='va'>type</span>, value <span class='op'>=</span> <span class='va'>count</span><span class='op'>)</span> </span></code></pre></div>

```
# A tibble: 6 × 4
  country      year  cases population
  <chr>       <dbl>  <dbl>      <dbl>
1 Afghanistan  1999    745   19987071
2 Afghanistan  2000   2666   20595360
3 Brazil       1999  37737  172006362
4 Brazil       2000  80488  174504898
5 China        1999 212258 1272915272
6 China        2000 213766 1280428583
```

</div>

```{.r .distill-force-highlighting-css}
```
