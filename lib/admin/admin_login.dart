import 'package:clothes_app/admin/admin_upload_items.dart';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:developer' as devtools show log;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  var _formKey = GlobalKey<FormState>();
  var isObsecure = true.obs;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  loginAdminNow() async {
    try {
      var url = API.loginAdmin;
      var response = await http.post(Uri.parse(url), body: {
        'admin_email': _emailController.text.trim(),
        'admin_password': _passwordController.text.trim()
      });

      // Successful Connection
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedResponseBodyForLogin =
            convert.jsonDecode(jsonString) as Map<String, dynamic>;
        devtools.log(decodedResponseBodyForLogin.toString());
        if (decodedResponseBodyForLogin['success'] == true) {
          var decodedData =
              decodedResponseBodyForLogin['adminData'] as Map<String, dynamic>;

          // Navigating User to Dashboard
          Get.to(const AdminUploadItemsScreen());

          Fluttertoast.showToast(
            msg: "Logged in Successfully.",
          );
          setState(() {
            [_emailController, _passwordController]
                .forEach((element) {
              element.clear();
            });
          });
        } else {
          Fluttertoast.showToast(
            msg:
                "Incorrect Credentials, \n Please Enter Correct Login Credentials.",
          );
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (p0, p1) {
          return ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: p1.maxHeight, minWidth: p1.maxWidth),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: [
                  // Login Screen Header
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.asset("images/admin.jpg", fit: BoxFit.cover),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  // Login Screen Sign in Form
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, -3),
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(45),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "Please Enter Email",
                                      // labelText: "Please Enter Email",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide:
                                            BorderSide(color: Colors.white60),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide:
                                            BorderSide(color: Colors.white60),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide:
                                            BorderSide(color: Colors.white60),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        borderSide:
                                            BorderSide(color: Colors.white60),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 6),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    validator: (value) {
                                      var checkNull = value ?? "";
                                      if (checkNull.isEmpty) {
                                        return "Email Can't be Empty";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  // Password Field
                                  Obx(() {
                                    return TextFormField(
                                      controller: _passwordController,
                                      obscureText: isObsecure.value,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.vpn_key_sharp,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: Obx(
                                          () => GestureDetector(
                                            onTap: () {
                                              isObsecure.value =
                                                  !isObsecure.value;
                                            },
                                            child: Icon(
                                              isObsecure.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        hintText: "Please Enter Password",
                                        // labelText: "Please Enter Email",
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.white60),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.white60),
                                        ),
                                        disabledBorder:
                                            const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.white60),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.white60),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 6),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                      validator: (value) {
                                        var checkNull = value ?? "";
                                        if (checkNull.isEmpty) {
                                          return "Password Can't be Empty";
                                        } else if (checkNull.length < 8) {
                                          return "Password length should be at least 8";
                                        }
                                        return null;
                                      },
                                    );
                                  }),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          devtools.log("form passed");
                                          loginAdminNow();
                                        } else {
                                          devtools.log("form failed");
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Text(
                                          "LOGIN",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("I am not an admin  "),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => const LoginScreen());
                                  },
                                  child: const Text(
                                    "Click Here",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),

                            // Email Field
                          ],
                        ),
                      ),

                      // child: ,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
