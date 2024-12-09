import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_well_app/src/ui/screens/login.dart';
import 'package:sound_well_app/src/utils/app_assets.dart';
import 'package:sound_well_app/src/controller/signup_controller.dart';
import 'package:sound_well_app/src/utils/app_colors.dart';

class SignUp extends StatefulWidget {
  final String otp;

  // ignore: use_super_parameters
  const SignUp({Key? key, required this.otp}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState(otp: otp);
}

class _SignUpState extends State<SignUp> {
  final _signupController = Get.put(SignupController());
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final String otp;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  _SignUpState({Key? key, required this.otp});

  @override
  Widget build(BuildContext context) {
    /* Get screen dimensions for responsiveness */
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 26, 45),
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: AppColors.primaryBlueDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          /* 5% of screen width */
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.012,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /* Top spacing */
              SizedBox(height: screenHeight * 0.1),
              /* Logo */
              Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.soundIcon),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              /* SignUp Title */
              const Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              /* Name Input Field */
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter your first name',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              /* Name Input Field */
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter your last name',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              /* Email Input Field */
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              /* Password Input Field */
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    labelStyle: const TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              /* Confirm Password Input Field */
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm your password',
                    labelStyle: const TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              /* Add space before the button */
              SizedBox(height: screenHeight * 0.05),
              /* Sign Up Button */
              SizedBox(
                width: screenWidth * 0.8,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    /* Retrieve form data */
                    final firstName = _firstNameController.text.trim();
                    final lastName = _lastNameController.text.trim();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final confirmPassword =
                        _confirmPasswordController.text.trim();

                    /* Validate fields */
                    if (firstName.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter your first name",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }
                    if (lastName.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter your last name",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }
                    if (email.isEmpty || password.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter your email and password",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }
                    if (password != confirmPassword) {
                      Get.snackbar(
                        "Error",
                        "Passwords do not match",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }

                    /* Call signup logic */
                    _signupController.createAccount(firstName, lastName, email, password, otp);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              /* Already have an account? Login Link */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      /* Navigate to login page */
                      Get.to(LogIn());
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
