import 'package:flutter/material.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/hydration_progress.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class AddHydrationModal extends StatelessWidget {
  const AddHydrationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableSheet(
      child: SheetContentScaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              HydrationProgress(
                progress: 0,
                size: Size.square(120),
                radius: 60,
              ),
              Text(
                'Water',
                style: ShadTheme.of(context).textTheme.h4,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '0',
                    style: ShadTheme.of(context).textTheme.h1Large,
                  ),
                  Text(
                    '/ml',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                ],
              ),
              ShadSlider(
                initialValue: 0,
                min: 0,
                max: 100,
              ),
              PrimaryButton(
                onTap: () {},
                title: 'Add Water',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
