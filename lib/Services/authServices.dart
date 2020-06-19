import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  String verificId = "", smsCode = "";
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );
  Future<bool> isLoggedIn() async {
    this._user = await _firebaseAuth.currentUser();
    if (this._user == null) {
      return false;
    }
    return true;
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(String email, String password,
      String name, String phoneNumber, BuildContext context) async {
    AuthResult currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.user.updateProfile(userUpdateInfo);
    await currentUser.user.reload();
    _user = currentUser.user;
    //final databaseReference = Firestore.instance;
    /*Kullanici temp = new Kullanici(
        name, currentUser.user.uid, phoneNumber, new Bilgisi("1", "nergis"));
    await databaseReference
        .collection("kullanici")
        .add(temp.toMap())
        .then((value) async {
      await databaseReference
          .collection("kullanici")
          .document(value.documentID)
          .collection("bilgisi")
          .add(temp.bilgisi.toJson());
    });*/

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print("verification failed this bullshit");
      if (exception.message.contains('not authorized'))
        print('Something weird has gone really wrong, please do not try later');
      else if (exception.message.contains('Network'))
        print('Please check your internet connection and try again');
      else if (exception.message.contains("credential is invalid"))
        print("credential is invalid you jerk");
      else {
        print(
            'Something has gone horribly wrong, please try later or never -> ${exception.message}');
        BotToast.showText(
            text: exception.message, duration: Duration(seconds: 5));
      }
    };

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (credential) async {
          await (await FirebaseAuth.instance.currentUser())
              .updatePhoneNumberCredential(credential);
          print("Başarılı.");
          Navigator.of(context)
              .pushNamed('/karsilama', arguments: currentUser.user);
          // either this occurs or the user needs to manually enter the SMS code
        },
        verificationFailed: verificationFailed,
        codeSent: (verificationId, [forceResendingToken]) async {
          // get the SMS code from the user somehow (probably using a text field)
          final AuthCredential credential = PhoneAuthProvider.getCredential(
              verificationId: verificationId, smsCode: this.smsCode);
          await (await FirebaseAuth.instance.currentUser())
              .updatePhoneNumberCredential(credential);
        },
        codeAutoRetrievalTimeout: null);

    return currentUser.user.uid;
  }

  recovery(String email) {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsCode = value;
                    print(this.smsCode);
                  },
                ),
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _firebaseAuth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                    } else {}
                  });
                },
              )
            ],
          );
        });
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    _user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return _user.uid;
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }
}
