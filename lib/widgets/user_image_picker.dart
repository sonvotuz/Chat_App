import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickedFn);
  final void Function(File pickedImage) imagePickedFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    final pickedImageFile = File(pickedImage.path);
    // ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickedFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        TextButton.icon(
          style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          onPressed: _pickImage,
        )
      ],
    );
  }
}
