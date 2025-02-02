import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csi_app/apis/FireStoreAPIs/UserControl.dart';
import 'package:csi_app/models/user_model/AppUser.dart';
import 'package:csi_app/providers/CurrentUser.dart';
import 'package:csi_app/utils/shimmer_effects/users_card_shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/widgets/user_cards/admin_card.dart';


import 'dart:developer';
class AllAdmins extends StatefulWidget {
  const AllAdmins({super.key});

  @override
  State<AllAdmins> createState() => _AllAdminsState();
}

class _AllAdminsState extends State<AllAdmins> {


  List<AppUser> users = [] ;
  bool isSearching = false ;
  List<AppUser> searchResult = [] ;


  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserProvider>(builder: (context, appUserProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.theme['backgroundColor'],
          appBar: AppBar(
            surfaceTintColor: AppColors.theme['secondaryColor'],
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppColors.theme['secondaryColor'],
            title: Text("Admins",
                style: TextStyle(
                    color: AppColors.theme['tertiaryColor'],
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_arrow_left_outlined,
                  size: 32,
                )),
          ),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      isSearching = !isSearching ;
                    });
                  },

                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.theme['secondaryColor'],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(

                        onChanged: (val){
                          searchResult.clear();
                          for (var i in users){
                            if(i.name!.toLowerCase().contains(val.toLowerCase())){
                              searchResult.add(i) ;
                            }
                            setState(() {
                              ;
                            });
                          }
                        },
                        enabled: isSearching,

                        cursorColor: AppColors.theme['tertiaryColor'],
                        autocorrect: true,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search admins",
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: UserControl.getAllAdmins(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents = snapshot.data!.docs;
                        users = documents
                            .map((doc) => AppUser.fromJson(doc.data() as Map<String, dynamic>))
                            .toList();
                        return ((isSearching && searchResult.isEmpty) || users.isEmpty) ? Center(
                          child: Text("No Users"),
                        ) : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: isSearching ? searchResult.length : users.length,
                          itemBuilder: (context, index) {
                            if(users[index].userID == appUserProvider.user?.userID ) return Container();
                            return AdminCard(
                              appUser: isSearching ? searchResult[index] :users[index],
                              currentUser: appUserProvider.user ?? AppUser(),
                            );
                          },
                        );
                    } else if (snapshot.hasError) {
                      log("#error-postScreen: ${snapshot.error.toString()}");
                      return Text("${snapshot.error.toString()}");
                    } else {
                      return UsersCardShimmerEffect();
                    }
                  },
                ),
              ),

            ],
          ),
        ),

      );
    });
  }
}
