import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentDetailScreen extends StatefulWidget {
  final dynamic document;

  DocumentDetailScreen({required this.document});

  @override
  _DocumentDetailScreenState createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  late PdfViewerController _pdfViewerController;
  bool _isDownloading = false;
  double _downloadProgress = 0;


  @override
  void initState() {
    super.initState();
    print(widget.document.pdfUrl);
    _pdfViewerController = PdfViewerController();
    // Initialize downloader (call this once in your app)
    FlutterDownloader.initialize(debug: true);
  }

  

  
 
Future<void> _downloadFile() async {
  // Check storage permission for Android 10 and below
  var status = await Permission.storage.request();

  // Check for Android 11+ (MANAGE_EXTERNAL_STORAGE)
  if (Platform.isAndroid && (await Permission.manageExternalStorage.isGranted)) {
    print('Manage external storage permission granted');
  } else if (Platform.isAndroid) {
    var storageStatus = await Permission.manageExternalStorage.request();
    if (storageStatus.isGranted) {
      print('Manage external storage permission granted');
    } else {
      openAppSettings(); // Prompt user to enable permission
      return;
    }
  }

  setState(() {
    _isDownloading = true;
    _downloadProgress = 0;
  });

  try {
    final directory = await getExternalStorageDirectory();
    final path = directory?.path ?? '/storage/emulated/0/Download';
    final fileName = '${widget.document.title.replaceAll(' ', '_')}.pdf';
    
    final taskId = await FlutterDownloader.enqueue(
      url: widget.document.pdfUrl,
      savedDir: path,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      if (taskId == id) {
        setState(() {
          _downloadProgress = progress.toDouble();
          if (status == DownloadTaskStatus.complete) {
            _isDownloading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Download completed successfully!')),
            );
          } else if (status == DownloadTaskStatus.failed) {
            _isDownloading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Download failed, please try again')),
            );
          }
        });
      }
    });
  } catch (e) {
    setState(() => _isDownloading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error downloading file: $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(
              //   widget.document.title,
              //   style: TextStyle(
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.w600,
              //     shadows: [
              //       Shadow(
              //         color: Colors.black45,
              //         blurRadius: 4,
              //         offset: Offset(1, 1),
              //       ),
              //     ],
              //   ),
              //   maxLines: 1,
              //   overflow: TextOverflow.ellipsis,
              // ),
              background: Image.network(
                widget.document.imageURL,
                fit: BoxFit.cover,
                color: Colors.blue.withOpacity(0.7),
                colorBlendMode: BlendMode.overlay,
              ),
            ),
            actions: [
              if (_isDownloading)
                Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    value: _downloadProgress / 100,
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                IconButton(
                  icon: Icon(Icons.download),
                  onPressed: _downloadFile,
                ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Implement share functionality
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.document.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        widget.document.createdAt,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.picture_as_pdf, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        'PDF Document',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.document.content ??
                        'This document contains important information. Download to view full content.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Document Preview',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Divider(height: 24),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 500,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SfPdfViewer.network(
                 // widget.document.pdfUrl,
                 widget.document.pdfUrl,
                  controller: _pdfViewerController,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    // Document loaded callback
                  },
                  // onDocumentLoadFailed: (PdfDocumentLoadedDetails details) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('Failed to load PDF document')),
                  //   );
                  // },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_isDownloading)
                    LinearProgressIndicator(
                      value: _downloadProgress / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      // Expanded(
                      //   child: ElevatedButton.icon(
                      //     icon: Icon(Icons.download),
                      //     label: Text(_isDownloading ? 'Downloading...' : 'Download'),
                      //     style: ElevatedButton.styleFrom(
                      //       //primary: _isDownloading ? Colors.grey : Colors.blue.shade700,
                      //       padding: EdgeInsets.symmetric(vertical: 16),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //     ),
                      //     onPressed: _isDownloading ? null : _downloadFile,
                      //   ),
                      // ),
                      // SizedBox(width: 16),
                      // Expanded(
                      //   child: ElevatedButton.icon(
                      //     icon: Icon(Icons.print),
                      //     label: Text('Print'),
                      //     style: ElevatedButton.styleFrom(
                      //       //primary: Colors.green.shade700,
                      //       padding: EdgeInsets.symmetric(vertical: 16),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       // Print functionality
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated Document class with PDF URL and additional fields
class Document {
  final String title;
  final DateTime date;
  final String pdfUrl;
  final String? description;
  final String? fileSize;

  Document({
    required this.title,
    required this.date,
    required this.pdfUrl,
    this.description,
    this.fileSize,
  });
}