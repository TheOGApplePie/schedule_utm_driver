import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schedule_utm_driver/model/schedule.dart';
import 'main_map_screen.dart';

import 'schedule_screen.dart';

String appTitle = 'Authentication Screen';
String submitButtonText = 'Continue';
const minPassLength = 6;



class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: const AuthenticationForm(),
      ),
    );
  }
}

// Create a Form widget.
class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({Key? key}) : super(key: key);

  @override
  AuthenticationFormState createState() {
    return AuthenticationFormState();
  }
}
String? validateEmail(String email){
  email = email.trim();
  String regex = "@(.*)";
  if(!email.contains(RegExp(regex))){
  return 'Please Enter a valid email';
  }
  return null;
}
String? validatePassword(String password) {
  password = password.trim();
  if(password.length<minPassLength){
    return 'Your password needs to be at least six characters long';
  }
  if(!password.contains(RegExp(r'\D')) || !password.contains(RegExp(r'\d'))){
    return 'Your password needs to contain:\nAt least one special character\nAt least one number\nWith regular characters';
  }
  return null;
}
// Create a corresponding State class.
// This class holds data related to the form.
class AuthenticationFormState extends State<AuthenticationForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<AuthenticationFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text:'');
  // ignore: prefer_final_fields
  bool _isVisible = false;
  // accountStatus - 0: default, 1: User does not exist (invoke signup), 2: Invalid email
  int accountStatus = 0;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child:
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
            hintText: 'Email',
            labelText: 'Enter email',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'You need to enter an email address';
              }
              return validateEmail(value);
            },
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child:Visibility(
            maintainSize: false,
            visible: _isVisible,
            child: TextFormField(
            obscureText: true,
            controller: _passwordController,
            decoration: const InputDecoration(
            hintText: 'Password',
            labelText: 'Enter password',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'You need to enter your password';
              }
              if(submitButtonText == 'Sign Up'){
                return validatePassword(value);
              }
              return null;
            },
          )
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, submit info to firebase.
                  _submitEmail();
                }
              },
              child: Text(submitButtonText),
            ),
          ),
        ],
      ),
    );
  }
  void showSnackBar(String text){
  SnackBar snackBar = SnackBar(
      content: Text(text),
      ); 
      ScaffoldMessenger.of(context).showSnackBar(snackBar); 
  }
  void _submitEmail () async{
    _emailController.text = _emailController.text.trim();
    _passwordController.text = _passwordController.text.trim();
    List<String> methods = [];     
    if(!_isVisible){
      methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_emailController.text);
    }
    setState(() {
      if(methods.isEmpty && !_isVisible){
        submitButtonText = "Sign Up";
      }else{
        submitButtonText = "Sign In";
      }
      _isVisible = true;
    });
    if(_isVisible){
        methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_emailController.text);
      if(methods.isEmpty){
        try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        } on FirebaseAuthException catch(e){
          if(e.code == 'email-already-in-use'){
            showSnackBar(e.code);  
          }
        }
      }else{
        try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((value) => value.user != null? 
        FirebaseFirestore.instance.collection('Drivers').doc(_emailController.text).get().then(
           (DocumentSnapshot doc){
            final data = doc.data() as Map<String, dynamic>;
             if(data['hasRoutes']){
              Navigator.pop(context);
          Navigator.push<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => const MainMapScreen()));
        }else{
          Navigator.pop(context);
          Navigator.push<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) =>  const ScheduleScreen()));
        }
          }): null
        );
        } on FirebaseAuthException catch(e){
          if(e.code == 'user-not-found' || e.code == 'wrong-password'){
          showSnackBar(e.code);}
        }
      }
    } 
  }
}


