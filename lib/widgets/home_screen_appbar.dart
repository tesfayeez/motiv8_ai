import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/user_controllers.dart';
import 'package:motiv8_ai/screens/account_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';

class CustomHomeScreenAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  final String message;
  final Color appBarColor;
  final Color textColor;

  CustomHomeScreenAppBar({
    required this.message,
    required this.appBarColor,
    required this.textColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(70.0);
  void _showCalanderModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: FractionallySizedBox(
            heightFactor: .55,
            child: CalendarView(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
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
          backgroundColor: appBarColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: ListTile(
            trailing: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _showCalanderModal(context);
              },
              child: SvgPicture.asset(
                color: theme.colorScheme.primary,
                'assets/uit_calender.svg',
                width: 30,
              ),
            ),
            title: Text(
              'Welcome',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
            subtitle: Text(
              userName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: textColor,
              ),
            ),
            leading: GestureDetector(
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
                  height: 45,
                  width: 45,
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
          ),
        );
      },
    );
  }
}
// Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 IntrinsicWidth(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Welcome $userName',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: textColor,
//                         ),
//                       ),
//                       Text(
//                         DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: textColor,
//                         ),
//                       ),
//                       Text(
//                         message,
//                         style: GoogleFonts.poppins(
//                           fontSize: 10,
//                           color: textColor.withOpacity(0.8),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onLongPress: () {
//                     pickImage();
//                   },
//                   onTap: () {
//                     Navigator.of(context).push(AccountScreen.route());
//                   },
//                   child: CachedNetworkImage(
//                     imageUrl: profilePicUrl.isNotEmpty
//                         ? profilePicUrl
//                         : "http://via.placeholder.com/200x150",
//                     imageBuilder: (context, imageProvider) => Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: imageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     placeholder: (context, url) => Icon(Icons.image),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//               ],
//             ),
//           )