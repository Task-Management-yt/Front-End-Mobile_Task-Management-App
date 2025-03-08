import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/providers/auth_provider.dart';
import 'package:task_management_app/views/components/text_field.dart';
import 'package:task_management_app/views/welcome_view.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hello! Register to get started',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  BuildTextField(
                    controller: nameController,
                    label: 'Name',
                    hint: 'Enter your name',
                  ),
                  const SizedBox(height: 15),
                  BuildTextField(
                    controller: usernameController,
                    label: 'Username',
                    hint: 'Enter your username',
                  ),
                  const SizedBox(height: 15),
                  BuildTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    isEmail: true,
                  ),
                  const SizedBox(height: 15),
                  BuildTextField(
                    controller: passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 15),
                  BuildTextField(
                    controller: confirmPasswordController,
                    label: 'Confirm password',
                    hint: 'Confirm your password',
                    isPassword: true,
                    isConfirm: true,
                    passwordController: passwordController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
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

                            Map<String, dynamic> response = await authProvider
                                .signUp(
                                  emailController.text,
                                  passwordController.text,
                                  usernameController.text,
                                  nameController.text,
                                );

                            if (response['status']) {
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (BuildContext context) => AlertDialog(
                                      title: const Text('Register Success'),
                                      content: const Text(
                                        'Register success. Please login to continue.',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          const WelcomeView(),
                                                ),
                                              ),
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    ),
                              );
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response['message'])),
                              );
                            }
                          }
                        },
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Register',
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
                //   child: Text('Or Register with'),
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
            //         const TextSpan(text: 'Already have an account? '),
            //         WidgetSpan(
            //           child: GestureDetector(
            //             onTap: () {},
            //             child: const Text(
            //               'Login Now',
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
