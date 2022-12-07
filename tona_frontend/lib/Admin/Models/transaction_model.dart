class TransactionModel {
  final String title;
  final String description;
  final String date;
  final String amount;
  final String image;

  TransactionModel({
    required this.description,
    required this.title,
    required this.date,
    required this.amount,
    required this.image,
  });
}

List<TransactionModel> transactionsData = [
  TransactionModel(
    title: 'Kulwa Malyango',
    description: 'Sales Manager',
    amount: '105060 TZS',
    date: 'Dar',
    image: 'assets/icons/face1.png',
  ),
  TransactionModel(
    title: 'Machafu',
    description: 'CEO TONA',
    amount: '2,500,000 TZS',
    date: 'Dar',
    image: 'assets/icons/face2.png',
  ),
  TransactionModel(
    title: 'Willie',
    description: 'Accountancy',
    amount: '500,000 TZS',
    date: 'Dom',
    image: 'assets/icons/face3.png',
  ),
];
