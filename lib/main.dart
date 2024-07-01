import 'package:fb_chat_app/controller/datelable.dart';
import 'package:fb_chat_app/helper/auth_helper.dart';
import 'package:fb_chat_app/helper/firestore_helper.dart';
import 'package:fb_chat_app/utils/colors.dart';
import 'package:fb_chat_app/utils/current_utils.dart';
import 'package:fb_chat_app/utils/routes.dart';
import 'package:fb_chat_app/views/screen/chat_page.dart';
import 'package:fb_chat_app/views/screen/forgote_page.dart';
import 'package:fb_chat_app/views/screen/home_page.dart';
import 'package:fb_chat_app/views/screen/lets_get.dart';
import 'package:fb_chat_app/views/screen/profile_page.dart';
import 'package:fb_chat_app/views/screen/sign_page.dart';
import 'package:fb_chat_app/views/screen/splash_page.dart';
import 'package:fb_chat_app/views/screen/starmessage_page.dart';
import 'package:fb_chat_app/views/screen/update_profile.dart';
import 'package:fb_chat_app/views/screen/wigdet_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'modal/user_modal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (AuthHepler.authHepler.firebaseAuth.currentUser != null) {
    UserModal userModal = await FireStoreHelper.fireStoreHelper.getUserByEmail(
        email: AuthHepler.authHepler.firebaseAuth.currentUser!.email as String);
    CurrentUser.user = userModal;
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext) => DateLabelController(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // initialRoute: MyRoutes.splash,
        theme: ThemeData(
          colorSchemeSeed: darkBlue,
          useMaterial3: true,
        ),
        routes: {
          MyRoutes.sign: (context) => SignUp(),
          MyRoutes.home: (context) => HomePage(),
          MyRoutes.chat: (context) => ChatPage(),
          MyRoutes.forgot: (context) => ForgotePage(),
          MyRoutes.star: (context) => StarMessagePage(),
          MyRoutes.splash: (context) => SplashScreen(),
          MyRoutes.create: (context) => CreatePage(),
          MyRoutes.lets: (context) => LetsPage(),
          MyRoutes.widget: (context) => WidgetPage(),
          MyRoutes.update: (context) => UpdateProfilePage(),
        },
      ),
    ),
  );
}
