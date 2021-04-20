import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_app/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(image);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({'username': username, 'email': email, 'image_url': url});
      }
    } on PlatformException catch (err) {
      var message = 'Error occurred, please check your credential!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
            content: Text(message), backgroundColor: Theme.of(ctx).errorColor),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(ctx).errorColor),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Auth Screen'),
      ),
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
