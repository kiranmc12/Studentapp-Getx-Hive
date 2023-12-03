import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentapp_provider/core/colors.dart';
import 'package:studentapp_provider/core/constants.dart';
import 'package:studentapp_provider/functions/student_controller.dart';
import 'package:studentapp_provider/functions/validator_functions.dart';
import 'package:studentapp_provider/model/modelstudent.dart';
import 'package:studentapp_provider/screens/home/home.dart';

ValueNotifier<File?> image = ValueNotifier<File?>(null);

final TextEditingController nameController = TextEditingController();
final TextEditingController departmentController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final formKey = GlobalKey<FormState>();

enum ActionType {
  add,
  edit,
}

class AddEditScreen extends StatelessWidget {
  final Student? model;
  final ActionType action;

  AddEditScreen({Key? key, required this.action,  this.model}) : super(key: key);

  void clear() {
    nameController.clear();
    ageController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(action == ActionType.add ? "Add Student" : "Edit Student"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      await pickImage();
                    },
                    child: ValueListenableBuilder(
                      valueListenable: image,
                      builder: (context, value, child) {
                        return CircleAvatar(
                          backgroundColor: kBlack,
                          radius: 30,
                          child: image.value != null
                              ? ClipOval(
                                  child: Image.file(
                                    File(image.value!.path),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.image,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                        );
                      },
                    ),
                  ),
                  kHeight,
                  TextFormItem(
                    label: "Student Name",
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    validator: validateName,
                  ),
                  kHeight,
                  TextFormItem(
                    label: "Department",
                    controller: departmentController,
                    keyboardType: TextInputType.name,
                    validator: validateDepartment,
                  ),
                  kHeight,
                  TextFormItem(
                    label: "Age",
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    validator: validateAge,
                  ),
                  kHeight,
                  TextFormItem(
                    label: "Phone Number",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator:
                        validatePhone, // Ensure validatePhone is imported correctly
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (image.value == null) {
                        Get.snackbar("Image Required", "Please add an image");
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        final student = Student(
                          id: model?.id,
                          image: image.value?.path,
                          age: ageController.text,
                          name: nameController.text,
                          phone: phoneController.text,
                          department: departmentController.text,
                        );

                        await studentViewController
                            .addOrEdit(student, action == ActionType.edit);

                        clear();
                      }
                    },
                    child: Text(action == ActionType.add ? "Add" : "Update"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      image.value = File(img.path);
    }
  }
}

class TextFormItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const TextFormItem({
    Key? key,
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator,
    );
  }
}
