# accuracy_measures.R
calc_accuracy <- function(actual, fitted, method_name) {
  errors <- actual - fitted
  bias <- mean(errors, na.rm=TRUE)
  mad  <- mean(abs(errors), na.rm=TRUE)
  mse  <- mean(errors^2, na.rm=TRUE)
  mape <- mean(abs(errors/actual)*100, na.rm=TRUE)
  rsfe <- sum(errors, na.rm=TRUE)
  data.frame(Method=method_name, Bias_ME=round(bias,3), MAD=round(mad,3),
             MSE=round(mse,3), MAPE=round(mape,3), RSFE=round(rsfe,3),
             Tracking_Signal=round(rsfe/mad,3))
}
