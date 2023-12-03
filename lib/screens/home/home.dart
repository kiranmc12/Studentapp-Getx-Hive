import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentapp_provider/functions/student_controller.dart';
import 'package:studentapp_provider/screens/add_edit/add_student.dart';
import 'package:studentapp_provider/screens/home/widgets/search_widget.dart';
import 'package:studentapp_provider/screens/widgets/circle_image_widget.dart';

final StudentController studentViewController = Get.put(StudentController());

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("students"),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Search Students",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: SearchFieldWidget(),
            ),
            Expanded(
              child: ListViewHome(),
            ),
          ],
        )),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditScreen(action: ActionType.add)));
            },
            label: Icon(Icons.add)));
  }
}

class ListViewHome extends GetView {
  ListViewHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
   studentViewController.getStudents('');
    return GetX<StudentController>(
      builder: (controller) {
        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          shrinkWrap: true,
          itemCount: controller.studentList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleImageWidget(
                radius: 40,
                image:
                    controller.studentList[index].image,
              ),
              title: Text(controller.studentList[index].name),
              subtitle: Text(controller.studentList[index].department!),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEditScreen(
                                    action: ActionType.edit,
                                    model: controller.studentList[index])));
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(onPressed: () {

                  }, icon: Icon(Icons.delete)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
