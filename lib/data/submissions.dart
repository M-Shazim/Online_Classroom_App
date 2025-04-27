

import 'package:online_classroom/data/accounts.dart';
import 'package:online_classroom/data/announcements.dart';
import 'package:online_classroom/data/attachments.dart';
import 'package:online_classroom/data/classrooms.dart';
import 'package:online_classroom/services/submissions_db.dart';

class Submission {
  Account user;
  String dateTime;
  ClassRooms classroom;
  Announcement assignment;
  bool submitted = false;
  List attachments;

  Submission({required this.user, this.dateTime = "", required this.classroom, required this.assignment, this.submitted = false, required this.attachments});
}

List submissionList = [];

// updates the submissionList with DB values
Future<bool> getsubmissionList() async {
  submissionList = [];

  List? jsonList = await SubmissionDB().createSubmissionListDB();
  if (jsonList == null) return false;

  for (var element in jsonList) {
    var data = element.data();

    var user = await getAccount(data["uid"]);
    var classroom = await getClassroom(data["classroom"]);
    var assignment = await getAnnouncement(data["classroom"], data["assignment"]);

    // Skip entries with missing critical data or no assignments
    if (user == null || classroom == null || assignment == null) {
      print("Skipping submission due to nulls:");
      print("  user: $user, classroom: $classroom, assignment: $assignment");
      continue;
    }

    // Handle case where assignment is null (e.g., no assignment in newly added class)
    if (assignment == null) {
      print("No assignment for this classroom. Skipping submission.");
      submissionList.add(
          Submission(
              user: user,
              classroom: classroom,
              assignment: Announcement(
                  user: user,  // You'll need to pass a user here, maybe from the 'user' variable
                  dateTime: DateTime.now().toString(),
                  type: "No Assignment", // Or a default type
                  title: "No Assignment Yet",
                  description: "This class currently has no assignments.",
                  classroom: classroom, // You may need to pass the classroom object here
                  attachments: []  // Empty list for attachments as no assignment is available
              ),
              dateTime: data["dateTime"] ?? "",
              submitted: data["submitted"] ?? false,
              attachments: getAttachmentListForStudent(
                  data["uid"], data["classroom"], data["assignment"]
              )
          )
      );
    } else {
      submissionList.add(
          Submission(
              user: user,
              classroom: classroom,
              assignment: assignment,
              dateTime: data["dateTime"] ?? "",
              submitted: data["submitted"] ?? false,
              attachments: getAttachmentListForStudent(
                  data["uid"], data["classroom"], data["assignment"]
              )
          )
      );
    }
  }

  print("\t\t\t\tGot submissions list");
  return true;
}





// List<Submission> submissionList = [
//   Submission(
//     user: accountList[0],
//     dateTime: 'Aug 25, 8:40 PM',
//     classroom: classRoomList[0],
//     assignment: announcementList[8],
//     submitted: true
//   ),
//   Submission(
//       user: accountList[1],
//       classroom: classRoomList[0],
//       assignment: announcementList[8],
//   ),
// ];