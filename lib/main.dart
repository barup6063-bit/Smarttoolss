import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'image_tool.dart';
import 'text_tool.dart';
import 'video_tool.dart';
import 'pdf_tool.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  BannerAd? _banner;
  @override void initState() {
    super.initState();
    _banner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner, request: AdRequest(),
      listener: BannerAdListener())..load();
  }
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SmartTools ID")),
      body: Column(children: [
        ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ImageTool())), child: Text("Image Tools")),
        ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>TextTool())), child: Text("Text Tools")),
        ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>VideoTool())), child: Text("Video Tools")),
        ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>PdfTool())), child: Text("PDF Tools")),
        Spacer(),
        if(_banner!=null) Container(height:50, child: AdWidget(ad:_banner!)),
      ]),
    );
  }
}
