import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/views/components/text_field.dart';
import '../providers/auth_provider.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),
              const Text(
                'Welcome back! Glad to see you, Again!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              BuildTextField(
                controller: emailController,
                label: 'Email',
                hint: 'Enter your email',
                isEmail: true,
              ),
              const SizedBox(height: 20),
              BuildTextField(
                controller: passwordController,
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              bool success = await authProvider.signIn(
                                emailController.text,
                                passwordController.text,
                              );

                              if (success) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomeView(),
                                  ),
                                );
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Login gagal. Periksa kembali email dan password.',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 8),
                  //   child: Text('Or Login with'),
                  // ),
                  // Expanded(child: Divider()),
                ],
              ),
              // const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     _buildSocialButton(FontAwesomeIcons.facebook, Colors.blue),
              //     const SizedBox(width: 20),
              //     _buildSocialButton(FontAwesomeIcons.google, Colors.red),
              //     const SizedBox(width: 20),
              //     _buildSocialButton(FontAwesomeIcons.apple, Colors.black),
              //   ],
              // ),
              // const SizedBox(height: 30),
              // Center(
              //   child: RichText(
              //     text: TextSpan(
              //       style: const TextStyle(color: Colors.black),
              //       children: [
              //         const TextSpan(text: 'Don’t have an account? '),
              //         WidgetSpan(
              //           child: GestureDetector(
              //             onTap: () {},
              //             child: const Text(
              //               'Register Now',
              //               style: TextStyle(
              //                 color: Colors.blue,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildSocialButton(IconData icon, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.black12),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Icon(icon, color: color),
  //   );
  // }
}
