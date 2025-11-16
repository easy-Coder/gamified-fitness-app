import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/common/widgets/measure_modal_sheet.dart';
import 'package:gamified/src/common/widgets/settings_list_item.dart';
import 'package:gamified/src/features/account/data/user_repository.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:gamified/src/features/account/schema/user.dart' show Gender;
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final formKey = GlobalKey<ShadFormState>();
  late final TextEditingController nameController;
  UserDTO? _user;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userRepo = ref.read(userRepoProvider);
    final user = await userRepo.getUser();
    setState(() {
      _user = user ?? UserDTO.empty();
      nameController.text = _user!.name;
      _isLoading = false;
    });
  }

  Future<void> _saveUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final userRepo = ref.read(userRepoProvider);
      await userRepo.updateUser(_user!);
      
      if (mounted) {
        context.pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton(
          leading: Icon(LucideIcons.arrowLeft, size: 24),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          onPressed: () => context.pop(),
          decoration: ShadDecoration(shape: BoxShape.circle),
        ),
        title: Text(
          'Edit Profile',
          style: theme.textTheme.large,
        ),
        titleTextStyle: theme.textTheme.large,
        actions: [
          if (_isSaving)
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveUser,
              child: Text(
                'Save',
                style: theme.textTheme.h4.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: ShadForm(
                key: formKey,
                child: ListView(
                  children: [
                    ShadInputFormField(
                      id: 'name',
                      label: Text('Name'),
                      placeholder: Text('Name (e.g. John)'),
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {
                          _user = _user!.copyWith(name: value);
                        });
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Name is required.';
                        }
                        if (v.length < 2) {
                          return 'Name must be at least 2 characters.';
                        }
                        if (v.length > 50) {
                          return 'Name must not be over 50 characters.';
                        }
                        return null;
                      },
                    ),
                    16.verticalSpace,
                    SettingsListItem(
                      leadingIcon: Icon(LucideIcons.cake),
                      title: 'Age',
                      value: _user!.age != 0 ? "${_user!.age} years" : null,
                      onTap: () async {
                        int getAge(int index) => DateTime.now().year - (1940 + index);
                        final age = await MeasureModalSheet.showModalSheet<int>(
                          context,
                          MeasureModalSheet(
                            title: 'Select Your Age',
                            itemCount: DateTime.now().year - 1940 + 1,
                            builder: (context, index, currentIndex) => Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${getAge(index)}',
                                style: theme.textTheme.small.copyWith(
                                  color: index == currentIndex ? Colors.white : null,
                                ),
                              ),
                            ),
                          ),
                        );
                        if (age != null && mounted) {
                          setState(() {
                            _user = _user!.copyWith(age: getAge(age));
                          });
                        }
                      },
                    ),
                    8.verticalSpace,
                    SettingsListItem(
                      leadingIcon: Icon(LucideIcons.user),
                      title: 'Gender',
                      value: _user!.gender.name.capitalize(),
                      onTap: () async {
                        final gender = await MeasureModalSheet.showModalSheet<int>(
                          context,
                          MeasureModalSheet(
                            title: 'Select Your Gender',
                            itemCount: Gender.values.length,
                            builder: (BuildContext context, int index, int currentIndex) =>
                                Container(
                              alignment: Alignment.center,
                              child: Text(
                                Gender.values[index].name.capitalize(),
                                style: theme.textTheme.small.copyWith(
                                  color: index == currentIndex ? Colors.white : null,
                                ),
                              ),
                            ),
                          ),
                        );
                        if (gender != null && mounted) {
                          setState(() {
                            _user = _user!.copyWith(gender: Gender.values[gender]);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

