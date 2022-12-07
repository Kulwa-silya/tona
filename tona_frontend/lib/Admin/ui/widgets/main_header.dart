import 'package:machafuapp/Admin/ui/widgets/transactions_row.dart';
import 'package:stacked/stacked.dart';
import '../../../responsive.dart';
import '../../views/main/main_viewmodel.dart';
import '../shared/colors.dart';
import '../shared/spacing.dart';
import '../shared/text_styles.dart';
import 'package:flutter/material.dart';

class MainHeader extends ViewModelWidget<MainViewModel> {
  const MainHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, viewModel) {
    return Row(
      children: [
        SizedBox(
          height: 100,
        ),
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: kBlackColor,
            ),
            onPressed: viewModel.controlMenu,
          ),
        horizontalSpaceSmall,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Karibu Tena,',
              style: kBodyRegularTextStyle,
            ),
            Text(
              'Machafu',
              style: kHeading3TextStyle,
            ),
          ],
        ),
        const Spacer(),
        // const Icon(
        //   Icons.mark_email_unread,
        //   color: kSecondaryColor4,
        // ),
        horizontalSpaceSmall,
        const Icon(
          Icons.notifications_outlined,
          color: kSecondaryColor4,
        ),
        horizontalSpaceSmall,
        const CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage('assets/images/image_1.png'),
        ),
      ],
    );
  }
}
