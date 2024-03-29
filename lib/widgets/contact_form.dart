import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../form_controller.dart';
import '../screens/HomeScreen.dart';


class ContactForm extends StatefulWidget {


  @override

  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  _storeOnboardInfo() async {
    print("Shared pref called");

    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }



  // TextField Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  Future<void> saveText() async {
    String username = nameController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserText', username);
    print(prefs.getInt('UserText'));

  }

  // Method to Submit Feedback and save it in Google Sheets
   _submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
      // If the form is valid, proceed.
      FeedbackForm feedbackForm = FeedbackForm(
          nameController.text,
          emailController.text,
          countryController.text,
          mobileNoController.text,
          ageController.text,
          );


      FormController formController = FormController();

      _showSnackbar("Submitting Form");

      // Submit 'feedbackForm' and save it in Google Sheets.
      formController.submitForm(feedbackForm, (String response) {
        print("Response: $response");

        if (response == FormController.STATUS_SUCCESS) {
          // Feedback is saved succesfully in Google Sheets.
          _showSnackbar("Form Submitted");


          _storeOnboardInfo();
          saveText();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeScreen()));


        } else {
          // Error Occurred while saving data in Google Sheets.
          _showSnackbar("Error Occurred!");
        }
      });
    }
  }

  _alertBox(String dialog){
    final alertBox = AlertDialog(
      content: Text(dialog),
    );
  }


  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }


  // Method to show snackbar with 'message'.


  bool agree = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(

        height: MediaQuery.of(context).size.height*0.67,
        child: Scaffold(


          backgroundColor: Colors.black,
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,

          body: Center(
            child: Container(

              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Form(
                      key: _formKey,
                      child:
                      Padding(padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: nameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Valid Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusColor: Color(0xFF27FF91),
                                  labelText: 'Name',
                                hintText: "Name",
                                labelStyle: TextStyle(color: Colors.white),

                                hintStyle: TextStyle(color: Colors.white),

                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(80),
                                    borderSide: BorderSide(width: 1, color: Color(0xFF27FF91)),

                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white,width: 1)
                                  )

                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: emailController,
                                validator: (value) {
                                  if (!value.contains("@")) {
                                    return 'Enter Valid Email';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration:  InputDecoration(
                                  enabled: true,
                                    alignLabelWithHint: true,

                                    labelText: 'Email',
                                    focusColor: Color(0xFF27FF91),


                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.white),

                                    labelStyle: TextStyle(color: Colors.white),
                                    border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(80),
                                      borderSide: BorderSide(width: 1, color: Color(0xFF27FF91)),

                                    ),

                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white,width: 1)
                                    )
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*.15,
                                  height: 60,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),


                                    controller: countryController,

                                    keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
                                    decoration:  InputDecoration(
                                      labelText: 'country code',
                                      hintText: '+91',
                                        focusColor: Color(0xFF27FF91),

                                        hintStyle: TextStyle(color: Colors.white),

                                        labelStyle: TextStyle(color: Colors.white),
                                        border: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(80),
                                          borderSide: BorderSide(width: 1, color: Color(0xFF27FF91)),

                                        ),

                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white,width: 1)
                                        )

                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width*.7,
                                  height: 60,
                                  child: TextFormField(

                                    style: TextStyle(color: Colors.white),
                                    controller: mobileNoController,
                                    validator: (value) {
                                      if (value
                                          .trim()
                                          .length != 10) {
                                        return 'Enter 10 Digit Mobile Number';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration:  InputDecoration(
                                      focusColor:  Color(0xFF27FF91),
                                      labelText: 'Mobile Number',
                                      labelStyle: TextStyle(color: Colors.white),
                                        border: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(80),
                                          borderSide: BorderSide(width: 1, color: Color(0xFF27FF91)),

                                        ),

                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white,width: 1)
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),

                                controller: ageController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Valid Age';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration:  InputDecoration(
                                  enabled: true,
                                  fillColor: Colors.white,

                                    labelText: 'Age',
                                    focusColor: Color(0xFF27FF91),

                                    hintText: "Age",
                                    hintStyle: TextStyle(color: Colors.white),

                                    labelStyle: TextStyle(color: Colors.white),
                                    border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(80),
                                      borderSide: BorderSide(width: 1, color: Color(0xFF27FF91)),

                                    ),

                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white,width: 1)
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  Row(
                    children: [
                      Material(
                        color: Colors.black,
                        child: Checkbox(
                          focusColor: Colors.white,
                          overlayColor:MaterialStateProperty.resolveWith((states) =>Color(0xFF27FF91)) ,
                          checkColor: Colors.black,
                          activeColor: Color(0xFF27FF91),

                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value ?? false;
                            });
                          },
                        ),
                      ),
                      Row(
                        children:  [
                          const Text(
                            'I have read and accept ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:  Colors.white
                            ),


                          ),
                          InkWell(
                            child: Text(
                              'terms and conditions',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF27FF91)
                              ),
                            ),
                              onTap: () => launch('https://rosagroups.com/terms-and-conditions-2/')
                          ),
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                    style:  ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.all(25)),
                      elevation: MaterialStateProperty.all(4),
                      shape: MaterialStateProperty.all(
                          const CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(Color(0xFF27FF91)),
                      shadowColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onSurface),
                    ),
                    onPressed: agree ? _submitForm() : _alertBox("please agree to our term and conditions"),
                    child: const Icon(Icons.arrow_forward_outlined,size: 20,color: Colors.black),
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


class FeedbackForm {
  String name;
  String email;
  String countryCode;
  String mobileNo;
  String age;

  FeedbackForm(this.name, this.email,this.countryCode, this.mobileNo, this.age);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm("${json['name']}", "${json['email']}",
      "${json['countryCode']}","${json['mobileNo']}", "${json['age']}",);
  }

  // Method to make GET parameters.
  Map toJson() => {
    'name': name,
    'email': email,
    'countryCode': countryCode,
    'mobileNo': mobileNo,
    'age': age,
  };
}
