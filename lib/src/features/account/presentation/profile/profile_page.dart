import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double titleVisibility = 0.0;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          double progress =
              notification.metrics.pixels /
              notification.metrics.maxScrollExtent;

          if (!progress.isNaN) {
            setState(() {
              if (progress <= 0.2) {
                titleVisibility = 0.0;
              } else if (progress >= 0.6) {
                titleVisibility = 1.0;
              } else {
                // Linear interpolation between 0.2 and 0.4
                titleVisibility = ((progress - 0.2) / 0.2).clamp(0.0, 1.0);
              }
            });
          } else {
            setState(() {
              titleVisibility = 0.0;
            });
          }
        }
        return true;
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Opacity(
              opacity: titleVisibility,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    // backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder
                  ),
                  8.horizontalSpace,
                  Text(
                    "John Doe",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(LucideIcons.settings),
                ),
              ),
            ],
            pinned: true,
            scrolledUnderElevation: 0,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    // backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder
                  ),
                  10.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          4.horizontalSpace,
                          GestureDetector(child: Icon(LucideIcons.pen)),
                        ],
                      ),
                      Text(
                        'Age: 22',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: 20.verticalSpace),
          SliverToBoxAdapter(child: Divider()),
          ProfileItem(
            leading: Icon(LucideIcons.user),
            title: 'Edit Profile',
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          SliverToBoxAdapter(child: 10.verticalSpace),
          ProfileItem(
            leading: Icon(LucideIcons.rulerDimensionLine),
            title: 'Measurements',
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          SliverToBoxAdapter(child: 10.verticalSpace),
          ProfileItem(
            leading: Icon(LucideIcons.dumbbell),
            title: 'Workout History',
            child: Column(
              children: [Divider(), WorkoutHistoryCard(), WorkoutHistoryCard()],
            ),
          ),
          SliverToBoxAdapter(child: 70.verticalSpace),
        ],
      ),
    );
  }
}

class WorkoutHistoryCard extends StatefulWidget {
  const WorkoutHistoryCard({super.key});

  @override
  State<WorkoutHistoryCard> createState() => _WorkoutHistoryCardState();
}

class _WorkoutHistoryCardState extends State<WorkoutHistoryCard> {
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Workout Plan 1",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          4.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "2:40",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  2.verticalSpace,
                  Text("Durations"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "300 kg",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  2.verticalSpace,
                  Text("Total Weight"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "10",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  2.verticalSpace,
                  Text("Total Sets"),
                ],
              ),
            ],
          ),
          ..._buildExerciseHistory(),
        ],
      ),
    );
  }

  List<Widget> _buildExerciseHistory() {
    final exercise = [
      Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            8.horizontalSpace,
            Text("4 sets of work exercise", style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            8.horizontalSpace,
            Text("4 sets of work exercise", style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            8.horizontalSpace,
            Text("4 sets of work exercise", style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            8.horizontalSpace,
            Text("4 sets of work exercise", style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ),
    ];
    return (showAll || exercise.length < 3)
        ? [
            ...exercise,
            if (exercise.length > 2)
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: Colors.grey.shade50,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      "Show Less",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ),
          ]
        : [
            ...exercise.sublist(0, 2),
            if (exercise.length > 2)
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: Colors.grey.shade50,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      "Show More",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ),
          ];
  }
}

class ProfileItem extends StatelessWidget {
  final Icon leading;

  final String title;

  final Widget? trailing;
  final Widget? child;

  const ProfileItem({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: child == null ? 35.h : null,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: IconTheme(
          data: IconThemeData(size: 18),
          child: child == null
              ? _buildHeadingRow()
              : Column(children: [_buildHeadingRow(), ?child]),
        ),
      ),
    );
  }

  Row _buildHeadingRow() {
    return Row(
      children: [
        leading,
        16.horizontalSpace,
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Spacer(),
        ?trailing,
      ],
    );
  }
}
