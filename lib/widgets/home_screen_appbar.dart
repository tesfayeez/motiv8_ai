import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/user_controllers.dart';
import 'package:motiv8_ai/screens/account_screen.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';

class CustomHomeScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String message;

  CustomHomeScreenAppBar({required this.message});

  @override
  Size get preferredSize => Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentUseris = ref.watch(currentUserProvider);
        final currentUserModel =
            ref.watch(currentUserModelProvider(currentUseris!));
        final userName = currentUserModel.when(
          data: (user) => capitalize(user?.name ?? 'User'),
          loading: () => '', // Placeholder value during loading state
          error: (_, __) => '', // Placeholder value on error
        );
        final profilePicUrl = currentUserModel.when(
          data: (user) => user?.profilePic ?? '',
          loading: () => '', // Placeholder value during loading state
          error: (_, __) => '', // Placeholder value on error
        );

        return AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome $userName',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        message,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onLongPress: () {
                    pickImage();
                  },
                  onTap: () {
                    Navigator.of(context).push(AccountScreen.route());
                  },
                  child: CachedNetworkImage(
                    imageUrl: profilePicUrl.isNotEmpty
                        ? profilePicUrl
                        : "http://via.placeholder.com/200x150",
                    imageBuilder: (context, imageProvider) => Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Icon(Icons.image),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
