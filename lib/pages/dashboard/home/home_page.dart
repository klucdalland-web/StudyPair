import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/app_platform.dart';
import '../../../widgets/gap.dart';
import 'widgets/categorieSection.dart';
import 'widgets/demandesrecentes.dart';
import 'widgets/header.dart';
import 'widgets/search.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
