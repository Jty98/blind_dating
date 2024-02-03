import 'package:blind_dating/model/ai_result_model.dart';
import 'package:blind_dating/viewmodel/signup_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AIResultChart extends StatelessWidget {
  final SignUpController signUpController;
  const AIResultChart({super.key, required this.signUpController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: SfCartesianChart(
          title: ChartTitle(
            text: "당신은 ${signUpController.dogTypeResult}를 가장 닮았습니다!",
            textStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          tooltipBehavior: signUpController.tooltipBehavior,
          series: [
            BarSeries<AIResultModel, String>(
              xValueMapper: (AIResultModel aiResult, _) => aiResult.breed,
              yValueMapper: (AIResultModel aiResult, _) =>
                  aiResult.probability.round(),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                color: Colors.blue[100],
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              dataSource: signUpController.resultMapList,
              pointColorMapper: (AIResultModel aiResult, _) {
                // 특정 조건을 기반으로 색상을 지정
                if (aiResult.probability ==
                    signUpController.resultMapList.first.probability) {
                  // 퍼센트가 가장 높은 아이템에 다른 색상 지정
                  return Colors.blue;
                } else {
                  // 나머지 아이템은 기본 색상 사용
                  return Colors.blueGrey;
                }
              },
            ),
          ],
          primaryXAxis: const CategoryAxis(
            majorGridLines: MajorGridLines(width: 0), // 주 축의 주요 격자 라인을 없앰
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          primaryYAxis: const NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelFormat: '{value}%',
          ),
        ),
      ),
    );
  }
}
