import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../routes/app_routes.dart';


class TaskDetail {
  final String title;
  final String code;
  final String location;
  final String startDate;
  final String endDate;
  final int daysLeft;
  final String pendingWork;
  final double progress;

  TaskDetail({
    required this.title,
    required this.code,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.daysLeft,
    required this.pendingWork,
    required this.progress,
  });
}

class ErpAssignedTasksDetailes extends StatefulWidget {
  const ErpAssignedTasksDetailes({super.key});

  @override
  State<ErpAssignedTasksDetailes> createState() =>
      _ErpAssignedTasksDetailesState();
}

class _ErpAssignedTasksDetailesState extends State<ErpAssignedTasksDetailes> {
  List<TaskDetail> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() {
    // Simulated API response
    setState(() {
      tasks = [
        TaskDetail(
          title: "Machinery Work",
          code: "GG.1.1.44",
          location: "📍 WING A > FLOOR 1 ~ CENTERING WORK PHASE",
          startDate: "10/02/2025",
          endDate: "15/02/2025",
          daysLeft: 30,
          pendingWork: "20 ft pending",
          progress: 0.2,
        ),
        TaskDetail(
          title: "Concrete Work",
          code: "GG.1.1.45",
          location: "📍 WING B > FLOOR 2 ~ FOUNDATION WORK",
          startDate: "12/03/2025",
          endDate: "18/03/2025",
          daysLeft: 25,
          pendingWork: "15 ft pending",
          progress: 0.4,
        ),
        TaskDetail(
          title: "Electrical Work",
          code: "GG.1.1.46",
          location: "📍 WING C > FLOOR 3 ~ WIRING INSTALLATION",
          startDate: "05/04/2025",
          endDate: "10/04/2025",
          daysLeft: 20,
          pendingWork: "10 ft pending",
          progress: 0.6,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const FaIcon(
                  FontAwesomeIcons.listCheck, // Best icon for a pie chart
                  color: AppColors.primary, // Customize color
                  size: 15, // Adjust size as needed
                ),
                const SizedBox(width: AppDefaults.padding_2),
                Text(
                  "Tasks",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: AppDefaults.padding_2),
                Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "20",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ))
              ]),
              // const Text("View More")
            ],
          ),
        ),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return _buildTaskCard(tasks[index]);
            },
          ),
        )
      ],
    );
  }

  Widget _buildTaskCard(TaskDetail task) {
    return GestureDetector(
      onTap: () {
       // Navigator.pushNamed(context, AppRoutes.erpDprEntry);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: AppDefaults.boxShadow,
            border: Border.all(color: AppColors.gray)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.code,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDefaults.padding_2),

              // Location
              Text(
                task.location,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),

              // const SizedBox(height: AppDefaults.padding_2),

              // // Start & End Dates
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildDate("Start", task.startDate, Colors.green),
              //     _buildDate("End", task.endDate, Colors.red),
              //   ],
              // ),

              const SizedBox(height: AppDefaults.padding_2),

              // Remaining Days & Pending Work
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _infoBox(Icons.timer, "${task.daysLeft} Days Left",
              //         AppColors.primary),
              //     _infoBox(Icons.work_outline, task.pendingWork, Colors.blueGrey),
              //   ],
              // ),

              const SizedBox(height: AppDefaults.padding_2),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoBox(Icons.timer, "${task.daysLeft} Days Left",
                        AppColors.primary),
                    const SizedBox(width: AppDefaults.padding_2),
                    _bindProgressBar(task.progress)
                  ],
                ),
              ),

              // Progress Bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _bindProgressBar(double progress) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(),
              ),
              Text(
                "${(progress * 100).toStringAsFixed(2)}% Completed",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(),
              ),
            ],
          ),
          const SizedBox(height: AppDefaults.padding_2),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppDefaults.padding_2,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          // const SizedBox(height: 4),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Text(
          //     "${(progress * 100).toStringAsFixed(2)}% Completed",
          //     style: const TextStyle(
          //       color: AppColors.primary,
          //       fontSize: 12,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildDate(String label, String date, Color color) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         label,
  //         style: Theme.of(context).textTheme.labelSmall?.copyWith(
  //             color: Colors.grey.shade600, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(width: AppDefaults.padding_2),
  //       Text(
  //         date,
  //         style: Theme.of(context)
  //             .textTheme
  //             .labelSmall
  //             ?.copyWith(color: color, fontWeight: FontWeight.w600),
  //       ),
  //     ],
  //   );
  // }

  Widget _infoBox(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.only(right: AppDefaults.padding_2),
      decoration: BoxDecoration(
          border: Border(
        right: BorderSide(
          color: AppColors.gray,
          width: 1.0,
        ),
      )),
      child: Row(
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(),
          ),
        ],
      ),
    );
  }
}
