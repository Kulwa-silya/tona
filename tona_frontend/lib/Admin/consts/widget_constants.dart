import 'package:machafuapp/Admin/Pages/Expenditure_and_Expenses/ExpenditureExpenses.dart';
import 'package:machafuapp/Admin/Pages/Income/Income.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Pages/Purchases/purchases.dart';
import 'package:machafuapp/Admin/ui/widgets/wallet_card.dart';
import 'package:flutter/material.dart';

const List<Widget> demoTransactions = [
  WalletCard(
    onBTap: Products(),
    icon: Icons.money,
    text: 'Products',
    desc: 'Idadi ya bidhaa zilizopo',
    amount: 'jumla 49',
  ),
  WalletCard(
    onBTap: Income(),
    icon: Icons.attach_money_outlined,
    desc: 'Mapato yalioingia kwa siku',
    text: 'Income',
    amount: '100000 (today)',
  ),
  WalletCard(
    onBTap: ExpenditureExpenses(),
    icon: Icons.content_paste_go_sharp,
    desc: 'Matumizi na gharama za siku',
    text: 'Expenses',
    amount: '20,000 (today)',
  ),
  WalletCard(
    onBTap: Purchases(),
    icon: Icons.monitor_weight_sharp,
    text: 'Purchases',
    desc: 'Manunuzi kwa siku',
    amount: '500,000 (today)',
  ),
];

ontap() {}
