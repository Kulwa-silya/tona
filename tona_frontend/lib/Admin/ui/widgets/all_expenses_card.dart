import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/ui/widgets/expensesRow.dart';
import 'package:machafuapp/Admin/ui/widgets/transactions_row.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stacked/stacked.dart';

import '../../views/main/main_viewmodel.dart';
import '../shared/colors.dart';
import '../shared/edge_insect.dart';
import '../shared/spacing.dart';
import '../shared/text_styles.dart';

class AllExpensesCard extends ViewModelWidget<MainViewModel> {
  const AllExpensesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: kEdgeInsetsHorizontalTiny,
      height: height * 0.60,
      decoration: BoxDecoration(
        border: Border.all(color: kSecondaryColor5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          verticalSpaceMedium,
          const ExpeRow(
            title: 'All Expenses',
            // cardText: 'Monthly',
          ),
          verticalSpaceMedium,
          CircularPercentIndicator(
            radius: 100,
            lineWidth: 30,
            backgroundColor: kBlackColor,
            progressColor: kTertiaryColor5,
            percent: 0.1,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '90.8%',
                  style: kHeading3TextStyle,
                ),
                Text(
                  'Total Expenses',
                  style: kSmallRegularTextStyle,
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CheckboxListTile(
                    visualDensity: VisualDensity.comfortable,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: kBlackColor,
                    side: const BorderSide(color: kTertiaryColor4),
                    checkColor: kBlackColor,
                    title: Text(
                      'Credits',
                      style:
                          kSmallRegularTextStyle.copyWith(color: kBlackColor),
                    ),
                    value: viewModel.receivedCheckValue,
                    onChanged: viewModel.onReceivedCheckChanged,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: kBlackColor,
                    side: const BorderSide(color: kTertiaryColor4),
                    checkColor: kBlackColor,
                    title: Text(
                      'Derbits',
                      style:
                          kSmallRegularTextStyle.copyWith(color: kBlackColor),
                    ),
                    value: viewModel.sendCheckValue,
                    onChanged: viewModel.onSendCheckChanged,
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Daily',
                    style: kSmallRegularTextStyle.copyWith(color: kBlackColor),
                  ),
                  verticalSpaceTiny,
                  Text(
                    '289,000 TZS',
                    style: kBodyTextStyle.copyWith(color: kBlackColor),
                  ),
                ]),
                verticalSpaceSmall,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly',
                      style:
                          kSmallRegularTextStyle.copyWith(color: kBlackColor),
                    ),
                    verticalSpaceTiny,
                    Text(
                      '120,000 TZS',
                      style: kBodyTextStyle.copyWith(color: kBlackColor),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly',
                      style:
                          kSmallRegularTextStyle.copyWith(color: kBlackColor),
                    ),
                    verticalSpaceTiny,
                    Text(
                      '438,000 TZS',
                      style: kBodyTextStyle.copyWith(color: kBlackColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
