import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_icons/flutter_icons.dart';
//import 'package:hurriyat_radio/blocs/ads_bloc.dart';
import 'package:hurriyat_radio/blocs/bookmark_bloc.dart';
import 'package:hurriyat_radio/blocs/sign_in_bloc.dart';
import 'package:hurriyat_radio/blocs/theme_bloc.dart';
import 'package:hurriyat_radio/models/custom_color.dart';
import 'package:hurriyat_radio/models/video_model.dart';
import 'package:hurriyat_radio/services/app_service.dart';
import 'package:hurriyat_radio/utils/cached_image.dart';
import 'package:hurriyat_radio/utils/sign_in_dialog.dart';
import 'package:hurriyat_radio/widgets/html_body.dart';
// import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

class VideoArticleDetails extends StatefulWidget {
  final VideoModel? data;
  const VideoArticleDetails({Key? key, required this.data}) : super(key: key);

  @override
  _VideoArticleDetailsState createState() => _VideoArticleDetailsState();
}

class _VideoArticleDetailsState extends State<VideoArticleDetails> {
  double rightPaddingValue = 130;
  late YoutubePlayerController _controller;

  initYoutube() async {
    _controller = YoutubePlayerController(
        initialVideoId: widget.data!.video_link!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
          loop: true,
          controlsVisibleAtStart: false,
          enableCaption: false,
        ));
  }

  void _handleShare() {
    final sb = context.read<SignInBloc>();
    final String _shareTextAndroid =
        '${widget.data!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';
    final String _shareTextiOS =
        '${widget.data!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';

    // if (Platform.isAndroid) {
    //   Share.share(_shareTextAndroid);
    // } else {
    //   Share.share(_shareTextiOS);
    // }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onBookmarkIconClick(widget.data!.createdAt);
    }
  }

  // _initInterstitialAds() {
  //   final adb = context.read<AdsBloc>();
  //   Future.delayed(Duration(milliseconds: 0)).then((value) {
  //     if (adb.interstitialAdEnabled == true) {
  //       context.read<AdsBloc>().loadAds();
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    initYoutube();
    //_initInterstitialAds();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final VideoModel d = widget.data!;

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        if (Platform.isAndroid) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        }
      },
      player: YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9,
        showVideoProgressIndicator: true,
        thumbnail: CustomCacheImage(imageUrl: d.imageURL, radius: 0),
        topActions: [
          IconButton(
            icon:
                Icon(Icons.keyboard_arrow_left, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          null == null
              ? Container()
              : IconButton(
                  icon: Icon(Icons.mic_external_off,
                      size: 22, color: Colors.white),
                  onPressed: ()=>{
                        // () => AppService()
                        // .openLinkWithCustomTab(context, 'link external')

                  },
                ),
          IconButton(
            icon: Icon(Icons.share, size: 22, color: Colors.white),
            onPressed: () {
              _handleShare();
            },
          ),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
            body: Column(
          children: [
            SafeArea(top: true, bottom: false, child: player),
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        context.watch<ThemeBloc>().darkTheme ==
                                                false
                                            ? CustomColor().loadingColorLight
                                            : CustomColor().loadingColorDark,
                                  ),
                                  child: AnimatedPadding(
                                    duration: Duration(milliseconds: 1000),
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: rightPaddingValue,
                                        top: 5,
                                        bottom: 5),
                                    child: Text(
                                      d.video_type!,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                              Spacer(),
                              // IconButton(
                              //     icon: BuildLoveIcon(
                              //         collectionName: 'contents',
                              //         uid: sb.uid,
                              //         timestamp: d.createdAt),
                              //     onPressed: () {
                              //       //handleLoveClick();
                              //     }),
                              // IconButton(
                              //     icon: BuildBookmarkIcon(
                              //         collectionName: 'contents',
                              //         uid: sb.uid,
                              //         timestamp: d.createdAt),
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
                              Icon(Icons.date_range,
                                  size: 20, color: Colors.grey),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                d.createdAt!,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
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
                                d.views.toString(),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            d.title!,
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
                          //     padding: MaterialStateProperty.resolveWith(
                          //         (states) =>
                          //             EdgeInsets.only(left: 10, right: 10)),
                          //     backgroundColor:
                          //         MaterialStateProperty.resolveWith((states) =>
                          //             Theme.of(context).primaryColor),
                          //     shape: MaterialStateProperty.resolveWith(
                          //         (states) => RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(3))),
                          //   ),
                          //   icon: Icon(Icons.message,
                          //       color: Colors.white, size: 20),
                          //   label: Text('comments',
                          //           style: TextStyle(color: Colors.white))
                          //       .tr(),
                          //   onPressed: () {
                          //     // nextScreen(context,
                          //     //     CommentsPage(timestamp: d.createdAt));
                          //   },
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //views feature
                              // ViewsCount(
                              //   article: d,
                              // ),
                              SizedBox(
                                width: 20,
                              ),

                              // LoveCount(
                              //     collectionName: 'contents',
                              //     timestamp: d.createdAt),
                            ],
                          ),
                        ],
                      ),
                    ),
                    HtmlBodyWidget(
                      content: d.content!,
                      isIframeVideoEnabled: false,
                      isVideoEnabled: false,
                      isimageEnabled: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //     padding: EdgeInsets.all(20),
                    //     child: RelatedArticles(
                    //       category: d.video_type,
                    //       timestamp: d.createdAt,
                    //       replace: true,
                    //     )),
                  ],
                ),
              ),
            ),
          ],
        ));
      },
    );
  }
}
