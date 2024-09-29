import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
 _LoginState createState() => _LoginState();

}
class _LoginState extends State<LoginPage>{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

   void SignUserIn() async{
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      var regBody = {
        "email":emailController.text,
        "password":passwordController.text
      };
      var response = await http.post(Uri.parse(login),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode(regBody)
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      if(jsonResponse['status']){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
      }else{
        print("SomeThing Went Wrong");
      }
    }else{
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                 children: [
      
        const SizedBox(height: 50),
        //welcome
        const Text(
          'Think it. Make it.',
          style: TextStyle(
          color: Colors.black, 
          fontSize: 18,
          fontWeight: FontWeight.bold,
          ),
          ),

        const Text(
                'Login to your account',
                style: TextStyle(
                color: Color.fromARGB(255, 179, 179, 179), 
                fontSize: 18,
                fontWeight: FontWeight.bold,
                ),
                ),
        
        //username
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
         child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              fillColor: Color.fromARGB(255, 251, 246, 246)
              ,
              filled: true,
              hintText: "Email",
              hintStyle: TextStyle(color: Color.fromARGB(255, 214, 214, 214))
            ),
          ),
        ),

        //password
        const SizedBox(height: 25),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              fillColor: Color.fromARGB(255, 251, 246, 246)
              ,
              filled: true,
              hintText: "Password",
              hintStyle: TextStyle(color: Color.fromARGB(255, 214, 214, 214))

            ),
          )
        ),
        //forget password
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            
            children: [
              Text(
          'Forgot Password?',
          style: TextStyle(color: Color.fromARGB(255, 179, 179, 179)),
        ),


          ],)
        ),

  
        //sign in button
        const SizedBox(height: 25),
        GestureDetector(
           onTap: ()=>{
                        SignUserIn()
                      },
        child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color:Colors.blue,
            borderRadius: BorderRadius.circular(8), 
          ),
          child: const Center(child: Text(
            'Sign In',
             style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
             )),)
        )
        ),

        // or continue
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(children: [
          Expanded(child: Divider(
            thickness: 0.5,
            color: Colors.grey[400],
          ),
          ),
          const Text('Or continue with'),
          Expanded(child: Divider(
            thickness: 0.5,
            color: Colors.grey[400],),)
        ],)
        ),
        //google + apple sign in 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
               
              ),
              child: Image.asset('lib/images/google.png', height: 40,),
            ),

            const SizedBox(width:  25),

            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
               
              ),
              child: Image.asset('lib/images/apple.png', height: 40,),
            )
            
          ],),

        //not memeber regerster now 
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Not a Member?"),
            SizedBox(width: 4),
            Text(
              'Register now',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
  





  ],)
        ),
   
      )
    );
  }
  

}