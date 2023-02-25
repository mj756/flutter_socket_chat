import 'package:flutter/material.dart';
import 'package:learning/controller/login.dart';
import 'package:learning/view/register.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Login({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LoginController(context: context),
        lazy: false,
        builder: (context, __) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration:
                            const InputDecoration(hintText: 'Enter email'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(hintText: 'Enter password'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Provider.of<LoginController>(context, listen: false)
                                .login(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                          },
                          child: const Text('Login')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                          child: const Text('Register')),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
