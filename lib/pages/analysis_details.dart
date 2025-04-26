import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
//import 'package:hurriyat_radio/blocs/ads_bloc.dart';
import 'package:hurriyat_radio/blocs/bookmark_bloc.dart';
import 'package:hurriyat_radio/blocs/sign_in_bloc.dart';
import 'package:hurriyat_radio/blocs/theme_bloc.dart';
import 'package:hurriyat_radio/models/analysis_model.dart';
import 'package:hurriyat_radio/models/article.dart';
import 'package:hurriyat_radio/models/custom_color.dart';
import 'package:hurriyat_radio/models/news_model.dart';
import 'package:hurriyat_radio/pages/comments.dart';
import 'package:hurriyat_radio/services/app_service.dart';
import 'package:hurriyat_radio/utils/cached_image.dart';
import 'package:hurriyat_radio/utils/sign_in_dialog.dart';
//import 'package:hurriyat_radio/widgets/banner_ad_admob.dart'; //admob
//import 'package:hurriyat_radio/widgets/banner_ad_fb.dart';      //fb ad
import 'package:hurriyat_radio/widgets/bookmark_icon.dart';
import 'package:hurriyat_radio/widgets/html_body.dart';
import 'package:hurriyat_radio/widgets/love_count.dart';
import 'package:hurriyat_radio/widgets/love_icon.dart';
import 'package:hurriyat_radio/widgets/related_articles.dart';
import 'package:hurriyat_radio/widgets/views_count.dart';
// import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import '../utils/next_screen.dart';

class AnalysisDetails extends StatefulWidget {
  final AnalysisModel? data;
  final String? tag;

  const AnalysisDetails({Key? key, required this.data, required this.tag})
      : super(key: key);

  @override
  _AnalysisDetailsState createState() => _AnalysisDetailsState();
}

class _AnalysisDetailsState extends State<AnalysisDetails> {
  double rightPaddingValue = 130;

  void _handleShare() {
    final sb = context.read<SignInBloc>();
    final String shareTextAndroid =
        '${widget.data!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';
    final String shareTextiOS =
        '${widget.data!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';

    // if (Platform.isAndroid) {
    //   Share.share(shareTextAndroid);
    // } else {
    //   Share.share(shareTextiOS);
    // }
  }

  handleLoveClick() {
    bool guestUser = context.read<SignInBloc>().guestUser;

    if (guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onLoveIconClick(widget.data!.createdAt);
    }
  }

  handleBookmarkClick() {
    bool guestUser = context.read<SignInBloc>().guestUser;

    if (guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onBookmarkIconClick(widget.data!.createdAt);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final AnalysisModel article = widget.data!;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: true,
          top: false,
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    _customAppBar(article, context),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Spacer(),
                                        // IconButton(
                                        //     icon: BuildLoveIcon(
                                        //         collectionName: 'contents',
                                        //         uid: sb.uid,
                                        //         timestamp: article.createdAt),
                                        //     onPressed: () {
                                        //       handleLoveClick();
                                        //     }),
                                        // IconButton(
                                        //     icon: BuildBookmarkIcon(
                                        //         collectionName: 'contents',
                                        //         uid: sb.uid,
                                        //         timestamp: article.createdAt),
                                        //     onPressed: () {
                                        //       handleBookmarkClick();
                                        //     }),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.person_2_outlined,
                                            size: 20, color: Colors.grey),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          article.user_name!,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(CupertinoIcons.timer,
                                            size: 18, color: Colors.grey),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          article.createdAt!,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      article.title!,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.6,
                                          wordSpacing: 1),
                                    ),
                                    Divider(
                                      color: Theme.of(context).primaryColor,
                                      endIndent: 200,
                                      thickness: 2,
                                      height: 20,
                                    ),
                                    // TextButton.icon(
                                    //   style: ButtonStyle(
                                    //     padding:
                                    //         MaterialStateProperty.resolveWith(
                                    //             (states) => EdgeInsets.only(
                                    //                 left: 10, right: 10)),
                                    //     backgroundColor:
                                    //         MaterialStateProperty.resolveWith(
                                    //             (states) => Theme.of(context)
                                    //                 .primaryColor),
                                    //     shape:
                                    //         MaterialStateProperty.resolveWith(
                                    //             (states) =>
                                    //                 RoundedRectangleBorder(
                                    //                     borderRadius:
                                    //                         BorderRadius
                                    //                             .circular(3))),
                                    //   ),
                                    //   icon: Icon(
                                    //       Icons
                                    //           .message, //Feather.message_circle,
                                    //       color: Colors.white,
                                    //       size: 20),
                                    //   label: Text('comments',
                                    //           style: TextStyle(
                                    //               color: Colors.white))
                                    //       .tr(),
                                    //   onPressed: () {
                                    //     nextScreen(
                                    //         context,
                                    //         CommentsPage(
                                    //             timestamp: article.createdAt));
                                    //   },
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        //views feature
                                        // ViewsCount(
                                        //   article: article,
                                        // ),
                                        SizedBox(
                                          width: 20,
                                        ),

                                        // LoveCount(
                                        //     collectionName: 'contents',
                                        //     timestamp: article.createdAt),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              HtmlBodyWidget(
                                content: article.content!,
                                isIframeVideoEnabled: true,
                                isVideoEnabled: true,
                                isimageEnabled: true,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          // Container(
                          //     padding: EdgeInsets.all(20),
                          //     child: RelatedArticles(
                          //       category: article.category,
                          //       timestamp: article.createdAt,
                          //       replace: true,
                          //       locale: context.locale,
                          //     )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // -- Banner ads --

              //  context.watch<AdsBloc>().bannerAdEnabled == false
              Container()
              //: BannerAdAdmob() //admob
              //: BannerAdFb()    //fb
            ],
          ),
        ));
  }

  SliverAppBar _customAppBar(AnalysisModel article, BuildContext context) {
    return SliverAppBar(
      pinned: true, // Ensures the AppBar stays fixed when scrolling
      expandedHeight: 270,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.tag == null
            ? CustomCacheImage(imageUrl: article.imageURL, radius: 0.0)
            : Hero(
                tag: widget.tag!,
                child:
                    CustomCacheImage(imageUrl: article.imageURL, radius: 0.0),
              ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.keyboard_backspace,
            size: 22, color: Color.fromARGB(255, 3, 0, 0)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        false == null
            ? Container()
            : IconButton(
                icon: const Icon(Icons.mic_external_off,
                    size: 22, color: Color.fromARGB(255, 5, 0, 0)),
                onPressed: () => {
                  // AppService()
                  //     .openLinkWithCustomTab(context, 'http://google.com')
                },
              ),
        IconButton(
          icon: const Icon(Icons.share,
              size: 22, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            _handleShare();
          },
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
