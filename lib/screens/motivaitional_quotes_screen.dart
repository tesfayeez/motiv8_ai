import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/quotes_controllers.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

GlobalKey _globalKey = GlobalKey();

class MotivationalQuotesScreen extends ConsumerWidget {
  MotivationalQuotesScreen({Key? key}) : super(key: key);

  final List<String> quotes = [
    "Set your goals high, and don't stop till you get there. - Bo Jackson",
    "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
    "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
    "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
    "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
    "The harder you work for something, the greater you'll feel when you achieve it. - Unknown",
    "Believe you can and you're halfway there. - Theodore Roosevelt",
    "Success is not in what you have, but who you are. - Bo Bennett",
    "Dream big and dare to fail. - Norman Vaughan",
    "The journey of a thousand miles begins with a single step. - Lao Tzu",
    "Stay focused, go after your dreams, and keep moving toward your goals. - LL Cool J",
    "Don't be afraid to give up the good to go for the great. - John D. Rockefeller",
    "The only way to do great work is to love what you do. - Steve Jobs",
    "Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful. - Albert Schweitzer",
    "The future depends on what you do today. - Mahatma Gandhi",
    "The only person you are destined to become is the person you decide to be. - Ralph Waldo Emerson",
    "Success is walking from failure to failure with no loss of enthusiasm. - Winston Churchill",
    "The secret to getting ahead is getting started. - Mark Twain",
    "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
    "Don't let the fear of losing be greater than the excitement of winning. - Robert Kiyosaki",
  ];
  Future<void> shareQuote() async {
    try {
      final boundary = _globalKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final imageFile = File('$tempPath/quote.png');
      await imageFile.writeAsBytes(pngBytes);

      final xFile = XFile(imageFile.path);
      await Share.shareXFiles([xFile]);
    } catch (e) {
      print('Error sharing quote: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    final quotesController = ref.watch(quotesControllerProvider);
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        body: Stack(
          children: [
            GridView.count(
              crossAxisCount: 2,
              children: List.generate(8, (index) {
                return Opacity(
                  opacity: index < 6 ? 0.3 : 0.3,
                  child: SvgPicture.asset('assets/logo_svg.svg'),
                );
              }),
            ),
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.height * 0.4,
                        decoration: goalCardDecoration(theme.colorScheme
                                .background // Customize the background color if needed
                            ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              quotes[index],
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.colorScheme
                                    .tertiary, // Customize the text color if needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    FloatingActionButton(
                      backgroundColor: theme.colorScheme.background,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        shareQuote();
                      },
                      child: Icon(
                        Icons.adaptive.share,
                        color: theme.colorScheme.tertiary,
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
