import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentapp_provider/core/constants.dart';
import 'package:studentapp_provider/functions/student_controller.dart';
import 'package:studentapp_provider/model/modelstudent.dart';
import 'package:studentapp_provider/screens/add_edit/add_student.dart';
import 'package:studentapp_provider/screens/home/widgets/search_widget.dart';
import 'package:studentapp_provider/screens/profile.dart';
import 'package:studentapp_provider/screens/widgets/circle_image_widget.dart';

final StudentController studentViewController = Get.put(StudentController());
  final TextEditingController searchController = TextEditingController();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    studentViewController.getStudents('');

    return Scaffold(
        appBar: AppBar(
          title: Text("students"),
        ),
        body: SafeArea(
            child: Column(
          children: [
            const Padding(
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
              child: SearchFieldWidget(searchController: searchController),
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

class ListViewHome extends StatelessWidget {
  ListViewHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<StudentController>(
      builder: (controller) {
        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          shrinkWrap: true,
          itemCount: controller.studentList.length,
          itemBuilder: (context, index) {
            final studentdata = controller.studentList[index];

            return ListTile(
              onTap: () {
                Get.to(ProfileTile(model: studentdata));
              },
              leading: CircleImageWidget(
                radius: 40,
                image: controller.studentList[index].image,
              ),
              title: Text(controller.studentList[index].name),
              subtitle: Text(controller.studentList[index].department!),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.to(AddEditScreen(
                          action: ActionType.edit,
                          model: studentdata,
                        ));

                        setData(controller.studentList[index]);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        controller.deleteModel(studentdata.id!);
                        Get.snackbar("Deleted Sucessfully", " ",
                            backgroundColor: Colors.red,
                            colorText: kWhite,
                            snackPosition: SnackPosition.BOTTOM);
                      },
                      icon: Icon(Icons.delete)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

setData(Student model) {
  nameController.text = model.name;
  ageController.text = model.age;
  departmentController.text = model.department!;
  phoneController.text = model.phone;
  image.value = model.image != null ? File(model.image!) : null;
}
