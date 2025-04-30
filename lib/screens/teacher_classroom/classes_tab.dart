import 'package:flutter/material.dart';
import 'package:online_classroom/data/accounts.dart';
import 'package:online_classroom/data/classrooms.dart';
import 'package:online_classroom/screens/teacher_classroom/class_room_page.dart';

class ClassesTab extends StatefulWidget {
  final Account? classTeacher;

  ClassesTab(this.classTeacher);

  @override
  _ClassesTabState createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {

  @override
  void initState() {
    super.initState();
    refreshClasses();
  }


  Future<void> refreshClasses() async {
    await getListClasses(); // this updates the global classRoomList
    setState(() {
      // This will rerun the build method and re-evaluate this line:
      // List _classRoomList = classRoomList.where((...)).toList();
    });
  }




  @override
  Widget build(BuildContext context) {
    List _classRoomList =
        classRoomList.where((i) => i.creator == widget.classTeacher).toList();

    return ListView.builder(
        itemCount: _classRoomList.length,
        itemBuilder: (context, int index) {
          return GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (_) => ClassRoomPage(
                uiColor: _classRoomList[index].uiColor,
                classRoom: _classRoomList[index],
                onClassDeleted: () {
                  setState(() {
                    // After the class is deleted, refresh the list (or remove the deleted class from the list)
                    // _classRoomList.removeAt(index);  // Or refetch the list from the database
                  });
                },
              ),
            ))
                .then((value) {
              if (value == true) {
                // Update UI, refresh the list of classes
                setState(() {
                  // Refresh the class list
                  _classRoomList.removeAt(index); // or however you update the class list
                  refreshClasses();
                });
              }
            }),
            child: Stack(
              children: [
                Container(
                  height: 100,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   fit: BoxFit.cover, image: classRoomList[index].bannerImg,),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: _classRoomList[index].uiColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 30),
                  width: 220,
                  child: Text(
                    _classRoomList[index].className,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 58, left: 30),
                  child: Text(
                    _classRoomList[index].description,
                    style: TextStyle(
                        fontSize: 14, color: Colors.white, letterSpacing: 1),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 80, left: 30),
                  child: Text(
                    _classRoomList[index].creator.firstName! +
                        " " +
                        _classRoomList[index].creator.lastName!,
                    style: TextStyle(
                        fontSize: 12, color: Colors.white54, letterSpacing: 1),
                  ),
                )
              ],
            ),
          );
        });
  }
}
