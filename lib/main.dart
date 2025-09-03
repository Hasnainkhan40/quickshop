import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/views/splash_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY']!;
  Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //we are using getX so have to change this material app into germaterial app
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          //set the appbar color
          iconTheme: IconThemeData(color: darkFontGrey),
        ),
        fontFamily: regular,
      ),
      home: SplashScreen(),
    );
  }
}
