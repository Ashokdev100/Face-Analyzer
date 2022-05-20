
import 'package:camera/camera.dart';
import 'package:face_detection_with_firebase/main.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ad_manager.dart';
import 'detector_painters.dart';
import 'scanner_utils.dart';

class CameraPreviewScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  dynamic _scanResults;
  CameraController _camera;
  Detector _currentDetector = Detector.face;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;
  final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(enableClassification: true));

  InterstitialAd _interstitialAd;

  bool _isInterstitialAdReady;


  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        break;
      default:
      // do nothing
    }
  }


  @override
  void initState() {
    super.initState();
    _initializeCamera();

    _isInterstitialAdReady = false;

    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
  }

  void _initializeCamera() async {
    final CameraDescription description =
    await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.medium,
    );
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _faceDetector.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
            (dynamic results) {
          if (_currentDetector == null) return;
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }


  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    painter = FaceDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
        child: Text(
          'Loading...',
          style: TextStyle(
            color: Colors.green,
            fontSize: 50.0,
          ),
        ),
      )
          : Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_camera),
          _buildResults(),
        ],
      ),
    );
  }

  void _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _camera.stopImageStream();
    await _camera.dispose();

    setState(() {
      _camera = null;
    });

    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
        return;
      },
      child: Scaffold(
        body: _buildImage(),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleCameraDirection,
          child: _direction == CameraLensDirection.back
              ? const Icon(Icons.camera_front)
              : const Icon(Icons.camera_rear),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
    if (_isInterstitialAdReady) {
      _interstitialAd.show();
    }
    _camera.dispose().then((_) {
      _faceDetector.close();
    });

    _currentDetector = null;
    super.dispose();
  }
}


