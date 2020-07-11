import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Grid List';
    
    return MaterialApp(
      title: title,
      home: Minesweeper()
    );
  }
}
 class Minesweeper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height-kToolbarHeight) / 18;
    final double itemWidth = (size.width) / 10;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double heightofimage=height/18;
    double widthofimage=width/10;
    debugPrint("heightofimage+$heightofimage");
    return Scaffold(
        backgroundColor:Color.fromRGBO(0xB0, 0xB0, 0xB0,1),
        body:Center(
          child: new Container(
            height: itemHeight*18+20,
            child:  GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  childAspectRatio:itemWidth/itemHeight
                ),
                padding:const EdgeInsets.only(top:20.0,bottom: 20.0),
                itemCount: 180,
                itemBuilder: (context, index) {
                  return GridTile(child: Image.asset(
                        'images/facingDown.png',
                      ),
                  );
                },
              ),
          )

        )
      );
  }
  
 }