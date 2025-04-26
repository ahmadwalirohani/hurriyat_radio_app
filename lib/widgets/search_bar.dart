import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hurriyat_radio/blocs/sign_in_bloc.dart';
import 'package:hurriyat_radio/pages/profile.dart';
import 'package:hurriyat_radio/pages/search.dart';
import 'package:hurriyat_radio/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
      height: 65,
      //color: Colors.green,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: CircleAvatar(
                radius: 22,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundImage: sb.guestUser
                    ? CachedNetworkImageProvider(sb.defaultUserImageUrl)
                    : const CachedNetworkImageProvider(
                        'https://img.icons8.com/?size=100&id=kDqO6kPb3xLj&format=png&color=000000')), //sb.imageUrl!
            onTap: () {
            
            },
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 10),
                height: 40,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(color: Colors.grey[400]!, width: 0.5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  'search news'.tr(),
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              onTap: () {
                nextScreen(context, SearchPage());
              },
            ),
          ),
        ],
      ),
    );
  }
}
