import 'package:flutter/material.dart';
import 'package:online_classroom/data/accounts.dart';
import 'package:online_classroom/data/announcements.dart';
import 'package:online_classroom/data/custom_user.dart';
import 'package:online_classroom/screens/student_classroom/announcement_page.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimelineTab extends StatefulWidget {
  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> {

  Future<List<String>> fetchStudentClasses(String uid) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance.collection('Students').doc(uid).get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data();
        print('Student data: $data');
        return List<String>.from(data?['classes'] ?? []);
      } else {
        print('No student data found for UID: $uid');
        return [];
      }
    } catch (e) {
      print('Error fetching student classes: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    if (user == null) {
      return Center(child: Text('User not found'));
    }

    String userId = user?.uid ?? ""; // Default to empty string if user.uid is null
    print("in timeline"+userId);

    return FutureBuilder<List<String>>(
      future: fetchStudentClasses(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No classes found for this student.'));
        }

        List<String> joinedClasses = snapshot.data!;
        print('Joined classes: $joinedClasses');

        // Filter classwork based on joined classes
        List classWorkList = announcementList.where((announcement) {
          return announcement.type == "Assignment" &&
              joinedClasses.contains(announcement.classroom.className);
        }).toList();

        if (classWorkList.isEmpty) {
          return Center(child: Text('No classwork found for the joined classes.'));
        }

        return ListView.builder(
          itemCount: classWorkList.length,
          itemBuilder: (context, int index) {
            return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AnnouncementPage(
                  announcement: classWorkList[index],
                ),
              )),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: classWorkList[index].classroom.uiColor,
                        ),
                        child: Icon(
                          Icons.assignment,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classWorkList[index].title,
                            style: TextStyle(letterSpacing: 1),
                          ),
                          Text(
                            classWorkList[index].classroom.className,
                            style: TextStyle(color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "Due " + classWorkList[index].dueDate,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
