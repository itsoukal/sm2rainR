#' Objective function for the calibration of SM2RAIN algorithm. Maxmimization of Nash-Sutcliffe Efficiency (NSE).
#'
#' @param PAR A 3-dimensional vector of parameters.
#' @param data A dataframe with dimensions n x 3. The 1st column of the datafram should contain dates, the 2nd the Soil moisture series, and the 3rd the precipitation series.
#' @param NN A scalar indicating the aggregation level. Default: 24 (assuming that the the data are hourly, and we wish to aggregate them at daily temporal scale).
#' @param deltaSM SM2RAIN algorithm parameter. Default: 0.005.
#'
#' @return A scalar indicating the Nash-Sutcliffe Efficiency (NSE) of the selected parameters for the provided data.
#' @export
#'
#' @examples
#' # Define some parameters for the SM2RAIN algorithm
#' PAR = c(64.65, 2.09, 10.41)
#'
#' # Use the data contained in the first element of the list called data.
#' ts_df = data[[1]]
#'
#' # Estimate the NSE value comparing precipitation obtained by the
#' SM2RAIN algorithm (and parameters defined in PAR) and observed precipitation.
#'
#' NSE = sm2rainNSE(PAR=PAR, data=ts_df, NN=24)
#' print(NSE)
#'
sm2rainNSE=function(PAR, data,  NN=24, deltaSM=0.005) {
  Res=sm2rain(PAR=PAR, data=data,  NN=NN, deltaSM=deltaSM)
  Psim=Res$Psim
  Pobs=Res$Pobs

  Psim=ifelse(Psim<0,0,Psim)
  Psim=ifelse(is.nan(Psim),NA,Psim)

  Pobs=ifelse(Pobs<0,0,Pobs)
  Pobs=ifelse(is.nan(Pobs),NA,Pobs)

  avPobs=mean(Pobs, na.rm = T)
  NSE=-(1-(sum((Psim-Pobs)^2, na.rm = T)/sum((Pobs-avPobs)^2, na.rm = T)))
  # NSE=-hydroGOF::NSE(sim = Psim, obs=Pobs)
  NSE=ifelse(test = is.nan(NSE), 10^6, NSE)
  NSE=ifelse(test = is.na(NSE), 10^6, NSE)
  return(NSE)
}

# sm2rainNSE(PAR = c(69.3796, 16.1741, 8.4747), data = data1, deltaSM = 0.0001)
