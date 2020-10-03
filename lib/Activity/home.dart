import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterauth/widget/yesNoDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final VoidCallback signOut;
  Home(this.signOut);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username="", name="";

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      name = preferences.getString("name");
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
            bottomOpacity: 0.0,
            elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: ClippingClass(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 3.5 / 9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue, Color(0xff00c6ff)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        margin: EdgeInsets.only(top: 30,bottom: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/images/user.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Text("$name", style: TextStyle(fontSize: 20, color: Colors.white),),
                      SizedBox(height: 5,),
                      Text("$username", style: TextStyle(fontSize:12,color: Colors.white),),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 12),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text("Profile"),
                      leading: Icon(Icons.person),
                      onTap: (){},
                    ),
                    ListTile(
                      title: Text("Settings"),
                      leading: Icon(Icons.settings),
                      onTap: (){},
                    ),
                    ListTile(
                      title: Text("Contact Us"),
                      leading: Icon(Icons.mail),
                      onTap: (){},
                    ),
                    ListTile(
                      title: Text("About Us"),
                      leading: Icon(Icons.info),
                      onTap: (){},
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Share"),
                      leading: Icon(Icons.share),
                      onTap: (){},
                    ),
                    ListTile(
                      title: Text("Rate Us"),
                      leading: Icon(Icons.star),
                      onTap: (){},
                    ),
                    Divider(),
                    ListTile(
                        title: Text("Logout"),
                        leading: Icon(Icons.arrow_back),
                      onTap: ()async {
                        final action =
                        await Dialogs.yesAbortDialog(context, 'Sign Out', 'Are you sure you want to sign out?');
                        if (action == DialogAction.yes) {
                          setState(() => signOut());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx,
        firstEndPoint.dy);
    path.lineTo(size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}