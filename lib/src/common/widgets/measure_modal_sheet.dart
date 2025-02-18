import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class MeasureModalSheet extends StatefulWidget {
  const MeasureModalSheet({
    super.key,
    required this.title,
    required this.itemCount,
    required this.builder,
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index, int currentIndex)
  builder;

  static Future<T?> showModalSheet<T>(
    BuildContext context,
    Widget modalSheet,
  ) async {
    final modal = ModalSheetRoute<T>(
      swipeDismissible: true,

      builder: (context) => modalSheet,
    );

    final result = await Navigator.push<T>(context, modal);
    return result;
  }

  @override
  State<MeasureModalSheet> createState() => _MeasureModalSheetState();
}

class _MeasureModalSheetState extends State<MeasureModalSheet> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DraggableSheet(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.title, style: ShadTheme.of(context).textTheme.h4),
                ],
              ),
              24.verticalSpace,
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 130),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: Colors.black),
                      ),
                    ),
                    ListWheelScrollView.useDelegate(
                      itemExtent: 50,
                      perspective: 0.001,
                      overAndUnderCenterOpacity: 0.5,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      physics: FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: widget.itemCount,
                        builder:
                            (context, index) =>
                                widget.builder(context, index, _currentIndex),
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              PrimaryButton(
                onTap: () => context.pop(_currentIndex),
                title: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
