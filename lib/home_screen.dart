import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
bool textScanning=false;
XFile ?imageFile;
String sacnnedText="";
  void getImage(ImageSource source)async{
    try{
      final pickedImage=await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        textScanning=true;
        imageFile=pickedImage;
        setState(() {

        });
        getRecognitionText(pickedImage);
      }
    }
    catch(e){
      textScanning=false;
      imageFile=null;
      setState(() {
        sacnnedText="Error occurred while scanning";
      });
    }
  }


  void getRecognitionText(XFile image)async{
    final inputImage=InputImage.fromFilePath(image.path);
    final textDetector=GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText =await textDetector.processImage(inputImage);
    await textDetector.close();
    sacnnedText="";
    for (TextBlock block in recognizedText.blocks){
      for(TextLine line in block.lines){
        sacnnedText=sacnnedText + line.text + "\n";

      }
    }
textScanning=false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Recognition Using ML"),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(textScanning)const CircularProgressIndicator(),
            if(!textScanning&&imageFile==null)
            Container(
              height: 300,
              width: 300,
              color: Colors.grey.shade300,
            ),
            if(imageFile!=null)Image.file(File(imageFile!.path)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(onPressed: (){
                  getImage(ImageSource.gallery);
                }, icon:const Icon(Icons.photo), label: const Text("Gallery")),
                ElevatedButton.icon(onPressed: (){ getImage(ImageSource.camera);}, icon:const Icon(Icons.camera_alt_outlined), label: const Text("Camera")),
              ],
            ),
            Container(child: Text(sacnnedText),)
          ],
        ),
      ),
    );
  }

}
