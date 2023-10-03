import 'package:example_project/modules/home/ui/home_ui.dart';
import 'package:example_project/modules/login/cubit/login_cubit.dart';
import 'package:example_project/modules/login/cubit/login_state.dart';
import 'package:example_project/modules/login/repository/login_repository.dart';
import 'package:example_project/modules/network/services.dart';
import 'package:example_project/modules/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({Key? key}) : super(key: key);

  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  late TextEditingController controllerEmail;
  late TextEditingController controllerPassword;
  @override
  void initState() {
    controllerEmail = TextEditingController();
    controllerPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(LoginRepository(DioService())),
          ),
        ],
        child: BlocConsumer<LoginCubit, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 150,
                        ),
                      ),
                    ),
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: controllerEmail,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter valid email id as abc@gmail.com',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: controllerPassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter secure password',
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      margin: const EdgeInsets.only(
                        top: 50,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: () {
                          if (controllerEmail.text.isNotEmpty &&
                              controllerPassword.text.isNotEmpty) {
                            var data = {
                              "email": controllerEmail.text,
                              "password": controllerPassword.text,
                            };
                            BlocProvider.of<LoginCubit>(context).login(data);
                            controllerEmail.clear();
                            controllerPassword.clear();
                          } else {
                            if (controllerPassword.text.isEmpty) {
                              showShortSnackBar(
                                  context, "Password harus di isi");
                            }
                            if (controllerEmail.text.isEmpty) {
                              showShortSnackBar(context, "Email harus di isi");
                            }
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const HomeUi()));
              showShortSnackBar(context, 'Success');
            } else if (state is LoginError) {
              showLongSnackBar(context, state.message);
            }
          },
        ),
      ),
    );
  }
}
