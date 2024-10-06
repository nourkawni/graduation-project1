import 'package:flutter/material.dart';
import 'package:frontend1/pages/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import 'signup_page.dart';
import 'forgetpassword_page.dart';
import 'package:frontend1/pages/DashBoard.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
 _LoginState createState() => _LoginState();

}
class _LoginState extends State<LoginPage>{
  TextEditingController emailController = TextEditingController();
  
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _isLoading = false;

 void signUserIn() async {
  print("Sign in button pressed");

  // Check if email and password are filled
  if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
    print("Email and password are filled");

    setState(() {
      _isLoading = true;  // Show loading indicator
    });

    var regBody = {
      "email": emailController.text,
      "password": passwordController.text
    };

    try {
      print("Sending request to server...");
      var response = await http.post(
        Uri.parse('http://192.168.1.94:3000/login'),  // Replace with your server URL
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      print("Received response from server");
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        print("Login successful");
       String token = jsonResponse['token'];
         Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String retrievedEmail = decodedToken['email'];
        print('Email from token: $retrievedEmail');
         SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MyPage()),
        );
      } else {
        print("Login failed: ${jsonResponse['message']}");
        
        // Display a specific error message based on the server's response
        String errorMessage;
        if (jsonResponse['message'].toLowerCase().contains('invalid credentials') || 
            jsonResponse['message'].toLowerCase().contains('wrong email')) {
          errorMessage = 'Wrong email or password';
        } else {
          errorMessage = jsonResponse['message']; // Use the message from the server
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage, style: TextStyle(color: Colors.red))),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.', style: TextStyle(color: Colors.red))),
      );
    } finally {
      setState(() {
        _isLoading = false;  // Stop loading indicator
      });
    }
  } else {
    print("Email or password is empty");
    setState(() {
      _isNotValidate = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in both email and password', style: TextStyle(color: Colors.red))),
    );
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
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
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
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
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
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to the Forget Password page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()), // Replace with your actual ForgetPasswordPage class
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color.fromARGB(255, 179, 179, 179),
                       // Optional: Add underline to indicate it's clickable
                    ),
                  ),
                ),
              ],
            ),
          ),

     
  
        //sign in button
        const SizedBox(height: 25),
        GestureDetector(
           onTap: signUserIn,
                   
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
               
              ),
              child: Image.asset('lib/images/google.png', height: 40,),
            ),

            const SizedBox(width:  25),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
               
              ),
              child: Image.asset('lib/images/apple.png', height: 40,),
            )
            
          ],),

        //not memeber regerster now 
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Not a Member?"),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()), // Replace SignUpPage with your sign-up page widget
                  );
                },
                child: const Text(
                  'Register now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )

  





  ],)
        ),
   
      )
    );
  }
  

}