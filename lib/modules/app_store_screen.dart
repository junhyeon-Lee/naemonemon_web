import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/ui_helper/common_ui_helper.dart';
import 'package:shovving_web/util/safe_print.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AppStoreScreen extends StatefulWidget {
  const AppStoreScreen({Key? key}) : super(key: key);

  @override
  State<AppStoreScreen> createState() => _AppStoreScreenState();
}



class _AppStoreScreenState extends State<AppStoreScreen> {
  List<String> imageList = [CIconPath.gateWay5,CIconPath.gateWay6,CIconPath.gateWay7,CIconPath.gateWay8,CIconPath.gateWay9];
  late ScrollController scrollController;
  bool isAddImage = false;
  @override
  void initState() {
    scrollController = ScrollController();
    Future.delayed(const Duration(seconds: 1),(){scroll();});
    super.initState();
  }



  scroll() async {
    safePrint('돌리기');
    await scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(seconds: 15), curve: Curves.linear).whenComplete((){

        safePrint(imageList.length);
        imageList.add(CIconPath.gateWay5);
        imageList.add(CIconPath.gateWay6);
        imageList.add(CIconPath.gateWay7);
        imageList.add(CIconPath.gateWay8);
        imageList.add(CIconPath.gateWay9);
        safePrint(imageList.length);
        setState(() {});

        Future.delayed(const Duration(milliseconds: 100),(){
          scroll();});



    });
  }

  reScroll() async {
    // safePrint('다시돌리기');
    // await scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(seconds: 10), curve: Curves.ease).whenComplete((){
    //   safePrint(imageList.length);
    //   imageList.add(CIconPath.gateWay5);
    //   imageList.add(CIconPath.gateWay6);
    //   imageList.add(CIconPath.gateWay7);
    //   imageList.add(CIconPath.gateWay8);
    //   imageList.add(CIconPath.gateWay9);
    //   safePrint(imageList.length);
    //   setState(() {});
    //   scroll();
    // });


  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SizedBox(width: 390*screenRatio, height: Get.height,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Stack(alignment: Alignment.bottomCenter,
              children: [
                Image.asset(CIconPath.gateWay1,width: 390*screenRatio ),
                Positioned(
                  bottom: 33*screenRatio,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            final url = Uri.parse('https://play.google.com/store/apps/details?id=com.naemo.nemon');
                            if (await canLaunchUrl(url)) {
                              launchUrl(url, mode: LaunchMode.externalApplication);
                            } else {
                              // ignore: avoid_print
                              print("Can't launch $url");
                            }
                          },
                          child: Image.asset(CIconPath.gateWay2,width: 156*screenRatio )),
                      SizedBox(width: 18*screenRatio,),
                      Image.asset(CIconPath.gateWay3,width: 156*screenRatio ),
                    ],
                  ),
                ),
              ],
            ),

            Container( width: 390*screenRatio, height: 338*screenRatio,
            color: CColor.lightGray,
              child:  ListView.builder(
                controller:  scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10*screenRatio),
                    child: Image.asset(imageList[index],width: 180*screenRatio,),
                  );
                },
              )


            ),

            Image.asset(CIconPath.gateWay4,width: 390*screenRatio ),




          ],
        ),
      ),
    );
  }
}
