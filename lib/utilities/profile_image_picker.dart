import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileImagePicker extends StatefulWidget {

  ProfileImagePicker({@required this.pickImageFunction});

  final void Function(io.File image) pickImageFunction;

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {

  final _picker=ImagePicker();
  io.File _image;


  getImage(ImageSource chosenSource)async{
    final pickedFile=await _picker.getImage(
        source: chosenSource,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50
    );

    setState(() {
      if(pickedFile!=null)
        {
          _image=io.File(pickedFile.path);
        }
    });
    widget.pickImageFunction(_image);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment(0, 1),
          child: AlertDialog(
            title: Text('Choose Image Source'),
            actions: <Widget>[
              IconButton(
                icon: Container(
                  child: Icon(
                    FontAwesomeIcons.image,
                    color: Colors.orange,
                    size: 40,
                  )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery);
                },
              ),
              IconButton(
                icon: Container(
                    child: Icon(
                      FontAwesomeIcons.cameraRetro,
                      color: Colors.orange,
                      size: 40,
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(60),
            child: Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: Colors.black12)
                ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                backgroundImage: _image!=null? FileImage(_image):NetworkImage("https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-male-avatar-maker.jpg"),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _showMyDialog();
              // getImage();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.image,color: Colors.orange,), Text("Add image",style: TextStyle(color: Colors.orange,fontSize: 20),),],
            ),
          ),
        ],
      ),
    );
  }
}



