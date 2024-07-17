import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/controllers/task_controller.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/services/notification_services.dart';
import 'package:to_do_list/services/theme_services.dart';
import 'package:get/get.dart';
import 'package:to_do_list/ui/add_task_bar.dart';
import 'package:to_do_list/ui/profile_page.dart';
import 'package:to_do_list/ui/theme.dart';
import 'package:to_do_list/ui/widgets/button.dart';
import 'package:to_do_list/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : darkGreyClr,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10),
          _showTasks(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];

            // Schedule notifications for daily repeating tasks
            if (task.repeat == 'Daily') {
              var startTime = task.startTime.toString(); // Assuming startTime is in "5:15 PM" format

              // Parse start time
              var parsedStartTime = DateFormat("h:mm a").parse(startTime);

              // Extract hours and minutes from start time
              int hours = parsedStartTime.hour;
              int minutes = parsedStartTime.minute;

              // Schedule notification for daily tasks
              notifyHelper.scheduledNotification(hours, minutes, task);
            } else if (task.startTime != null && task.remind != null) {
              // If task has a specific start time and a remind time
              var startTime = DateFormat("h:mm a").parse(task.startTime!);
              var remindTime = Duration(minutes: task.remind!);

              // Calculate notification time
              var notificationTime = startTime.subtract(remindTime);

              // Schedule notification
              notifyHelper.scheduledNotification(notificationTime.hour, notificationTime.minute, task);
            }

            // Display tasks based on their repeat type and selected date
            if (_shouldShowTask(task)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, task);
                      },
                      child: TaskTile(task),
                    ),
                  ),
                ),
              );
            } else {
              return Container(); // Return empty container if task doesn't match criteria
            }
          },
        );
      }),
    );
  }


  bool _shouldShowTask(Task task) {
    DateTime taskDate = DateFormat.yMd().parse(task.date!); // Parse task date

    // Check if the task should be displayed based on its repeat type
    switch (task.repeat) {
      case 'Daily':
        return true; // Show daily tasks every day
      case 'Weekly':
        return taskDate.weekday == _selectedDate.weekday; // Show weekly tasks on the same weekday
      case 'Monthly':
        return taskDate.day == _selectedDate.day; // Show monthly tasks on the same day of the month
      case 'Yearly':
        return taskDate.month == _selectedDate.month &&
            taskDate.day == _selectedDate.day; // Show yearly tasks on the same day of the year
      default:
      // Show tasks only for the selected date
        return taskDate.year == _selectedDate.year &&
            taskDate.month == _selectedDate.month &&
            taskDate.day == _selectedDate.day;
    }
  }

  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 120,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
            _taskController.getTasks();
          });
        },
      ),
    );
  }

  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

   _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : darkGreyClr,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode ? "Activated Light Theme" : "Activated Dark Theme",
          );
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.to(() => ProfilePage());
          },
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.jpg"),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4, left: 20, right: 20),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
              label: "Task Completed",
              onTap: () {
                _taskController.markTaskCompleted(task);
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
              context: context,
              isClose: true,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    required BuildContext context,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
