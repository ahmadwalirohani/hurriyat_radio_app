import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:hurriyat_radio/blocs/gallery_bloc.dart';
import 'package:hurriyat_radio/models/gallery_model.dart';
import 'package:hurriyat_radio/utils/cached_image_with_dark.dart';
import 'package:hurriyat_radio/utils/empty.dart';
import 'package:hurriyat_radio/utils/loading_cards.dart';
import 'package:hurriyat_radio/widgets/zoomable_image_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class Gallery extends StatefulWidget {
  Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<GalleryBloc>().setLoading(true);

      context.read<GalleryBloc>().getData(mounted, true, context.locale);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<GalleryBloc>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<GalleryBloc>().setLoading(true);
        context.read<GalleryBloc>().getData(mounted, false, context.locale);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cb = context.watch<GalleryBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('gallery').tr(),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.rotate_90_degrees_ccw, //Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () {
              context.read<GalleryBloc>().onRefresh(mounted);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        child: cb.hasData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  EmptyPage(
                      icon: Icons.paste, //Feather.clipboard,
                      message: 'no Gallery found'.tr(),
                      message1: ''),
                ],
              )
            : GridView.builder(
                controller: controller,
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 15, bottom: 15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.1),
                itemCount: cb.data.length != 0 ? cb.data.length + 1 : 10,
                itemBuilder: (_, int index) {
                  if (index < cb.data.length) {
                    return _ItemList(d: cb.data[index]);
                  }
                  return Opacity(
                    opacity: cb.isLoading ? 1.0 : 0.0,
                    child: true //cb.lastVisible == null
                        ? LoadingCard(height: null)
                        : Center(
                            child: SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: new CupertinoActivityIndicator()),
                          ),
                  );
                },
              ),
        onRefresh: () async {
          context.read<GalleryBloc>().onRefresh(
                mounted,
              );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ItemList extends StatelessWidget {
  final GalleryModel d;
  const _ItemList({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 3),
              color: Theme.of(context).shadowColor,
            ),
          ],
        ),
        child: Stack(
          children: [
            Hero(
              tag: 'image${d.createdAt}',
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: CustomCacheImageWithDarkFilterBottom(
                  imageUrl: d.imageURL,
                  radius: 8.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(left: 10, bottom: 15, right: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2681FF)
                        .withOpacity(0.7), // Background color
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                  ),
                  child: Text(
                    d.location.toString().tr(),
                    style: TextStyle(
                      fontSize: 14, // Adjust font size as needed
                      color: Colors.white, // Text color
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ZoomableImageScreen(
              imageUrl: d.imageURL,
              title: d.location.toString(),
              info: d.caption.toString(),
            ),
          ),
        );
      },
    );
  }
}
