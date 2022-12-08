
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../responsive.dart';
import '../../ui/shared/spacing.dart';
import '../../ui/widgets/side_menu.dart';
import '../dashboard/dashboard_view.dart';
import 'main_viewmodel.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          
          key: model.scaffoldKey,
          drawer: const SideMenu(),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: SideMenu(),
                ),
              horizontalSpaceRegular,
              const Expanded(
                flex: 5,
                child: DashBoardView(),
              ),
              horizontalSpaceSmall,
            ],
          ),
        );
      },
      viewModelBuilder: () => MainViewModel(),
    );
  }
}
