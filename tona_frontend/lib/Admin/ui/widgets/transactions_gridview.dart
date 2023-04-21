import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/ui/widgets/wallet_card.dart';
import '../../Pages/Expenditure_and_Expenses/ExpenditureExpenses.dart';
import '../../Pages/Products/productsCategory.dart';
import '../../Pages/Purchases/purchasesHome.dart';
import '../../Pages/Sales/salesHome.dart';
import '../../consts/widget_constants.dart';
import '../shared/edge_insect.dart';

class TransactionsGridView extends StatelessWidget {
   TransactionsGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.axtok
  }) : super(key: key);
  String axtok;
  final int crossAxisCount;
  final double childAspectRatio;



  @override
  Widget build(BuildContext context) {
    List<Widget> demoTransactions = [
  
  WalletCard(
    onBTap: ProductCat(Axtok: axtok,),
    icon: Icons.money,
    text: 'Products',
    desc: 'Idadi ya bidhaa zilizopo',
    amount: 'jumla 49',
  ),
  WalletCard(
    onBTap: SalesHome(),
    icon: Icons.attach_money_outlined,
    desc: 'Mauzo yaliyofanyika kwa siku',
    text: 'Sales',
    amount: '10500',
  ),
  WalletCard(
    onBTap: ExpenditureExpenses(),
    icon: Icons.content_paste_go_sharp,
    desc: 'Matumizi na gharama za siku',
    text: 'Expenses',
    amount: '20,000 (today)',
  ),
  WalletCard(
    onBTap: PurchasesHome(Axtok: axtok,),
    icon: Icons.monitor_weight_sharp,
    text: 'Purchases',
    desc: 'Manunuzi kwa siku',
    amount: '500,000 (today)',
  ),
];
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoTransactions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => demoTransactions[index]
    );
  }
}
