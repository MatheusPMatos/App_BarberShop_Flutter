// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dw_barbershop/src/core/ui/icons/barberchop_icons.dart';
import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';

class AvatarWidget extends StatelessWidget {

  final  bool hideUploadedButton;

  const AvatarWidget({
    Key? key,
     this.hideUploadedButton  = false,
  }) : super(key: key);

   @override
   Widget build(BuildContext context) {
       return SizedBox(
        width: 102,
        height: 102,
         child: Stack(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(ImageConstants.avatar))
              ),
            ),
            Positioned(
              bottom: -5,
              right: -5,
              child: IconButton(onPressed: () {
                
              }, icon: Offstage(
                offstage: hideUploadedButton,
                child: Container(
                  
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: ColorsConstants.brow, width: 2)
                  ),
                  child:const  Icon(BarbershopIcons.addEmployee, color: ColorsConstants.brow, size: 20,)),
              )),
            )
          ],
         ),
       );
  }
}
