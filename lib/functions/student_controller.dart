import 'package:get/get.dart';
import 'package:studentapp_provider/functions/dbfunctions.dart';
import 'package:studentapp_provider/model/modelstudent.dart';

class StudentController extends GetxController {
  HiveDb hive = HiveDb();

  List<Student> studentList = <Student>[].obs;

  Future<void> getStudents(String name) async {
    List<Student> tempList = await hive.getData();

    studentList = tempList
        .where((model) => model.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  Future<void> addOrEdit(Student model, bool toEdit) async {
    toEdit ? await editModel(model) : await addModel(model);
  }

  Future<void> deleteModel(int id) async {
    await hive.deleteData(id);
    await getStudents('');
  }

  Future<void> addModel(Student model) async {
    await hive.insertInToDb(model);
    await getStudents('');
    print("adeddd");
  }

  Future<void> editModel(Student model) async {
    await hive.updateTable(model);
    await getStudents('');
    print("updatedddd");
  }
}
