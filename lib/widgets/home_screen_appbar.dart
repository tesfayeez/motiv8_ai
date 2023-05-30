import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/user_controllers.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';

class CustomHomeScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String message;

  CustomHomeScreenAppBar({required this.message});

  @override
  Size get preferredSize => Size.fromHeight(100.0);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentUserModel = ref.watch(currentUserModelProvider);
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
                Flexible(
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
                Spacer(),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: profilePicUrl.isNotEmpty
                      ? NetworkImage(profilePicUrl)
                      : null,
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
