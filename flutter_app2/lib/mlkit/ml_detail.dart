import 'package:flutter_app2/mlkit/ml_home.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:mlkit/mlkit.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_html2pdf_viewer/flutter_html2pdf_viewer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


String text;
String text2;
String text3=" ";

class MLDetail extends StatefulWidget {
  final File _file;
  final String _scannerType;



  MLDetail(this._file, this._scannerType);
  @override
  State<StatefulWidget> createState() {
    return _MLDetailState();
  }
}

class _MLDetailState extends State<MLDetail> {
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
  FirebaseVisionLabelDetector labelDetector =
      FirebaseVisionLabelDetector.instance;

  List<VisionText> _currentTextLabels = <VisionText>[];
  List<VisionLabel> _currentLabelLabels = <VisionLabel>[];


  Stream sub;
  StreamSubscription<dynamic> subscription;

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
  void initState() {
    super.initState();
    sub = new Stream.empty();
    subscription = sub.listen((_) => _getImageSize)..onDone(analyzeLabels);
    text3="";
  }



  void analyzeLabels() async {
    try {
      var currentLabels;
      if (widget._scannerType == TEXT_SCANNER || widget._scannerType == MATH_EQUATION || widget._scannerType == TEXT_TRANS) {
        currentLabels = await textDetector.detectFromPath(widget._file.path);
        if (this.mounted) {
          setState(() {
            _currentTextLabels = currentLabels;

          });
        }
      } else if (widget._scannerType == LABEL_SCANNER) {
        currentLabels = await labelDetector.detectFromPath(widget._file.path);
        if (this.mounted) {
          setState(() {
            _currentLabelLabels = currentLabels;
          });
        }
      }
    } catch (e) {
      print("MyEx: " + e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
    text3="";

  }
var _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget._scannerType,style:TextStyle(color: Colors.white) ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: widget._scannerType == TEXT_SCANNER
              ?() => pdfview(text3)
              :() =>  pdfview(text3),
          tooltip: 'share as pdf',
          child: new Icon(Icons.share),
          backgroundColor:Color(getColorHexFromStr('#00838f')),
        ),


        body: Column(
          children: <Widget>[
            buildImage(context),
             widget._scannerType == LABEL_SCANNER
                ? buildBarcodeList<VisionLabel>(_currentLabelLabels)
                :   buildTextList(_currentTextLabels),


          ],
        ));
  }

  Widget buildImage(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
          decoration: BoxDecoration(color:Color(getColorHexFromStr('#00838f'))),
          child: Center(
            child: widget._file == null
                ? Text('No Image')
                : FutureBuilder<Size>(
                    future: _getImageSize(
                        Image.file(widget._file, fit: BoxFit.fitWidth)),
                    builder:
                        (BuildContext context, AsyncSnapshot<Size> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            foregroundDecoration:
                                (widget._scannerType == TEXT_SCANNER || widget._scannerType == MATH_EQUATION || widget._scannerType == TEXT_TRANS )
                                    ? TextDetectDecoration(
                                        _currentTextLabels, snapshot.data)
                                    : LabelDetectDecoration(
                                        _currentLabelLabels, snapshot.data),
                            child:
                                Image.file(widget._file, fit: BoxFit.fitWidth));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
          )),
    );
  }

  Widget buildBarcodeList<T>(List<T> barcodes) {
    if (barcodes.length == 0) {
      return Expanded(
        flex: 1,
        child: Center(
          child: Text('Nothing detected',
              style: Theme.of(context).textTheme.subhead),
        ),
      );
    }
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: barcodes.length,
            itemBuilder: (context, i) {


              final barcode = barcodes[i];
              switch (widget._scannerType) {
                case LABEL_SCANNER:
                  VisionLabel res = barcode as VisionLabel;
                  text = " ${res.label}  ${(res.confidence*100).toInt()}%";
                  break;
              }

              return _buildTextRow(text);
            }),
      ),
    );
  }

  Widget buildTextList(List<VisionText> texts) {
    if (texts.length == 0) {
      return Expanded(
          flex: 1,
          child: Center(
            child: Text('No text detected',
                style: Theme.of(context).textTheme.subhead),
          ));
    }
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: texts.length,

            itemBuilder: (context, i) {
              return _buildTextRow(texts[i].text);

            }),
      ),
    );
  }

  Widget _buildTextRow(text) {
    text2=text;
    _translate(text);
    text3="$text3 \n\n"+text2;
    if(widget._scannerType == MATH_EQUATION){
    text=add();
    return ListTile(
      title: Text(
        "$text2 = $text ",
      ),
      dense: true,
    );
    }else if(widget._scannerType == TEXT_TRANS) {
     if(_result != null){
      return ListTile(
        title: Text(
          "$_result",
        ),
        dense: true,
      );
    }
    }else {
      return ListTile(
        title: Text(
          "$text",
        ),
        dense: true,
      );
    }

    }
  Future<void> _translate(String text) async {
    try {
      final response = await http.get(Uri.encodeFull(
          'https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20190511T110924Z.abce23e85ed4cda8.db4f3190d6677acd3827fdf06b017013dd18d300&text=$text&lang=ar'));
      if (response.statusCode == 200) {
        _result = json.decode(response.body)['text'];
        print(_result);

      }
      } catch (e) {
      print(e.toString());
    }
  }



 add(){
   text3=text2;
   Parser p = new Parser();
   Expression exp = p.parse(text3);
   ContextModel cm = new ContextModel();

// (3) Evaluate expression:
   double eval = exp.evaluate(EvaluationType.REAL, cm);
   String result = eval.toString();
   return result;

 }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble())));
    return completer.future;
  }
}

/*
  This code uses the example from azihsoyn/flutter_mlkit
  https://github.com/azihsoyn/flutter_mlkit/blob/master/example/lib/main.dart
*/

class TextDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<VisionText> _texts;

  TextDetectDecoration(List<VisionText> texts, Size originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _TextDetectPainter(_texts, _originalImageSize);
  }
}

class _TextDetectPainter extends BoxPainter {
  final List<VisionText> _texts;
  final Size _originalImageSize;

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

  _TextDetectPainter(texts, originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..color = Color(getColorHexFromStr('374654'))
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    for (var text in _texts) {
      final _rect = Rect.fromLTRB(
          offset.dx + text.rect.left / _widthRatio,
          offset.dy + text.rect.top / _heightRatio,
          offset.dx + text.rect.right / _widthRatio,
          offset.dy + text.rect.bottom / _heightRatio);
      canvas.drawRect(_rect, paint);
    }
    canvas.restore();
  }
}

class LabelDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<VisionLabel> _labels;
  LabelDetectDecoration(List<VisionLabel> labels, Size originalImageSize)
      : _labels = labels,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _LabelDetectPainter(
      _labels,
      _originalImageSize,
    );
  }
}

class _LabelDetectPainter extends BoxPainter {
  final List<VisionLabel> _labels;
  final Size _originalImageSize;

  _LabelDetectPainter(labels, originalImageSize)
      : _labels = labels,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    for (var label in _labels) {
      final _rect = Rect.fromLTRB(
          offset.dx + label.rect.left / _widthRatio,
          offset.dy + label.rect.top / _heightRatio,
          offset.dx + label.rect.right / _widthRatio,
          offset.dy + label.rect.bottom / _heightRatio);
      canvas.drawRect(_rect, paint);
    }
    canvas.restore();
  }
}
