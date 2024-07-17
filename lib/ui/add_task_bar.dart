import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/controllers/task_controller.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/ui/profile_page.dart';
import 'package:to_do_list/ui/theme.dart';
import 'package:to_do_list/ui/widgets/button.dart';
import 'package:to_do_list/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : darkGreyClr,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add Task", style: headingStyle),
              MyInputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value!,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(label: "Create Task", onTap: _validateData),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: Icon(Icons.warning_amber_rounded),
      );
    }
  }

  void _addTaskToDb() async {
    try {
      String taskId = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0, // Initial value for completion status
        ),
      );
      print("Task added with ID: $taskId");
    } catch (e) {
      print("Error adding task: $e");
      // Handle error, e.g., show snackbar
    }
  }

  Widget _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
                (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                        ? pinkClr
                        : yellowClr,
                    child: _selectedColor == index
                        ? Icon(Icons.done, color: Colors.white, size: 16)
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : darkGreyClr,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
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

  Future<void> _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        print(_selectedDate);
      });
    } else {
      print("Date selection canceled");
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);
      if (isStartTime) {
        setState(() {
          _startTime = formattedTime;
        });
      } else {
        setState(() {
          _endTime = formattedTime;
        });
      }
    } else {
      print("Time selection canceled");
    }
  }
}
