import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';

class LinearRegression{


  List<double> predicted_values=[];
  LinearRegression(List<double> trainx,List<double> trainy,List<double> predictx){
    Series distanceseries=Series('distance',trainx);
    Series timeseries=Series('time',trainy);
    Series predictseries=Series('distance',predictx);
    DataFrame traindata=DataFrame.fromSeries([distanceseries,timeseries]);
    final normalizer = Normalizer(); // by default Euclidean norm will be used
    final transformed_data = normalizer.process(traindata);
    final targetName = 'time';
    final regressor = LinearRegressor(
      transformed_data,
      targetName,
      iterationsLimit: 50,
      learningRateType: LearningRateType.decreasingAdaptive,
      randomSeed: 10,
      initialLearningRate: 1,
      batchSize: 4,
      fitIntercept: true,
      interceptScale:0,
    );
    final prediction_dataframe=regressor.predict(DataFrame.fromSeries([predictseries]));
    List<dynamic> predictions=prediction_dataframe['time'].data.toList();
    predictions.forEach((prediction) { predicted_values.add(double.parse(prediction.toString())); });

  }
//
 List<dynamic> get_predictions() {
    return predicted_values;
 }


}