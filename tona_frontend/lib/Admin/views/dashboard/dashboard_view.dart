import 'package:machafuapp/Admin/ui/shared/edge_insect.dart';
import 'package:machafuapp/Admin/ui/shared/spacing.dart';
import 'package:machafuapp/responsive.dart';
import 'package:flutter/material.dart';

import '../../Models/transaction_model.dart';
import '../../ui/shared/colors.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/widgets/all_expenses_card.dart';
import '../../ui/widgets/expenses_details.dart';
import '../../ui/widgets/main_header.dart';
import '../../ui/widgets/quick_transfer_card.dart';
import '../../ui/widgets/transactions_card.dart';
import '../../ui/widgets/transactions_gridview.dart';
import '../../ui/widgets/transactions_row.dart';

class DashBoardView extends StatelessWidget {
  const DashBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final Size _size = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              verticalSpaceSmall,
              const MainHeader(),
              verticalSpaceRegular,
              Container(
                padding: kEdgeInsetsHorizontalNormal,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kBlackColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Balance',
                          style: kBodyRegularTextStyle.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                        verticalSpaceSmall,
                        Text(
                          '500,000 TZS',
                          style: kHeading1TextStyle.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: kEdgeInsetsHorizontalNormal,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kWhiteColor),
                      child: Center(
                        child: Text(
                          'See more',
                          style: kBodyTextStyle.copyWith(color: kBlackColor),
                        ),
                      ),
                    ),
                  ],
                ),
                height: height * 0.20,
              ),
              verticalSpaceRegular,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Responsive(
                        mobile: TransactionsGridView(
                          crossAxisCount: _size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              _size.width < 650 && _size.width > 350 ? 1.3 : 1,
                        ),
                        tablet: const TransactionsGridView(),
                        desktop: TransactionsGridView(
                          childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                        ),
                      ),
                      verticalSpaceRegular,
                      const TransactionRow(
                        title: 'User(Employees)',
                        cardText: 'More',
                      ),
                      verticalSpaceRegular,
                      for (final transaction in transactionsData) ...[
                        TransactionsCard(transaction: transaction),
                      ],
                      verticalSpaceRegular,
                      if (!Responsive.isDesktop(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) ...[
                        const AllExpensesCard(),
                        verticalSpaceRegular,
                        // const QuickTransferCard()
                      ],
                      verticalSpaceRegular
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        horizontalSpaceSmall,
        if (Responsive.isDesktop(context))
          Expanded(
            child: Padding(
              padding: kEdgeInsetsAllSmall,
              child: const ExpensesDetails(),
            ),
          ),
      ],
    );
  }
}
