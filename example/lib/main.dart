import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_waveforms/flutter_waveforms.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<File>> getAUdioFilesFromAssets(List<String> paths) async {
    final files = <File>[];

    for (final path in paths) {
      final byteData = await rootBundle.load('assets/$path');

      final file = File('${(await getTemporaryDirectory()).path}/$path');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      files.add(file);
    }

    return files;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder<List<File>>(
          future: getAUdioFilesFromAssets(["cymbal.wav"]),
          builder: (context, snapshot) {
            final _data = snapshot.data;

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (_data == null && !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Center(
              child: SizedBox(
                  width: 600,
                  child: ListView(
                    children: [
                      ..._data!.map<Widget>((e) {
                        return Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: Waveform(
                              size: const Size(600, 200),
                              audioFile: e,
                              waveformType: WaveformType.accurate,
                              painterType: PainterType.path,
                              // waveColor: Colors.blue,
                              // backgroundColor: Colors.brown,
                            ));
                      }).toList(),
                      ..._data.map<Widget>((e) {
                        return Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: Waveform(
                              size: const Size(600, 200),
                              audioFile: e,
                              waveformType: WaveformType.accurate,
                              painterType: PainterType.path,
                              shouldFill: false,
                              // waveColor: Colors.blue,
                              // backgroundColor: Colors.brown,
                            ));
                      }).toList(),
                      ..._data.map<Widget>((e) {
                        return Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: Waveform(
                              size: const Size(600, 200),
                              audioFile: e,
                              waveformType: WaveformType.accurate,
                              painterType: PainterType.line,
                              // waveColor: Colors.blue,
                              // backgroundColor: Colors.brown,
                            ));
                      }).toList()
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
