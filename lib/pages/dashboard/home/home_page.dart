import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_platform.dart';
import '../../../widgets/gap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();

    return AppTabScaffold(
       backgroundColor: Color(0xFF5F67EA),
      body:SingleChildScrollView(
        child: Stack(
          children:[
           
           Column(
            children: [
              Container(
                color: Colors.red,
                height: 200
                ,
              )
            ,
            Container(
                decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                   )
                ),
             
              height: 700,
            )
              
                       

            ],
           )
            
           
          ]
        )
      ),
      
      // Padding(
      //   padding: const EdgeInsets.all(24),
      //   child: Obx(() {
      //     final name = auth.user.value?.displayName ?? 'toi';
      //     return Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         Text(
      //           'Bonjour $name',
      //           style: Theme.of(context).textTheme.headlineSmall,
      //         ),
      //         const VGap.sm(),
      //         const Text(
      //           'Trouve un partenaire pour réviser.',
      //           style: TextStyle(color: AppColors.textSecondary),
      //         ),
      //       ],
      //     );
      //   }),
      // ),
    );
  }
}
