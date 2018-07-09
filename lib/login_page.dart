import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  Future validateAndSubmit()async {
    if(validateAndSave()){
      try{
        if(_formType == FormType.login){
          String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        }else{
          String userId = await widget.auth.createUserEmailAndPassword(_email, _password);
          print('Registered the user: $userId');
        }
        widget.onSignedIn();
        }

    catch(e){
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
    }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key:formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buildInputs()+ emptySpace() + buildSubmitButtons(),
            ),
          )
      ),
    );
  }

  List<Widget>buildInputs(){
    return[
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
        ),
        validator: (val)=> !val.contains('@')?'Please input a valid email':null,
        onSaved: (val)=> _email = val,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
        validator: (val)=> val.length<6 ? 'Password must be at least 6 characters long': null,
        onSaved: (val)=> _password = val,
      ),
    ];
  }

  List<Widget> buildSubmitButtons(){
    if(_formType == FormType.login){
      return[
        RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20.0),
          ),
          color: Colors.green,
          textColor: Colors.white,
          onPressed: validateAndSubmit,
        ),
        SizedBox(height: 5.0,),
        FlatButton(
          child: Text('Create an account', style: TextStyle(fontSize: 15.0),),
          textColor: Colors.redAccent,
          onPressed: moveToRegister,
        )
      ];
    }else{
      return[
        RaisedButton(
          child: Text(
            'Create an Account',
            style: TextStyle(fontSize: 20.0),
          ),
          color: Colors.redAccent,
          textColor: Colors.white,
          onPressed: validateAndSubmit,
        ),
        SizedBox(height: 5.0,),
        FlatButton(
          child: Text('Have an Account? Login', style: TextStyle(fontSize: 15.0),),
          textColor: Colors.green,
          onPressed: moveToLogin,
        )
      ];
    }

  }

  List<Widget> emptySpace(){
    return[
      Column(
        children: <Widget>[
          SizedBox(height: 20.0,)
        ],
      )
    ];
  }


}
