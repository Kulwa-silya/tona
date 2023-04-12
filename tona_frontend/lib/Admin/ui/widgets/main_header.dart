import 'package:machafuapp/Admin/ui/widgets/transactions_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import '../../../responsive.dart';
import '../../views/main/main_viewmodel.dart';
import '../shared/colors.dart';
import '../shared/spacing.dart';
import '../shared/text_styles.dart';
import 'package:flutter/material.dart';

class MainHeader extends ViewModelWidget<MainViewModel> {
  String? name;
  MainHeader({required this.name, Key? key}) : super(key: key);

  Future<void> deletePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('accesstoken');
    prefs.remove('refreshtoken');
  }

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
              '${name}',
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
        GestureDetector(
          onTap: () {
            deletePreference();
          },
          child: const CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage('assets/images/image_1.png'),
          ),
        ),
      ],
    );
  }
}
