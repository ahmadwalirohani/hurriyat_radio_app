import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:hurriyat_radio/blocs/weekly_bloc.dart';
import 'package:hurriyat_radio/utils/next_screen.dart';
import 'package:provider/provider.dart';

import 'package:easy_localization/easy_localization.dart';

class Weekly extends StatefulWidget {
  Weekly({Key? key}) : super(key: key);

  @override
  _WeeklyState createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly>
    with AutomaticKeepAliveClientMixin {
  ScrollController? controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _orderBy = 'timestamp';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      context
          .read<WeeklyBloc>()
          .getData(mounted, _orderBy, true, context.locale);
    });
  }


  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<WeeklyBloc>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<WeeklyBloc>().setLoading(true);
        context.read<WeeklyBloc>().getData(mounted, _orderBy, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final vb = context.watch<WeeklyBloc>();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('hurriyat weekly news').tr(),
      //   centerTitle: false,
      // ),
     appBar: AppBar(
        title: const Text('hurriyat weekly news').tr() ,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ Color.fromARGB(255, 56, 129, 254),  Color.fromARGB(255, 56, 129, 254)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: vb.data.length,
          itemBuilder: (context, index) {
            final document = vb.data[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(bottom: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  navigateToWeeklyDetailsScreen(context, document);
                  // Handle document tap
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // PDF Icon Container
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red.shade600,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      // Title and Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              document.title ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              document.createdAt,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Download/View button
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                            size: 18, color: Colors.blue.shade600),
                        onPressed: () {
                          // Handle view action
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
