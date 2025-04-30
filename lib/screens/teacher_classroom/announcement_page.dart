import 'package:flutter/material.dart';
import 'package:online_classroom/data/announcements.dart';
import 'package:online_classroom/data/custom_user.dart';
import 'package:online_classroom/services/announcements_db.dart';
import 'package:online_classroom/services/attachments_db.dart';
import 'package:online_classroom/services/submissions_db.dart';
import 'package:online_classroom/services/updatealldata.dart';
import 'package:online_classroom/widgets/profile_tile.dart';
import 'package:online_classroom/data/submissions.dart';
import 'package:online_classroom/widgets/attachment_composer.dart';
import 'package:online_classroom/screens/teacher_classroom/submission_page.dart';
import 'package:online_classroom/screens/teacher_classroom/announcement_crud/edit_announcement.dart';
import 'package:provider/provider.dart';

class AnnouncementPage extends StatefulWidget {
  Announcement announcement;
  AnnouncementPage({required this.announcement});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {

  List<Widget> buildSubmissions() {
    if (widget.announcement.type == 'Assignment') {
      List submissionsAssigned = submissionList.where((i) => i.assignment == widget.announcement && !i.submitted).toList();
      List submissionsDone = submissionList.where((i) => i.assignment == widget.announcement && i.submitted).toList();
      return [
        if (submissionsDone.isNotEmpty) sectionLabel("Submitted"),
        if (submissionsDone.isNotEmpty) divider(),
        buildSubmissionList(submissionsDone),
        if (submissionsAssigned.isNotEmpty) sectionLabel("Pending"),
        if (submissionsAssigned.isNotEmpty) divider(),
        buildSubmissionList(submissionsAssigned)
      ];
    }
    return [];
  }

  Widget sectionLabel(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: widget.announcement.classroom.uiColor),
    ),
  );

  Widget divider() => Container(
    margin: EdgeInsets.symmetric(horizontal: 15),
    height: 2,
    color: widget.announcement.classroom.uiColor.withOpacity(0.5),
  );

  Widget buildSubmissionList(List submissions) => ListView.builder(
    shrinkWrap: true,
    primary: false,
    itemCount: submissions.length,
    itemBuilder: (context, index) {
      return InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SubmissionPage(
                  submission: submissions[index]))),
          child: Profile(user: submissions[index].user));
    },
  );


  Future<void> deleteAnnouncement() async {
    final user = Provider.of<CustomUser?>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete ${widget.announcement.type}'),
        content: Text('This cannot be undone. Continue?'),
        actions: <Widget>[
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Now show loading after confirmation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    try {
      await AnnouncementDB(user: user).deleteAnnouncements(
          widget.announcement.title, widget.announcement.classroom.className);

      for (var attachment in widget.announcement.attachments) {
        String safeURL = attachment.url.replaceAll(RegExp(r'[^\w\s]+'), '');
        await AttachmentsDB().deleteAttachmentsDB(attachment.name, safeURL);
        await AttachmentsDB().deleteAttachAnnounceDB(
            widget.announcement.title, safeURL);
      }

      if (widget.announcement.type == 'Assignment') {
        for (var student in widget.announcement.classroom.students) {
          await SubmissionDB(user: user).deleteSubmissions(
            student.uid,
            widget.announcement.classroom.className,
            "${widget.announcement.classroom.className}__${widget.announcement.title}",
          );
        }
      }

      await updateAllData();

      Navigator.of(context, rootNavigator: true).pop(); // Close loading
      Navigator.of(context).pop(); // Pop the announcement page
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting: ${e.toString()}")),
      );
    }
  }


  // Future<void> deleteAnnouncement() async {
  //   final user = Provider.of<CustomUser?>(context, listen: false);
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: Text('Delete ${widget.announcement.type}'),
  //       content: Text('This cannot be undone. Continue?'),
  //       actions: <Widget>[
  //         TextButton(
  //           child: Text('Delete', style: TextStyle(color: Colors.red)),
  //           onPressed: () async {
  //             await AnnouncementDB(user: user).deleteAnnouncements(
  //                 widget.announcement.title, widget.announcement.classroom.className);
  //             for (var attachment in widget.announcement.attachments) {
  //               String safeURL = attachment.url.replaceAll(RegExp(r'[^\w\s]+'), '');
  //               await AttachmentsDB().deleteAttachmentsDB(attachment.name, safeURL);
  //               await AttachmentsDB().deleteAttachAnnounceDB(
  //                   widget.announcement.title, safeURL);
  //             }
  //             if (widget.announcement.type == 'Assignment') {
  //               for (var student in widget.announcement.classroom.students) {
  //                 await SubmissionDB(user: user).deleteSubmissions(
  //                   student.uid,
  //                   widget.announcement.classroom.className,
  //                   "${widget.announcement.classroom.className}__${widget.announcement.title}",
  //                 );
  //               }
  //             }
  //             await updateAllData();
  //             Navigator.of(context)..pop()..pop();
  //           },
  //         ),
  //         TextButton(
  //           child: Text('Cancel'),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              widget.announcement.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.announcement.classroom.uiColor,
              ),
            ),
            if (widget.announcement.type == 'Assignment')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Due ${widget.announcement.dueDate}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            SizedBox(height: 8),
            Divider(color: widget.announcement.classroom.uiColor, thickness: 2),
            SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                  AssetImage(widget.announcement.user.userDp),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.announcement.user.firstName} ${widget.announcement.user.lastName}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Last updated ${widget.announcement.dateTime}",
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 16),
            Text(
              widget.announcement.description,
              style: TextStyle(fontSize: 16),
            ),
            if (widget.announcement.attachments.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                "Attachments:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              AttachmentComposer(widget.announcement.attachments),
            ],
            SizedBox(height: 10),
            ...buildSubmissions(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditAnnouncement(announcement: widget.announcement),
                ),
              ).then((_) => setState(() {
                widget.announcement = getAnnouncement(
                    widget.announcement.classroom.className,
                    widget.announcement.title)!;
              }));
            },
            backgroundColor: widget.announcement.classroom.uiColor,
            child: Icon(Icons.edit, color: Colors.white),
            heroTag: null,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: deleteAnnouncement,
            // async {
            //   showDialog(
            //     context: context,
            //     barrierDismissible: false,
            //     builder: (_) => Center(child: CircularProgressIndicator()),
            //   );
            //
            //   try {
            //     await deleteAnnouncement();
            //     Navigator.of(context, rootNavigator: true).pop(); // hide loading
            //     Navigator.of(context).pop(); // go back after delete
            //   } catch (e) {
            //     Navigator.of(context, rootNavigator: true).pop(); // hide loading
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('Delete failed: ${e.toString()}')),
            //     );
            //   }
            // },

            backgroundColor: widget.announcement.classroom.uiColor,
            child: Icon(Icons.delete, color: Colors.white),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:online_classroom/data/announcements.dart';
