import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as imgpkg;
import 'package:pic_drag_game/first.dart';
void main()
{
  runApp(MaterialApp(home: Home(),));
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  get_permission()
  async {
    var status = await Permission.storage.status;
    if(status.isDenied)
    {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
  }
  List<imgpkg.Image> splitImage(imgpkg.Image inputImage, int horizontalPieceCount, int verticalPieceCount) {
    imgpkg.Image image = inputImage;

    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<imgpkg.Image>.empty(growable: true);

     var x =0 , y=0;
    for (int i=0;i<horizontalPieceCount;i++) {
      for (int j=0;j<verticalPieceCount;j++) {
        pieceList.add(imgpkg.copyCrop(image, x: x, y: y, width: pieceWidth, height: pieceHeight));
        x=x+pieceWidth;
      }
      x=0;
      y=y+pieceHeight;
    }

    return pieceList;
  }
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('myimg/$path');
    var dir_path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)+"/CDMI";
    Directory dir=Directory(dir_path);
    if(!await dir.exists())
      {
        await dir.create();
      }
    final file = File('${dir.path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_permission();
    getImageFileFromAssets("creative.jpg").then((value) {
        List myimg_list=[];
        imgpkg.Image? main_img=imgpkg.decodeJpg(value.readAsBytesSync());
        myimg_list=splitImage(main_img!, 3, 3);
        List<Image> temp_list=[];
        List<Image> images=[];
        for(int i=0;i<myimg_list.length;i++)
          {
            images.add(Image.memory(imgpkg.encodeJpg(myimg_list[i]),fit: BoxFit.fill,));
          }
        temp_list.addAll(images);
        images.shuffle();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return First(temp_list,images);
        },));
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator(),),);
  }
}
