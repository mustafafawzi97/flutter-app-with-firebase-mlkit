import 'package:flutter_app2/mlkit/ml_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

const String TEXT_SCANNER = 'OCR';
const String LABEL_SCANNER = 'Object Recogntion';
const String MATH_EQUATION = 'Math Equation Recogntion';
const String TEXT_TRANS = 'Text translation';

class MLHome extends StatefulWidget {
  MLHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MLHomeState();
}

class _MLHomeState extends State<MLHome> {
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _file;
  String _selectedScanner = LABEL_SCANNER;

  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    final columns = List<Widget>();

    columns.add(buildSelectScannerRowWidget(context));
    columns.add(buildSelectImageRowWidget(context));

    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 75.0,
                    width: double.infinity,
                    color: Color(getColorHexFromStr('#00838f')),
                  ),
                  Positioned(
                    bottom: 50.0,
                    right: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: Color(getColorHexFromStr('#00acc1'))
                              .withOpacity(0.4)),
                    ),
                  ),
                  Positioned(
                    bottom: 100.0,
                    left: 150.0,
                    child: Container(
                        height: 300.0,
                        width: 300.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Color(getColorHexFromStr('#00acc1'))
                                .withOpacity(0.5))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 15.0),
                          Container(
                            alignment: Alignment.topLeft,
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2.0),
                                image: DecorationImage(
                                    image: AssetImage('assets/is2.jpg'))),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 70.0),
                            child: Text(
                              'ROMA ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 280.0),
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {},
                              color: Colors.white,
                              iconSize: 30.0,
                            ),
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),

                      SizedBox(height: 8.0),


                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          Column(
            children: columns,


          ),
          new Padding(padding: EdgeInsets.only(top: 24.0),child:Stack(
              children: <Widget>[
                Container(
                  height: 165.0,
                  width: double.infinity,



                ),
                Positioned(
                  top:  0.0,
                  right: 180.0,

                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(400.0),
                      color:  Color(getColorHexFromStr('#00838f')).withOpacity(0.2),
                    ),
                  ),
                ),

                Positioned(
                  top:  60.0,
                  right: 80.0,
                  left: 100.0,
                  child: Container(
                    height: 200.0,
                    width: 700.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(400.0),
                      color:  Color(getColorHexFromStr('#00838f')).withOpacity(0.2),
                    ),
                  ),
                ),


                Positioned(
                  left: 250.0,
                  bottom: 26.0,
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.0),
                      color:  Color(getColorHexFromStr('#00838f')).withOpacity(0.2),
                    ),
                  ),
                ),

                Positioned(
                  left: 230.0,
                  top: 80.0,
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.0),
                      color:  Color(getColorHexFromStr('#00838f')).withOpacity(0.2),
                    ),
                  ),
                ),


              ]) ,)
        ],
      ),
    );
  }

  Widget buildRowTitle(BuildContext context, String title) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline,
      ),
    ));
  }

  Widget buildSelectImageRowWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child:Padding(padding: EdgeInsets.only(top: 15.0),
              child:  RaisedButton(
              color: Color(getColorHexFromStr('#00838f')),
              textColor: Colors.white,
              splashColor: Colors.pinkAccent,
              onPressed: () {
                onPickImageSelected(CAMERA_SOURCE);
              },
              child: const Text('Camera')),)

        )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Padding(padding: EdgeInsets.only(top: 15.0),
          child: RaisedButton(
              color: Color(getColorHexFromStr('#00838f')),
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                onPickImageSelected(GALLERY_SOURCE);
              },
              child: const Text('Gallery')),
          )
        ))
      ],
    );
  }

  Widget buildSelectScannerRowWidget(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 10.0),
    child: Wrap(
      children: <Widget>[
        RadioListTile<String>(
          title: Text('Object Recognition',style: TextStyle(color:Color(getColorHexFromStr('#00838f')) ,fontSize: 18.0),),
          groupValue: _selectedScanner,
          value: LABEL_SCANNER,
          onChanged: onScannerSelected,
        ),
        RadioListTile<String>(
          title: Text('Text Scanner',style: TextStyle(color:Color(getColorHexFromStr('#00838f')),fontSize: 18.0),),
          groupValue: _selectedScanner,
          value: TEXT_SCANNER,
          onChanged: onScannerSelected,
        ),
        RadioListTile<String>(
          title: Text('Text Translation',style: TextStyle(color: Color(getColorHexFromStr('#00838f')),fontSize: 18.0),),
          groupValue: _selectedScanner,
          value: TEXT_TRANS,
          onChanged: onScannerSelected,
        ),
        RadioListTile<String>(
          title: Text('Math Equation',style: TextStyle(color: Color(getColorHexFromStr('#00838f')),fontSize: 18.0),),
          groupValue: _selectedScanner,
          value: MATH_EQUATION,
          onChanged: onScannerSelected,
        ),
      ],
    ),
    );

  }

  Widget buildImageRow(BuildContext context, File file) {
    return SizedBox(
        height: 500.0,
        child: Image.file(
          file,
          fit: BoxFit.fitWidth,
        ));
  }

  Widget buildDeleteRow(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: RaisedButton(
            color: Colors.red,
            textColor: Colors.white,
            splashColor: Colors.blueGrey,
            onPressed: () {
              setState(() {
                _file = null;
              });
              ;
            },
            child: const Text('Delete Image')),
      ),
    );
  }

  void onScannerSelected(String scanner) {
    setState(() {
      _selectedScanner = scanner;
    });
  }

  void onPickImageSelected(String source) async {
    var imageSource;
    if (source == CAMERA_SOURCE) {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }

    final scaffold = _scaffoldKey.currentState;

    try {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file == null) {
        throw Exception('File is not available');
      }
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MLDetail(file, _selectedScanner)),
      );
    } catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
