import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/register_controller.dart';

class Register extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Register({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RegisterController(context: context),
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
                        controller: _nameController,
                        decoration:
                            const InputDecoration(hintText: 'Enter name'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                            Provider.of<RegisterController>(context,
                                    listen: false)
                                .register(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text);
                          },
                          child: const Text('Register'))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
