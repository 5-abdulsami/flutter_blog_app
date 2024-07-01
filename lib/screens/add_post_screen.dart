import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/components/round_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postRef = FirebaseDatabase.instance.ref().child('Posts');

  final _auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();

  File? _image;

  final picker = ImagePicker();

  Future pickGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No Image Selected');
        }
      }
    });
  }

  Future pickCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No Image Selected');
        }
      }
    });
  }

  void dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      pickCameraImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickGalleryImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.photo),
                      title: Text('Gallery'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Blog'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 1,
                      child: _image != null
                          ? ClipRRect(
                              child: Image.file(
                                _image!.absolute,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            hintText: "What's on your mind?",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: "Enter post desctiption",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                    title: 'UPLOAD',
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          //for unique reference of image
                          int date = DateTime.now().millisecondsSinceEpoch;

                          //create storage reference
                          firebase_storage.Reference ref = firebase_storage
                              .FirebaseStorage.instance
                              .ref('/flutterblogapp${date.toString()}');

                          //upload the image
                          firebase_storage.UploadTask uploadTask =
                              ref.putFile(File(_image!.path).absolute);

                          //waiting for image to upload
                          await Future.value(uploadTask);

                          //get the url of the uploaded file
                          var newUrl = await ref.getDownloadURL();

                          final User? user = _auth.currentUser;

                          postRef
                              .child('Posts List')
                              .child(date.toString())
                              .set({
                            'pId': date.toString(),
                            'pImage': newUrl.toString(),
                            'pTime': date.toString(),
                            'pTitle': titleController.text.toString(),
                            'pDescription':
                                descriptionController.text.toString(),
                            'uEmail': user!.email.toString(),
                            'uid': user.uid.toString(),
                          }).then((value) {
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessages('Post Published Successfully!');
                          }).onError((error, stackTrace) {
                            toastMessages(error.toString());
                            setState(() {
                              showSpinner = false;
                            });
                          });
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          toastMessages(e.toString());
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toastMessages(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16,
    );
  }
}
