import 'package:csi_app/apis/FireStoreAPIs/UserControl.dart';
import 'package:csi_app/models/user_model/AppUser.dart';
import 'package:flutter/material.dart';
import '../../../apis/FireStoreAPIs/UserProfileAPI.dart';
import '../../../apis/notification_apis/notifications_api.dart';
import '../../../models/notification_model/Announcement.dart';
import '../../colors.dart';
import '../../helper_functions/function.dart';

class AdminCard extends StatefulWidget {
  final AppUser appUser;
  final AppUser currentUser;

 const AdminCard({super.key, required this.appUser, required this.currentUser});

  @override
  State<AdminCard> createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: (widget.currentUser.isSuperuser ?? false) ?() {
        bottomSheet(context);
      } : (){},
      child: Card(
        elevation: 0,
        color: AppColors.theme['secondaryColor'],
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.theme['primaryColor'],
            child: Text(HelperFunctions.getInitials(widget.appUser.name ?? "A B"),style:TextStyle(color:AppColors.theme['secondaryColor'])),
          ),
          title: Text("${widget.appUser.name}"),
          subtitle: Text("${widget.appUser.about}"),
        ),
      ),
    );
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.theme['secondaryColor'],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 60,
              child:Text(HelperFunctions.getInitials(widget.appUser.name ?? "A B"), style: TextStyle(
                  color: AppColors.theme['secondaryColor'],
                  fontWeight: FontWeight.bold,fontSize: 40)),
              backgroundColor: AppColors.theme['primaryColor'],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                widget.appUser.name ?? "",
                style: TextStyle(
                    color: AppColors.theme['tertiaryColors'],
                    fontWeight: FontWeight.bold,fontSize: 25),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
                title: Text(
                  "Promote to Super User",
                  style: TextStyle(
                      color: AppColors.theme['tertiaryColors'],
                      fontWeight: FontWeight.bold),
                ),
                trailing: Material(
                  borderRadius: BorderRadius.circular(
                      10), // Adjust border radius as needed
                  color: Colors.blue, // Change background color
                  child: InkWell(
                    onTap: () async {
                      bool succ = await UserControl.makeSuperuser(widget.appUser.userID, widget.currentUser.userID);
                      if(succ){
                        HelperFunctions.showToast("${widget.appUser.name} has been promoted to superuser");
                        await NotificationApi.sendPushNotification(widget.appUser, "You has been promoted to superuse,\n Note : Please Restart Application for getting super user's controlr", widget.currentUser);

                        String encodedMessage = HelperFunctions.stringToBase64("You has been promoted to superuser,\n Note : Please Restart Application for getting super user's control");

                        Announcement announcement  = Announcement(
                            message: encodedMessage,
                            fromUserId: widget.currentUser.userID,
                            toUserId: widget.appUser.userID,
                            time: DateTime.now().millisecondsSinceEpoch.toString(),
                            fromUserName: widget.currentUser.name
                        );

                        await NotificationApi.storeNotification(announcement, true) ;

                        widget.currentUser.notificationCount = widget.currentUser.notificationCount ?? 0 + 1 ;
                        Map<String, dynamic> fields = {"notificationCount":widget.currentUser.notificationCount};
                        // await UserProfile.updateUserProfile(widget.appUser.userID, fields) ;
                        // setState(() {
                        //
                        // });
                      }
                      else{
                        HelperFunctions.showToast("Unable to promote at the moment");
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.theme['primaryColor'],
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "Promote",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                "Remove from Admin",
                style: TextStyle(
                    color: AppColors.theme['tertiaryColors'],
                    fontWeight: FontWeight.bold),
              ),
              trailing: Material(
                borderRadius:
                BorderRadius.circular(10), // Adjust border radius as needed
                color: Colors.blue, // Change background color
                child: InkWell(
                  onTap: () async {
                    bool succ = await UserControl.removeAdmin(widget.appUser.userID);
                    if(succ){
                      HelperFunctions.showToast("${widget.appUser.name} removed from admin team");
                      await NotificationApi.sendPushNotification(widget.appUser, "Admin Removal Notice: ${widget.appUser.name}  has been removed from the team. Thank you for your contributions. Wishing you all the best in your future endeavors.", widget.currentUser);

                      String encodedMessage = HelperFunctions.stringToBase64("Admin Removal Notice: ${widget.appUser.name}  has been removed from the team. Thank you for your contributions. Wishing you all the best in your future endeavors.");

                      Announcement announcement  = Announcement(
                          message: encodedMessage,
                          fromUserId: widget.currentUser.userID,
                          toUserId: widget.appUser.userID,
                          time: DateTime.now().millisecondsSinceEpoch.toString(),
                          fromUserName: widget.currentUser.name
                      );

                      await NotificationApi.storeNotification(announcement, true) ;
                    }
                    else{
                      HelperFunctions.showToast("Unable to remove at the moment");
                    }
                    Navigator.pop(context);

                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Remove",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
