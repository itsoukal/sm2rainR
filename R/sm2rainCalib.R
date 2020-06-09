#' Calibration of SM2RAIN parameters using the algorithm of DEoptim R package
#'
#' @param fn Function that calculates the objecvtive function of the calibration problem. Currently only one option: sm2rainNSE
#' @param data A dataframe with dimensions n x 3. The 1st column of the datafram should contain dates, the 2nd the Soil moisture series, and the 3rd the precipitation series.
#' @param NN A scalar indicating the aggregation level. Default: 24 (assuming that the the data are hourly, and we wish to aggregate them at daily temporal scale).
#' @param deltaSM SM2RAIN algorithm parameter. Default: 0.005.
#' @param lb A 3-dimensional vector of parameters lower bound (used for calibration).
#' @param ubA 3-dimensional vector of parameters upper bound (used for calibration).
#' @param itermax A scalar indicatig the maximum number of iterations (used for calibration).
#' @param NP A scalar indicatig the population size of the optimization algorithm (used for calibration).
#' @param parallelType Indicate the use or not of parallel computing. Can be 0, 1, or 2. Default=0 (used for calibration).
#'
#' @return A list with the calibration results. The elements of the list are param (which contains the optimum parameters), and obj (which contains the attained NSE value).
#' @export
#'
#' @examples
#' # Use the data contained in the first element of the list called data.
#' ts_df = data[[1]]
#'
#' # Calibrate the SM2RAIN algorithm.
#' # The use of itermax=10 and NP=5 is not reccomended (it is used here just comp. speed.)
#' # Please use higher values for both (e.g., itermax=100 and NP=30)
#'
#' Opt=sm2rainCalib(fn=sm2rainNSE, data= ts_df, itermax=10, NP=5)
#'
#' # The NSE value obtained by calibration
#' print(Opt$obj)
#'
#' # Estimate percipitation using SM2RAIN algorithm
#' Sim = sm2rain(PAR=Opt$params, data=ts_df, NN=24)
#' plot(Sim$Pobs, t='l', col='black')
#' lines(Sim$Psim, col='red' )
#'
sm2rainCalib<-function(fn=sm2rainNSE, data, NN=24, deltaSM=0.005,  lb=c(1, 0, 1), ub=c(200, 1800, 150), itermax=100, NP=20, parallelType=0){

  opt=suppressWarnings(suppressMessages(DEoptim::DEoptim(fn = sm2rainNSE, lower = lb, upper = ub, data=data,  NN=NN, deltaSM=deltaSM,
                   control=list(NP=NP, itermax=itermax, parallelType=parallelType))))
  opt2=list()
  opt2$params=opt$optim$bestmem
  opt2$obj=-opt$optim$bestval

  return(opt2)
}
