import 'package:machafuapp/Admin/ui/widgets/wallet_card.dart';
import 'package:flutter/material.dart';

const List<Widget> demoTransactions = [
  WalletCard(
    icon: Icons.attach_money,
    text: 'Products',
    desc: 'Idadi ya bidhaa zilizopo',
    amount: 'jumla 49',
  ),
  WalletCard(
    icon: Icons.circle,
    desc: 'Mapato yalioingia kwa siku',
    text: 'Income',
    amount: '100000 (today)',
  ),
  WalletCard(
    icon: Icons.star_border,
    desc: 'Matumizi na gharama za siku',
    text: 'Expenses & Expenditure',
    amount: '20,000 (today)',
  ),
  WalletCard(
    icon: Icons.lock,
    text: 'Purchases',
    desc: 'Manunuzi kwa siku',
    amount: '500,000 (today)',
  ),
];
