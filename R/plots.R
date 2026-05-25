# plots.R
library(ggplot2); library(dplyr)

plot_forecast <- function(actual_df, fitted_vals, forecast_val,
                          forecast_date, method_name, filename=NULL) {
  fd <- data.frame(date=actual_df$date, value=fitted_vals)
  p <- ggplot(actual_df, aes(x=date, y=index)) +
    geom_line(color="#2C3E50", linewidth=0.7) +
    geom_line(data=fd, aes(x=date,y=value), color="#E74C3C", linewidth=0.6, linetype="dashed") +
    geom_point(data=data.frame(date=forecast_date,value=forecast_val),
               aes(x=date,y=value), color="#27AE60", size=4, shape=18) +
    labs(title=paste(method_name,"- Actual vs Fitted + Forecast"),
         subtitle=paste("Forecast (Jan 2026):", round(forecast_val,2)),
         x="Date", y="CPI Index (2003=100)") +
    theme_minimal(base_size=11)
  if (!is.null(filename)) ggsave(paste0("outputs/figures/",filename), p, width=10, height=5, dpi=150)
  print(p)
}
