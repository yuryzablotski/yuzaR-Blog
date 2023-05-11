---
title: "(in progress) {dplyr} on steroids: 20+ Expert Data Wrangling Techniques!"
description: |
  Reshaping data in Excel is painful and prone to mistakes. Just remember the time where you needed to quickly (1) turn columns to rows or rows to columns, (2) unite or separate columns
  
    **80% of work with data is data pre-processing**: cleaning, transforming and wrangling. In this post you'll learn how to (1) combine tables, (2) reformat tables by turning columns to rows or rows to columns, (3) find implicit missing values and complete the table by filling them out, (4) join tables to reduce duplicates, (5) unite and separate them and finally (6) how to manipulate values inside of the table in an easy way. But most importantly, it will prepare your data for a really cool stuff, like visualisations, models and machine learning algorithms. `tidyr` and `dplyr` packages which are both part of `tidyverse` will help with that. And after mastering my **Data Wrangling Trilogy**, you'll be able to manipulate data (in *R*) in 95% of the cases. 
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





# This post as a video

I recommend to watch a video first, because I highlight things I talk about. It's ca. ... minutes long.

<div class="layout-chunk" data-layout="l-body">

```{=html}
<div class="vembedr">
<div>
<iframe src="https://www.youtube.com/embed/" width="533" height="300" frameborder="0" allowfullscreen="" data-external="1"></iframe>
</div>
</div>
```

</div>



<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span><span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='op'>)</span></span></code></pre></div>

</div>




Most of this article, especially pictures, code and quotes below, stem from [“R for Data Science”](https://r4ds.had.co.nz/) book by Garrett Grolemund and Hadley Wickham (Chapters 12 and 13). 

    “Happy families are all alike; every unhappy family is unhappy in its own way.” 
    – Leo Tolstoy

    “Tidy datasets are all alike, but every messy dataset is messy in its own way.” 
    – Hadley Wickham
      
### Previous topics

To maximise the effect of this post you should definitely work through [Data Wrangling Vol. 1](https://yuzar-blog.netlify.app/posts/2023-01-31-datawrangling1/) and [Data Wrangling Vol. 2](https://yuzar-blog.netlify.app/posts/2023-02-07-datawrangling2/) before.

### Why do we need tidy data? What are the benefits?


```{.r .distill-force-highlighting-css}
```
