#' Simulation of SM2RAIN algorithm.
#'
#' @param PAR A 3-dimensional vector of parameters.
#' @param data A dataframe with dimensions n x 3. The 1st column of the datafram should contain dates, the 2nd the Soil moisture series, and the 3rd the precipitation series.
#' @param NN A scalar indicating the aggregation level. Default: 24 (assuming that the the data are hourly, and we wish to aggregate them at daily temporal scale).
#' @param deltaSM SM2RAIN algorithm parameter. Default: 0.005.
#'
#' @return A list with 4 elements. That is, Date, SM (Soil moisture), Psim (Simulated precipitations), Pobs (Observed precipitation) and R (Corr[Psim,Pobs])
#' @export
#'
#' @examples
#' # Define some parameters for the SM2RAIN algorithm
#' PAR = c(64.65, 2.09, 10.41)
#'
#' # Use the data contained in the first element of the list called data.
#' ts_df = data[[1]]
#'
#' # Estimate percipitation using SM2RAIN algorithm
#' Sim = sm2rain(PAR=PAR, data=ts_df, NN=24)
#' plot(Sim$Pobs, t='l', col='black')
#' lines(Sim$Psim, col='red' )
#'
sm2rain<-function(PAR, data,  NN=24, deltaSM=0.005) {


  # file=paste0(name,'.txt')
  # data=read.table(file = file)
  # colnames(data)=c('Date', 'SM', "Rain")
  N=nrow(data)
  D=data[1:(N-1),1]
  Pobs=data[1:(N-1),3]
  SM=data[1:(N),2]

  Z=PAR[1]
  a=PAR[2]
  b=PAR[3]

  N=length(Pobs);
  Psim=rep(0, N);

  for (t in 2:N) {
    if ( (is.na(SM[t]) || is.na(SM[t-1]))==1 ) {
      Psim[t-1]=NA
    } else {
      if (SM[t]-SM[t-1]>deltaSM) {
        # SMav=(SM[t]+SM[t-1])/2
        # Psim[t-1]=Z*(SM[t]-SM[t-1])+a*SMav^b;

        Psim[t-1]=Z*(SM[t]-SM[t-1])+(a*SM[t]^b+a*SM[t-1]^b)/2
      }
    }
  }

  # Psim(isnan(SM(2:end)))=NaN;
  # Pobs(isnan(Psim))=NaN;
  # PPsim=Psim;


  # Temporal aggregation
  if (NN>1) {
    MM=length(Psim);
    L=floor(MM/NN)

    Psim=pracma::Reshape(Psim[1:(L*NN)],NN,L);
    Psim=colSums(Psim)
    Pobs=pracma::Reshape(Pobs[1:(L*NN)],NN,L);
    Pobs=colSums(Pobs)

    SM=pracma::Reshape(SM[1:(L*NN)],NN,L);
    SM=colSums(SM)/NN

    D=pracma::Reshape(D[1:(L*NN)],NN,L);
    D=colSums(D)/NN
  }
  Psim=ifelse(Psim<=1,0,Psim)

  # Calculation of model performance
  IDcomp=Pobs>-1
  IDcomp=(Pobs>-1);
  R=stats::cor(Pobs, Psim, use = 'c')
  return(list(Date=D, SM=SM, Psim=Psim, Pobs=Pobs, R=R))
}
