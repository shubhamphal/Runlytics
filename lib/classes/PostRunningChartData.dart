class PostRunningChartData{

  List<double> x_labels;
  List<double> y_labels;
  List<double> y_best_labels;
  double x_max;
  double y_max;
  double y_min;

  PostRunningChartData({List<double> xlabels,List<double> ylabels,List<double> ybestlabels,double ymax,double ymin, double xmax}) {
    this.x_labels=xlabels;
    this.y_labels=ylabels;
    this.y_best_labels=ybestlabels;
    this.x_max=xmax;
    this.y_max=ymax;
    this.y_min=ymin;

  }


}