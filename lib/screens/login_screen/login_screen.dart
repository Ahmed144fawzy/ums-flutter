import 'package:flutter/material.dart';
import 'package:unviersty_system/core/colors/app_colors.dart';
import 'package:unviersty_system/core/images/app_images.dart';
import 'package:unviersty_system/core/network/login.dart';
import 'package:unviersty_system/core/routes/page_routes_name.dart';
import '../../core/storage/storage.dart';
import '../../core/widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _passwordController = TextEditingController();



  Future<void> checkToken() async{
    final userToken = await readStorage(key: "token");
    if(userToken != null){
      Navigator.pushReplacementNamed(context, PageRoutesName.homeScreen);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {

    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(

      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 60),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.splashLogo,
                    height: mediaQuery.height * 0.24,),
                  SizedBox(
                    height: mediaQuery.height * 0.02,
                  ),
                  Align(alignment: Alignment.center,
                    child: Text("Welcome Back!",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                        color: AppColors.blue,
                        fontFamily: "Janna",
              
                      ),),
                  ),
                  Align(alignment: Alignment.center,
                    child: Text("Login your account.",
              
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.darkGrey,
                        fontFamily: "Janna",
              
              
                      ),),
                  ),
                  SizedBox(
                    height: mediaQuery.height * 0.08,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ID",
              
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.black,
                        fontFamily: "Janna",
              
              
                      ),),
                  ),
                  SizedBox(
                    height: mediaQuery.height * 0.01,
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: _idController,
                    onValidate: (value){
                      if(value == null || value.trim().isEmpty) {
                        return "please enter Your id, can not be empty";
                      }
                      return null;
                    },
                    hint: "Please enter your id",
                    hintColor: AppColors.darkGrey,
              
              
                  ),
                  SizedBox(
                    height: mediaQuery.height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password",
              
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.black,
                        fontFamily: "Janna",
              
              
                      ),),
                  ),
                  SizedBox(
                    height: mediaQuery.height * 0.01,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    onValidate: (value){
                      if(value == null || value.trim().isEmpty) {
                        return "please enter Your password, can not be empty";
                      }
                      return null;
                    },
                    isPassword: true,
                    maxLines: 1,
                    hint: "Please enter your password",
                    hintColor: AppColors.darkGrey,
              
              
                  ),
                  SizedBox(
                    height: mediaQuery.height * 0.01,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child:
                      TextButton(onPressed: (){}, child:
                      Text("Forget Password?",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontFamily: "Janna",
                          color: AppColors.orange,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.orange,
              
              
                        ),)
                      )
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await login(
                          studentID: _idController.text.trim(),
                          password: _passwordController.text.trim(),
                          context: context,
                        );
                      }
                    },
                    child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}