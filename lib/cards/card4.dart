import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hurriyat_radio/models/article.dart';
import 'package:hurriyat_radio/models/news_model.dart';
import 'package:hurriyat_radio/models/video_model.dart';
import 'package:hurriyat_radio/utils/cached_image.dart';
import 'package:hurriyat_radio/utils/next_screen.dart';
import 'package:hurriyat_radio/widgets/video_icon.dart';

class Card4 extends StatelessWidget {
  final dynamic d;
  final String heroTag;
  final bool isVideo;
  const Card4(
      {Key? key, required this.d, required this.heroTag, required this.isVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    height: 90,
                    width: 90,
                    child: Hero(
                        tag: heroTag,
                        child: CustomCacheImage(
                            imageUrl: d.imageURL, radius: 5.0))),
                VideoIcon(
                  contentType: isVideo ? 'video' : 'content',
                  iconSize: 40,
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title!,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.time_solid,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          d.createdAt!,
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 13),
                        ),
                        Spacer(),
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(d.views.toString(),
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 13)),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () => navigateToDetailsScreen(context, d, heroTag, isVideo),
    );
  }
}
