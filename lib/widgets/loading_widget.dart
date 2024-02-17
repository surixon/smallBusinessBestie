import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants/colors_constants.dart';
import '../helpers/decoration.dart';
import '../provider/loading_provider.dart';

class LoadingScreen {
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, LoadingCustom(child: child!));
      } else {
        return LoadingCustom(child: child!);
      }
    };
  }
}

class LoadingCustom extends StatelessWidget {
  final Widget child;

  const LoadingCustom({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      child,
      Consumer<LoadingProvider>(builder: (context, provider, child) {
        return provider.loading
            ? const Stack(
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: ModalBarrier(dismissible: false, color: Colors.grey),
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : Container();
      })
    ]));
  }
}
