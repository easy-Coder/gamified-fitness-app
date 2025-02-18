import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/common/widgets/measure_modal_sheet.dart';
import 'package:gamified/src/common/widgets/settings_list_item.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UserProfileData extends StatefulWidget {
  const UserProfileData({super.key, required this.onSave});

  final void Function(UserCompanion user) onSave;

  @override
  State<UserProfileData> createState() => _UserProfileDataState();
}

class _UserProfileDataState extends State<UserProfileData> {
  final formKey = GlobalKey<ShadFormState>();

  int? selectedAge;
  Gender selectedGender = Gender.male;
  double? selectedWeight;
  double? selectedHeight;

  String name = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShadForm(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Let\'s Know About You',
              style: ShadTheme.of(context).textTheme.h1,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            ShadInputFormField(
              id: 'name',
              label: Text('Name'),
              placeholder: Text('Name (e.g. John)'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
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
              value: selectedAge != null ? "$selectedAge years" : null,
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
                setState(() {
                  selectedAge = getAge(age!);
                });
              },
            ),
            8.verticalSpace,
            SettingsListItem(
              leadingIcon: Icon(LucideIcons.user),
              title: 'Gender',
              value: selectedGender.name.capitalize(),
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
                setState(() {
                  selectedGender = Gender.values[gender!];
                });
              },
            ),
            8.verticalSpace,
            SettingsListItem(
              leadingIcon: Icon(LucideIcons.weight),
              title: 'Weight',
              value: selectedWeight?.toString(),
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
                setState(() {
                  selectedWeight = weight == null ? null : printWeight(weight);
                });
              },
            ),
            8.verticalSpace,
            SettingsListItem(
              leadingIcon: Icon(LucideIcons.ruler),
              title: 'Height',
              value: selectedHeight?.toString(),
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
                setState(() {
                  selectedHeight = (100 + height!).toDouble();
                });
              },
            ),
            Spacer(),
            PrimaryButton(
              title: 'Save',
              onTap: () {
                if (name.isEmpty &&
                    selectedAge == null &&
                    selectedWeight == null &&
                    selectedHeight == null)
                  return;
                widget.onSave(
                  UserCompanion.insert(
                    name: name,
                    age: selectedAge!,
                    gender: selectedGender,
                    height: selectedHeight!,
                    weight: selectedWeight!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
