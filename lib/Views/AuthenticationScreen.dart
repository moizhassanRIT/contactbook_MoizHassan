import 'package:contactbook/Views/ContactsPageScreen.dart';
import 'package:contactbook/Views/Model/AuthenticationService.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  String loginResultMessage = " ";

  bool success = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(
          top: 50,
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Column(
              children: [
                Container(
                  child: Image.asset('assets/images/contactbook.png'),
                  height: 0.37 * MediaQuery.of(context).size.height,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      labelText: 'Email',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _pass,
                    decoration: InputDecoration(
                      hintText: 'Enter your Password',
                      labelText: 'Password',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    )),
                    onPressed: () async {
                      success = await AuthenticationService()
                          .signIn(_email.text.trim(), _pass.text.trim());
                      if (success) {
                        print("Successful Login!");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsPageScreen(),
                          ),
                        );
                      } else {
                        print("Unsuccessful Login!");
                        setState(() {
                          loginResultMessage = "Login Attempt Unsuccessful!";
                        });
                      }
                    },
                    child: Text('Login'),
                  ),
                ),
                Container(
                  child: Text(
                    loginResultMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
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
