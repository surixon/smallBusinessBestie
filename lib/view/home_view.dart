import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smalll_business_bestie/helpers/decoration.dart';
import 'package:smalll_business_bestie/models/income_data_model.dart';
import 'package:smalll_business_bestie/models/pie_chart_data.dart';
import 'package:smalll_business_bestie/provider/home_provider.dart';
import 'package:smalll_business_bestie/view/base_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants/colors_constants.dart';
import '../helpers/common_function.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeProvider>(
        builder: (context, provider, _) => Scaffold(
            appBar: CommonFunction.appBarWithButtons('dashboard'.tr(), context,
                showAdd: false),
            body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(children: [
                  Center(
                    child: Text(
                      'total_income'.tr(),
                      style: ViewDecoration.textStyleMedium(
                          kGrey626262.withOpacity(.5), 15.sp),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '\$ 15,000',
                    style:
                        ViewDecoration.textStyleSemiBold(kOrangeColor, 40.sp),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'yearly_income'.tr(),
                    style: ViewDecoration.textStyleMedium(
                        kGrey626262.withOpacity(.5), 15.sp),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(enable: false),
                      primaryXAxis: CategoryAxis(
                        axisLine: const AxisLine(
                          width: 0,
                        ),
                        majorGridLines: const MajorGridLines(width: 0),
                        labelStyle:
                            ViewDecoration.textStyleMedium(kBlackColor, 12.sp),
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: 25000,
                        interval: 5000,
                        axisLine: const AxisLine(
                          width: 0,
                        ),
                        majorGridLines: const MajorGridLines(
                          width: 1,
                        ),
                        labelStyle:
                            ViewDecoration.textStyleMedium(kBlackColor, 12.sp),
                        labelFormat: '\$ {value}',
                      ),
                      plotAreaBorderWidth: 0,
                      series: <CartesianSeries<IncomeData, String>>[
                        ColumnSeries<IncomeData, String>(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.r),
                                topRight: Radius.circular(4.r)),
                            dataSource: provider.data,
                            xValueMapper: (IncomeData data, _) => data.year,
                            yValueMapper: (IncomeData data, _) => data.income,
                            color: kPinkColor)
                      ]),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      _incomeTab(
                          kColorFFD07A, 'total_expenses'.tr(), '\$ 29,000'),
                      SizedBox(
                        width: 8.w,
                      ),
                      _incomeTab(
                          kColorFC5B2D, 'total_profit'.tr(), '\$ 29,000'),
                      SizedBox(
                        width: 8.w,
                      ),
                      _incomeTab(
                          kColor0294EA, 'cost_of_inventory'.tr(), '\$ 29,000'),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SfCircularChart(
                      legend: const Legend(
                        isVisible: true, // Show legend
                      ),
                      series: <CircularSeries>[
                        // Render pie chart
                        PieSeries<PieChartData, String>(
                          dataSource: provider.chartData,
                          pointColorMapper: (PieChartData data, _) =>
                              data.color,
                          xValueMapper: (PieChartData data, _) => data.x,
                          yValueMapper: (PieChartData data, _) => data.y,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true, // Show data labels
                            builder:
                                (data, point, series, pointIndex, seriesIndex) {
                              return Text(
                                "${point.x}\n${point.y}%",
                                textAlign: TextAlign.center,
                                style: ViewDecoration.textStyleRegular(
                                    kBlackColor, 12.sp),
                              );
                            },
                            labelPosition: ChartDataLabelPosition
                                .outside, // Place labels outside
                          ),
                        )
                      ]),
                ]))));
  }

  _incomeTab(Color color, String text, String amount) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.r),
                topLeft: Radius.circular(10.r)),
            border: Border.all(color: color, width: 2)),
        child: Column(
          children: [
            Container(
              height: 30.h,
              decoration: BoxDecoration(
                  color: color.withOpacity(.5),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      topLeft: Radius.circular(8.r))),
              child: Center(
                  child: Text(
                text,
                style: ViewDecoration.textStyleMedium(kBlackColor, 10.sp),
              )),
            ),
            Container(
              height: 66.h,
              child: Center(
                  child: Text(
                amount,
                style: ViewDecoration.textStyleBold(kBlackColor, 15.sp),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
