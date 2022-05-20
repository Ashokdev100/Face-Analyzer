// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
enum Detector {
  face
}

class FaceDetectorPainter extends CustomPainter{
  FaceDetectorPainter(this.absoluteImageSize, this.faces);

  final Size absoluteImageSize;
  final List<Face> faces;
  String value;
  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.blue;

    for (Face face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        paint,
      );

      final smileProb = face.smilingProbability.toString().substring(0,4);
      final leftEyeOpen = face.leftEyeOpenProbability.toString().substring(0,4);
      final rightEyeOpen = face.rightEyeOpenProbability.toString().substring(0,4);
      final headY = face.headEulerAngleY.toString().substring(0,4);
      final headZ = face.headEulerAngleZ.toString().substring(0,4);

      if(double.parse(smileProb) < 0.1){
        value = 'sad';
      }else if(double.parse(smileProb)>0.1 && double.parse(smileProb)<0.5){
        value = 'normal';
      }else if(double.parse(smileProb)>0.5 && double.parse(smileProb)<0.98){
        value = 'happy';
      }else{
        value = 'excellent';
      }

      writingText(size, canvas, face, scaleX, scaleY, 'smile: $smileProb', face.boundingBox.bottom*scaleY+10);
      writingText(size, canvas, face, scaleX, scaleY, 'left eye open: $rightEyeOpen', face.boundingBox.bottom*scaleY+40);
      writingText(size, canvas, face, scaleX, scaleY, 'right eye open: $leftEyeOpen', face.boundingBox.bottom*scaleY+70);
      writingText(size, canvas, face, scaleX, scaleY, 'headY: $headY', face.boundingBox.bottom*scaleY+100);
      writingText(size, canvas, face, scaleX, scaleY, 'headZ: $headZ', face.boundingBox.bottom*scaleY+130);

      final TextPainter textPainter = TextPainter(
          text: TextSpan(text: value, style: TextStyle(fontSize: 60.0,fontWeight: FontWeight.bold,color: Colors.deepPurple)),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.ltr
      )
        ..layout(maxWidth: size.width - 12.0 - 12.0);

      textPainter.paint(canvas, Offset(face.boundingBox.left*scaleX-30,face.boundingBox.bottom*scaleY+180));

    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }


  void writingText(Size size,Canvas canvas,Face face,double scaleX, double scaleY,String text, double y){

    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold)),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr
    )
      ..layout(maxWidth: size.width - 12.0 - 12.0);

    textPainter.paint(canvas, Offset(face.boundingBox.left*scaleX,y));

  }
}

