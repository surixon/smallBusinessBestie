import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../models/income_data_model.dart';
import '../models/pie_chart_data.dart';

class HomeProvider extends BaseProvider {
  List<IncomeData> data = [
    IncomeData('2021', 5000),
    IncomeData('2022', 2500),
    IncomeData('2023', 13000),
    IncomeData('2024', 25000)
  ];

  final List<PieChartData> chartData = [
    PieChartData('David', 25),
    PieChartData('Steve', 38),
    PieChartData('Jack', 34),
    PieChartData('Others', 52)
  ];
}
