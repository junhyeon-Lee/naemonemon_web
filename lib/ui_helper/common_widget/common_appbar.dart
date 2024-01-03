import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/ui_helper/common_ui_helper.dart';

class CommonAppbar extends AppBar implements PreferredSizeWidget {
  CommonAppbar({super.key, required String title})
      : super(
            title: Stack(alignment: Alignment.center,
              children: [
                Positioned.fill(child: SizedBox(width: Get.width, height: 68,)),
                SizedBox(width: Get.width,
                  child: Row(
                    children: [
                      SizedBox(width: 20*screenRatio),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            width: 36*screenRatio,
                            height: 36,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                border: Border.all(color: const Color(0xfff4f4f2), width: 1)),
                            child: Center(
                                child: SvgPicture.asset(
                                  CIconPath.left,
                                  width: 26*screenRatio,
                                  color: const Color(0xffE0E0E0),
                                ))),
                      ),
                    ],
                  ),
                ),

                Positioned(child: Text(title,
                  style: CTextStyle.light26,
                )),

              ],
            ),
            centerTitle: true,
            elevation: 0,
            titleSpacing: 0,
            leadingWidth: 0,
    backgroundColor: Colors.white,
    leading: Container()
  );

  @override
  Size get preferredSize => Size.fromHeight(56*screenRatio);
}

