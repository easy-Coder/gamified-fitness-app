import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/common/widgets/measure_modal_sheet.dart';
import 'package:gamified/src/common/widgets/settings_list_item.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:gamified/src/features/account/schema/user.dart' show Gender;
import 'package:shadcn_ui/shadcn_ui.dart';

final userModelStateProvider = StateProvider<UserModel>(
  (_) => UserModel.empty(),
);

class UserProfileData extends ConsumerStatefulWidget {
  const UserProfileData({super.key});

  @override
  ConsumerState<UserProfileData> createState() => _UserProfileDataState();
}

class _UserProfileDataState extends ConsumerState<UserProfileData> {
  final formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelStateProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShadForm(
        key: formKey,
        child: ListView(
          children: [
            Text(
              'Let\'s Know About You',
              style: ShadTheme.of(context).textTheme.h2,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            ShadInputFormField(
              id: 'name',
              label: Text('Name'),
              placeholder: Text('Name (e.g. John)'),
              onChanged: (value) {
                ref.read(userModelStateProvider.notifier).state = userModel
                    .copyWith(name: value);
              },
              validator: (v) {
                if (v.length < 2) {
                  return 'Username must be at least 2 characters.';
                }
                if (v.length > 50) {
                  return 'Name must not be over 50 characters.';
                }
                return null;
              },
            ),
            8.verticalSpace,
            SettingsListItem(
              leadingIcon: Icon(LucideIcons.cake),
              title: 'Age',
              value: userModel.age != 0 ? "${userModel.age} years" : null,
              onTap: () async {
                int getAge(int index) => DateTime.now().year - (1940 + index);
                final age = await MeasureModalSheet.showModalSheet<int>(
                  context,
                  MeasureModalSheet(
                    title: 'Select Your Age',
                    itemCount: 2015 - 1940 + 1,
                    builder:
                        (context, index, currentIndex) => Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${getAge(index)}',
                            style: ShadTheme.of(
                              context,
                            ).textTheme.small.copyWith(
                              color:
                                  index == currentIndex ? Colors.white : null,
                            ),
                          ),
                        ),
                  ),
                );
                ref.read(userModelStateProvider.notifier).state = userModel
                    .copyWith(age: getAge(age!));
              },
            ),
            8.verticalSpace,
            SettingsListItem(
              leadingIcon: Icon(LucideIcons.user),
              title: 'Gender',
              value: userModel.gender.name.capitalize(),
              onTap: () async {
                final gender = await MeasureModalSheet.showModalSheet<int>(
                  context,
                  MeasureModalSheet(
                    title: 'Select Your Gender',
                    itemCount: Gender.values.length,
                    builder:
                        (BuildContext context, int index, int currentIndex) =>
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                Gender.values[index].name.capitalize(),
                                style: ShadTheme.of(
                                  context,
                                ).textTheme.small.copyWith(
                                  color:
                                      index == currentIndex
                                          ? Colors.white
                                          : null,
                                ),
                              ),
                            ),
                  ),
                );
                ref.read(userModelStateProvider.notifier).state = userModel
                    .copyWith(gender: Gender.values[gender!]);
              },
            ),
            8.verticalSpace,
            SettingsListItem(
              leadingIcon: Icon(LucideIcons.weight),
              title: 'Weight',
              value: userModel.weight == 0 ? null : userModel.weight.toString(),
              onTap: () async {
                double printWeight(index) => (20.0 + (index / 10));
                final weight = await MeasureModalSheet.showModalSheet<int>(
                  context,
                  MeasureModalSheet(
                    title: 'Select Your Gender',
                    itemCount: 9800,
                    builder:
                        (BuildContext context, int index, int currentIndex) =>
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${printWeight(index)} kg',
                                style: ShadTheme.of(
                                  context,
                                ).textTheme.small.copyWith(
                                  color:
                                      index == currentIndex
                                          ? Colors.white
                                          : null,
                                ),
                              ),
                            ),
                  ),
                );

                ref.read(userModelStateProvider.notifier).state = userModel
                    .copyWith(weight: printWeight(weight));
              },
            ),
            8.verticalSpace,
            SettingsListItem(
              leadingIcon: Icon(LucideIcons.ruler),
              title: 'Height',
              value: userModel.height == 0 ? null : userModel.height.toString(),
              onTap: () async {
                final height = await MeasureModalSheet.showModalSheet<int>(
                  context,
                  MeasureModalSheet(
                    title: 'Select Your Gender',
                    itemCount: 151,
                    builder:
                        (BuildContext context, int index, int currentIndex) =>
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${100 + index} cm',
                                style: ShadTheme.of(
                                  context,
                                ).textTheme.small.copyWith(
                                  color:
                                      index == currentIndex
                                          ? Colors.white
                                          : null,
                                ),
                              ),
                            ),
                  ),
                );

                ref.read(userModelStateProvider.notifier).state = userModel
                    .copyWith(height: (100 + height!).toDouble());
              },
            ),
          ],
        ),
      ),
    );
  }
}