// import 'package:online_classroom/data/custom_user.dart';
// import 'package:online_classroom/services/announcements_db.dart';
// import 'package:online_classroom/services/attachments_db.dart';
// import 'package:online_classroom/services/submissions_db.dart';
// import 'package:online_classroom/services/updatealldata.dart';
// import 'package:online_classroom/widgets/profile_tile.dart';
// import 'package:online_classroom/data/submissions.dart';
// import 'package:online_classroom/widgets/attachment_composer.dart';
// import 'package:online_classroom/screens/teacher_classroom/submission_page.dart';
// import 'package:online_classroom/screens/teacher_classroom/announcement_crud/edit_announcement.dart';
// import 'package:provider/provider.dart';
//
// class AnnouncementPage extends StatefulWidget {
//   Announcement announcement;
//
//   AnnouncementPage({required this.announcement});
//
//   @override
//   _AnnouncementPageState createState() => _AnnouncementPageState();
// }
//
// class _AnnouncementPageState extends State<AnnouncementPage> {
//
//   List<Widget> buildSubmissions() {
//     if(widget.announcement.type == 'Assignment') {
//       List submissionsAssigned = submissionList.where((i) => i.assignment == widget.announcement && !i.submitted).toList();
//       List submissionsDone = submissionList.where((i) => i.assignment == widget.announcement && i.submitted).toList();
//       return [
//         if(submissionsDone.length > 0) Container(
//           padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
//           child: Text(
//             "Submitted",
//             style: TextStyle(
//                 fontSize: 20,
//                 color: widget.announcement.classroom.uiColor,
//                 letterSpacing: 1),
//           ),
//         ),
//         if(submissionsDone.length > 0) Container(
//           margin: EdgeInsets.only(left: 15),
//           width: MediaQuery
//               .of(context)
//               .size
//               .width - 30,
//           height: 2,
//           color: widget.announcement.classroom.uiColor,
//         ),
//         Container(
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 primary: false,
//                 itemCount: submissionsDone.length,
//                 itemBuilder: (context, int index) {
//                   return InkWell(
//                       onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                           builder: (_) => SubmissionPage(
//                               submission:  submissionsDone[index]
//                           ))),
//                       child: Profile(
//                           user: submissionsDone[index].user
//                       ));
//                 })
//         ),
//         if(submissionsAssigned.length > 0) Container(
//           padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
//           child: Text(
//             "Pending",
//             style: TextStyle(
//                 fontSize: 20,
//                 color: widget.announcement.classroom.uiColor,
//                 letterSpacing: 1),
//           ),
//         ),
//         if(submissionsAssigned.length > 0) Container(
//           margin: EdgeInsets.only(left: 15),
//           width: MediaQuery
//               .of(context)
//               .size
//               .width - 30,
//           height: 2,
//           color: widget.announcement.classroom.uiColor,
//         ),
//         Container(
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 primary: false,
//                 itemCount: submissionsAssigned.length,
//                 itemBuilder: (context, int index) {
//                   return Profile(
//                           user: submissionsAssigned[index].user
//                       );
//                 })
//         )
//       ];
//     }
//     return [];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<CustomUser?>(context);
//
//     Future<void> deleteAnnouncement() async {
//       return showDialog<void>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Delete '+ widget.announcement.type),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   Text('This cannot be undone. Continue?'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('Delete', style: TextStyle(color: Colors.red)),
//                 onPressed: () async {
//                   print('Deleted');
//
//                   await AnnouncementDB(user: user).deleteAnnouncements(widget.announcement.title, widget.announcement.classroom.className);
//
//                   for(int i=0; i<widget.announcement.attachments.length; i++) {
//                     var attachment = widget.announcement.attachments[i];
//                     String safeURL = attachment.url.replaceAll(new RegExp(r'[^\w\s]+'),'');
//                     AttachmentsDB().deleteAttachmentsDB(attachment.name, safeURL);
//
//                     print("Deleted attachment");
//
//                     AttachmentsDB().deleteAttachAnnounceDB(widget.announcement.title, safeURL);
//                     print("Deleted reference to attachment on announcement");
//                   }
//
//                   if(widget.announcement.type == 'Assignment') {
//                     List students = widget.announcement.classroom.students;
//                     for (int index = 0; index <
//                         students.length; index++) {
//                       await SubmissionDB(user: user).deleteSubmissions(students[index].uid,
//                           widget.announcement.classroom.className,
//                           widget.announcement.classroom.className+"__"+widget.announcement.title);
//                     }
//                   }
//
//                   await updateAllData();
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text('Cancel'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//
//     return Scaffold(
//       body: ListView(
//           //crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.only(top: 50, left: 15, bottom: 10),
//               child: Text(
//                 widget.announcement.title,
//                 style: TextStyle(
//                     fontSize: 25, color: widget.announcement.classroom.uiColor, letterSpacing: 1),
//               ),
//             ),
//             if(widget.announcement.type == 'Assignment') Container(
//               padding: EdgeInsets.only(left: 15, bottom: 10),
//               child: Text(
//                 "Due " + widget.announcement.dueDate,
//                 style: TextStyle(
//                     fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 15),
//               width: MediaQuery.of(context).size.width - 30,
//               height: 2,
//               color: widget.announcement.classroom.uiColor,
//             ),
//             Container(
//                 margin: EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(width: 10),
//                             CircleAvatar(
//                               backgroundImage:
//                               AssetImage("${widget.announcement.user.userDp}"),
//                             ),
//                             SizedBox(width: 10),
//                             Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     widget.announcement.user.firstName! + " " + widget.announcement.user.lastName!,
//                                     style: TextStyle(),
//                                   ),
//                                   Text(
//                                     "Last updated " + widget.announcement.dateTime,
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ]),
//                           ],
//                         )
//                       ],
//                     ),
//                     Container(
//                         width: MediaQuery
//                             .of(context)
//                             .size
//                             .width - 40,
//                         margin:
//                         EdgeInsets.only(top: 15),
//                         child: Text(widget.announcement.description)
//                     )
//                   ],
//                 )
//             ),
//             SizedBox(width: 10),
//             widget.announcement.attachments.isNotEmpty ? Padding(
//                 padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
//                 child: Text(
//                   "Attachments:",
//                   style: TextStyle(
//                       fontSize: 15, color: Colors.black, letterSpacing: 1, fontWeight: FontWeight.bold),
//                 )
//             ) : Container(),
//             AttachmentComposer(widget.announcement.attachments),
//           ] + buildSubmissions()
//       ),
//       floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => EditAnnouncement(announcement: widget.announcement),
//                     )).then((_) => setState(() {widget.announcement = getAnnouncement(widget.announcement.classroom.className, widget.announcement.title)!;}));
//               },
//               backgroundColor: widget.announcement.classroom.uiColor,
//               child: Icon(
//                 Icons.edit,
//                 color: Colors.white,
//                 size: 32,
//               ),
//               heroTag: null,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             FloatingActionButton(
//               onPressed: () => deleteAnnouncement(),
//               backgroundColor: widget.announcement.classroom.uiColor,
//               child: Icon(
//                 Icons.delete,
//                 color: Colors.white,
//                 size: 32,
//               ),
//               heroTag: null,
//             )
//           ]
//       )
//     );
//   }
// }
