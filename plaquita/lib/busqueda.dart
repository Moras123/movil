import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class BusquedaScreen extends StatefulWidget {
  @override
  _BusquedaScreenState createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  late CameraController _cameraController;
  TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print("No se encontraron cámaras disponibles.");
        return;
      }

      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController.initialize();
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {
      print('Error al inicializar la cámara: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer?.close();
    super.dispose();
  }

  Future<void> _processImage(CameraImage cameraImage) async {
    try {
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(
        cameraImage.planes[0].bytes,
        FirebaseVisionImageMetadata(
          rawFormat: cameraImage.format.raw,
          size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
          planeData: cameraImage.planes.map((Plane plane) {
            return FirebaseVisionImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            );
          }).toList(),
        ),
      );

      final VisionText visionText = await _textRecognizer.processImage(visionImage);

      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            print(element.text);
          }
        }
      }
    } catch (e) {
      print('Error processing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Búsqueda con Reconocimiento de Placa'),
      ),
      body: CameraPreview(_cameraController),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_cameraController != null && _cameraController.value.isInitialized) {
            await _cameraController.startImageStream(_processImage);
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
