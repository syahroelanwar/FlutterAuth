import 'dart:convert';
import 'package:flutterauth/Activity/home.dart';
import 'package:flutterauth/Activity/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum LoginStatus{
  notSignIn,
  signIn
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  bool _obscureText = true;
  String username, password;
  final _key = new GlobalKey<FormState>();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      login();
    }
  }

  toast(String msg){
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black38,
        textColor: Colors.white);
  }

  login() async{
    final response = await http.post("https://heaped-magnesium.000webhostapp.com/dbflutter/login.php", body: {
      "username" : username,
      "password" : password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String usernameA = data['username'];
    String name = data['name'];
    String id = data['id'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameA, name, id);
      });
      print(message);
      toast(message);
    } else {
      print(message);
      toast(message);
    }
  }

  savePref(int value, String username, String name, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("username", username);
      preferences.setString("id", id);
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch(_loginStatus){
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: ClippingClass(),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Color(0xff005C97), Color(0xff00c6ff)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.center),
                              ),
                              height: MediaQuery.of(context).size.height / 2.2,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 120, left: 60),
                            width: 350,
                            child: Column(
                              children: <Widget>[
                                Image(image: AssetImage('assets/images/login.png'),),
                              ],
                            ),
                          ),
                          Positioned(
                              top: 325,
                              left: 80,
                              child: Container(
                                //margin: EdgeInsets.only(top: 120),
                                child: Center(
                                  child: Text("Login", style: TextStyle(color: Color(0xff005C97), fontSize: 32, fontWeight: FontWeight.bold),),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 350),
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(143, 148, 251, .2),
                                              blurRadius: 20.0,
                                              offset: Offset(0, 10)
                                          )
                                        ]
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                          ),
                                          child: TextFormField(
                                            onSaved: (e)=>username = e,
                                            validator: (e){
                                              if(e.isEmpty){
                                                return "Please Insert Username";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Enter Your Username",
                                                hintStyle: TextStyle(color: Colors.grey[400])
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            onSaved: (e)=>password = e,
                                            validator: (e){
                                              if(e.isEmpty){
                                                return "Please Insert Password";
                                              }
                                            },
                                            obscureText: _obscureText,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Enter Your Password",
                                              hintStyle: TextStyle(color: Colors.grey[400]),
                                              suffixIcon: InkWell(
                                                onTap: _toggle,
                                                child: Icon(
                                                  _obscureText? Icons.visibility_off : Icons.visibility,
                                                  size: 26.0,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Container(
                                    height: 50,
                                    width:double.infinity,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Color(0xff00c6ff))),
                                      onPressed: () {
                                        check();
                                      },
                                      color: Color(0xff00c6ff),
                                      textColor: Colors.white,
                                      child: Text("Sign In"),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Don't have an Account? ", style: TextStyle(color: Colors.grey),),
                                          InkWell(
                                            child: Text("Sign Up", style: TextStyle(color: Colors.blue),),
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => Register()
                                              ));
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return Home(signOut);
        break;
    }
  }
}

class ClippingClass extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    //creating first curver near bottom left corner
    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    //creating second curver near center
    var secondControlPoint = Offset(size.width / 5, size.height / 4);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    //creating third curver near top right corner
    var thirdControlPoint = Offset(
        size.width - (size.width / 9), size.height / 6);
    var thirdEndPoint = Offset(size.width, 0.0);

    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move to top right corner
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}