
# Implementation of SM2RAIN algorithm in R

# Detecting rainfall from the bottom up\!

## `sm2rainR` R-package - What is it?

`sm2rainR` is an R package that implements the SM2RAIN algorithm of
[Brocca et al. (2013)](https://doi.org/10.1002/grl.50173), and [Brocca
et al. (2014)](https://doi.org/10.1002/2014JD021489) for estimating
rainfall from soil moisture data.

Full description of the SM2RAIN algorithm as well as validations of its
performance can be found in the above mentioned works.

For more details and datasets see also
[here](http://hydrology.irpi.cnr.it/research/sm2rain/) and
[here](http://www.irpi.cnr.it/en/focus/sm2rain/).

## If you do not believe it is possible, try yourself\!

The `sm2rainR` comes together with some data (hourly datasets of soil
moistrure and precipitation at 16 sites). Let’s load some of them:

``` r
library(sm2rainR)
ts_df=(data[[1]])
head(ts_df)
```

    ##       Date        SM Rain
    ## 1 733043.0 0.4831461    0
    ## 2 733043.0 0.4831461    0
    ## 3 733043.1 0.4823970    0
    ## 4 733043.1 0.4815409    0
    ## 5 733043.2 0.4810653    0
    ## 6 733043.2 0.4807627    0

``` r
tail(ts_df)
```

    ##           Date        SM Rain
    ## 26299 734138.8 0.5209397    0
    ## 26300 734138.8 0.5201831    0
    ## 26301 734138.8 0.5195292    0
    ## 26302 734138.9 0.5191011    0
    ## 26303 734138.9 0.5181024    0
    ## 26304 734139.0 0.5168539    0

### `sm2rainR` in action

Calibrate the SM2RAIN algorithm. The used in this example values for
`itermax` and `NP` are not reccomended (they are used here just for
computational speed). Please use higher values for both (e.g.,
itermax=100 and
    NP=30)

``` r
Opt=sm2rainCalib(fn=sm2rainNSE, data= ts_df, itermax=20, NP=10)
```

    ## Iteration: 1 bestvalit: -0.639104 bestmemit:   86.640894  161.594181  140.581130
    ## Iteration: 2 bestvalit: -0.639104 bestmemit:   86.640894  161.594181  140.581130
    ## Iteration: 3 bestvalit: -0.656220 bestmemit:  121.477244   44.205181  132.977960
    ## Iteration: 4 bestvalit: -0.656220 bestmemit:  121.477244   44.205181  132.977960
    ## Iteration: 5 bestvalit: -0.732381 bestmemit:   99.049421   67.128358  140.581130
    ## Iteration: 6 bestvalit: -0.732381 bestmemit:   99.049421   67.128358  140.581130
    ## Iteration: 7 bestvalit: -0.732381 bestmemit:   99.049421   67.128358  140.581130
    ## Iteration: 8 bestvalit: -0.756292 bestmemit:   81.002998   21.591476  144.187280
    ## Iteration: 9 bestvalit: -0.756292 bestmemit:   81.002998   21.591476  144.187280
    ## Iteration: 10 bestvalit: -0.756292 bestmemit:   81.002998   21.591476  144.187280
    ## Iteration: 11 bestvalit: -0.762670 bestmemit:   74.177265   65.431471   19.491594
    ## Iteration: 12 bestvalit: -0.762670 bestmemit:   74.177265   65.431471   19.491594
    ## Iteration: 13 bestvalit: -0.774919 bestmemit:   96.176193   19.297452    8.718067
    ## Iteration: 14 bestvalit: -0.774919 bestmemit:   96.176193   19.297452    8.718067
    ## Iteration: 15 bestvalit: -0.781493 bestmemit:   91.363813   10.472967   16.917063
    ## Iteration: 16 bestvalit: -0.794929 bestmemit:   81.518742   34.501822   13.445348
    ## Iteration: 17 bestvalit: -0.794929 bestmemit:   81.518742   34.501822   13.445348
    ## Iteration: 18 bestvalit: -0.794929 bestmemit:   81.518742   34.501822   13.445348
    ## Iteration: 19 bestvalit: -0.794929 bestmemit:   81.518742   34.501822   13.445348
    ## Iteration: 20 bestvalit: -0.794929 bestmemit:   81.518742   34.501822   13.445348

``` r
# The NSE value obtained by calibration
print(Opt$obj)
```

    ## [1] 0.7949294

``` r
# Estimate percipitation using SM2RAIN algorithm
Sim = sm2rain(PAR=Opt$params, data=ts_df, NN=24)
```

## Let’s make some plots

Compare the simulated and obvserved series of precipitation

``` r
par(mfrow=c(1,2))
plot(Sim$Pobs, t='l', col='black', xlab='Time index[days]', ylab='Rainfall [mm]')
lines(Sim$Psim, col='red' )
legend("topleft", legend=c("Observed", "Simulated"), col=c('black', 'red'), lty=c('solid','solid'), cex=0.7)
plot(Sim$Psim, Sim$Pobs, pch=19, xlab='Simulated rainfall [mm]', ylab='Observed rainfall [mm]')
```

![](sm2rainR_readme_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->
