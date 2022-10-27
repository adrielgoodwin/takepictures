import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;

  List<File>? savedImages;

  Future openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this.image = imageTemporary;
    });
  }

  void sameImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(this.image!.path);
    final image = File('${directory.path}/$name');
    await File(this.image!.path).copy(image.path);
    retrieveImages();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveImages();
  }

  void retrieveImages() async {
    var directory = await getApplicationDocumentsDirectory();
    var filesList = directory.listSync();
    var images = filesList.map((e) => e as File).toList();
    setState(() {
      savedImages = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: image != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        image!,
                        width: double.infinity,
                      ),
                    )
                  : Center(
                      child:
                          const Text("Open up your camera and take a photo")),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed: openCamera,
                child: Text("Open Camera"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed: sameImage,
                child: Text("Save Image"),
              ),
            ),
            savedImages != null
                ? SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      children: savedImages!
                          .map((e) => Image.file(
                                e,
                                width: screenWidth / 3,
                                fit: BoxFit.contain,
                              ))
                          .toList(),
                    ),
                  )
                : Text("no images"),
          ],
        ),
      ),
    );
  }
}
