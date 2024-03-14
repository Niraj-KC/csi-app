import 'package:csi_app/models/user_model/AppUser.dart';
import 'package:csi_app/utils/colors.dart';
import 'package:csi_app/utils/helper_functions/date_format.dart';
import 'package:csi_app/utils/helper_functions/function.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';

class UserCard extends StatelessWidget {
  final AppUser appUser ;
  const UserCard({Key? key, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor: AppColors.theme['backgroundColor'],
      onLongPress: () {
        bottomSheet(context);
      },
      child: Card(
        elevation: 0,
        color: AppColors.theme['secondaryColor'],
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            child: Text(
              HelperFunctions.getInitials(appUser.name ?? ""),
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.theme['secondaryColor'],
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.theme["primaryColor"],
          ),
          title: Text(appUser.name ?? ""),
          subtitle: Text("Joined on : ${MyDateUtil.getFormattedTime(context: context, time: appUser.createdAt ?? "")}"),

          // if user admin then display this card
          trailing: (appUser.isAdmin ?? false) ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.theme['primaryColor'],
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text(
                  "Admin",
                  style: TextStyle(
                    color: AppColors.theme['secondaryColor'],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ) : SizedBox(),
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
              child:Text(HelperFunctions.getInitials("Hitesh"), style: TextStyle(
                  color: AppColors.theme['secondaryColor'],
                  fontWeight: FontWeight.bold,fontSize: 40)),
              backgroundColor: AppColors.theme['primaryColor'],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Hitesh Mori",
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
                    onTap: () {},
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
                "Promote to Admin",
                style: TextStyle(
                    color: AppColors.theme['tertiaryColors'],
                    fontWeight: FontWeight.bold),
              ),
              trailing: Material(
                borderRadius:
                    BorderRadius.circular(10), // Adjust border radius as needed
                color: Colors.blue, // Change background color
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.theme['primaryColor'],
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Promote",
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