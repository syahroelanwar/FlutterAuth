import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutterauth/Activity/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, password, name;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  toast(String msg){
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black38,
        textColor: Colors.white);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    final response = await http.post("https://heaped-magnesium.000webhostapp.com/dbflutter/register.php",
        body: {"name": name, "username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      print(message);
      toast(message);
    } else {
      print(message);
      toast(message);
    }
  }
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                              child: Text("Register", style: TextStyle(color: Color(0xff005C97), fontSize: 32, fontWeight: FontWeight.bold),),
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
                                        onSaved: (e)=>name = e,
                                        validator: (e){
                                          if(e.isEmpty){
                                            return "Please Insert Name";
                                          }
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter Your Name",
                                            hintStyle: TextStyle(color: Colors.grey[400])
                                        ),
                                      ),
                                    ),
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
                                  onPressed: () {check();},
                                  color: Color(0xff00c6ff),
                                  textColor: Colors.white,
                                  child: Text("Sign Up"),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Already have an Account? ", style: TextStyle(color: Colors.grey),),
                                      InkWell(
                                        child: Text("Sign In", style: TextStyle(color: Colors.blue),),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => Login()
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