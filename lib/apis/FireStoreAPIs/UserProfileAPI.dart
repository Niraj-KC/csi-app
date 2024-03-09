import 'package:csi_app/apis/FirebaseAPIs.dart';
import 'package:csi_app/models/user_model/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  static final _collectionRef = FirebaseAPIs.firestore.collection("appUser");

  static Future addProfile(AppUser user) async {
    final docRef = await _collectionRef.doc(user.userID);

    await docRef.set(user.toJson()).then((value) => null).onError((error, stackTrace) => null);
  }

  static Future<dynamic> signupUser(String name, String year, String cfId) async {
    User? user = FirebaseAPIs.auth.currentUser;

    if (user != null) {
      AppUser appUser = AppUser(
        userID: user.uid,
        name: name,
        profilePhotoUrl: user.photoURL.toString(),
        email: user.email,
        nuRoll: user.email.toString().replaceAll("@nirmauni.ac.in", ""),
        cfId: cfId,
        isAdmin: false,
        isSuperuser: false,
        notificationToken: "",
        year: year,
      );
      print("#UP: ${appUser.toJson().toString()}");
      return await _collectionRef.doc(user.uid)
          .set(appUser.toJson())
          .then((value) => 'ok')
          .onError((error, stackTrace) => error.toString());
    }
  }

  static Future<Map<dynamic, dynamic>?> getUser(String userId) async {
    return await _collectionRef
        .doc(userId)
        .get()
        .then((value) => value.data())
        .onError((error, stackTrace) => {"error": error, "stackTrace": stackTrace});
  }
}