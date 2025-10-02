import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaimon/gaimon.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class RestTimerModal extends StatefulWidget {
  const RestTimerModal({super.key});

  static Future<Duration?> showModalSheet(BuildContext context) {
    // Use ModalSheetRoute to show a modal sheet with imperative Navigator API.
    // It works with any *Sheet provided by this package!
    final modalRoute = ModalSheetRoute<Duration>(
      // Enable the swipe-to-dismiss behavior.
      swipeDismissible: false,
      // Use `SwipeDismissSensitivity` to tweak the sensitivity of the swipe-to-dismiss behavior.
      builder: (context) => RestTimerModal(),
    );

    return Navigator.push<Duration>(context, modalRoute);
  }

  @override
  State<RestTimerModal> createState() => _RestTimerModalState();
}

class _RestTimerModalState extends State<RestTimerModal> {
  int seconds = 0;
  int minutes = 0;
  @override
  Widget build(BuildContext context) {
    return Sheet(
      snapGrid: const SheetSnapGrid.single(snap: SheetOffset(0.3)),
      initialOffset: const SheetOffset(0.3),
      decoration: MaterialSheetDecoration(
        size: SheetSize.fit,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
      ),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              "Add Duration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            20.verticalSpace,
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(10),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          perspective: 0.01,
                          overAndUnderCenterOpacity: 0.5,
                          onSelectedItemChanged: (index) {
                            Gaimon.selection();
                            setState(() {
                              minutes = index;
                            });
                          },
                          physics: FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 60,
                            builder: (context, index) => Center(
                              child: Text(
                                (index).toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      20.horizontalSpace,
                      SizedBox(
                        width: 40,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          perspective: 0.01,
                          overAndUnderCenterOpacity: 0.5,
                          onSelectedItemChanged: (index) {
                            Gaimon.selection();
                            setState(() {
                              seconds = index;
                            });
                          },
                          physics: FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 60,
                            builder: (context, index) => Center(
                              child: Text(
                                (index).toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            PrimaryButton(
              title: "Add Rest Timer",
              onTap: () {
                Gaimon.selection();
                final duration = Duration(seconds: seconds, minutes: minutes);
                context.pop(duration);
              },
            ),
          ],
        ),
      ),
    );
  }
}
