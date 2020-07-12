import 'dart:math';

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
class Square{
  bool hasbomb;
  int bombsaround;
  Square({this.hasbomb=false,this.bombsaround=0});
}
enum ImageType {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  bomb,
  facingDown,
  flagged,
}
class Minesweeper extends StatefulWidget{
  @override
  _MinesweeperState createState() => _MinesweeperState();

}
 class _MinesweeperState extends State<Minesweeper>{
  @override
  void initState() {
    super.initState();
    initializeGame();
  }
  initializeGame()
  {
    debugPrint("hello");
    board=List.generate(row, (index) =>  List.generate(coloumn, (index) => Square()));
    openedSquare=List.generate(row*coloumn, (index) => false);
    bombscount=0;
    squaresLeft=row*coloumn;
    //Randomly generating bombs
    Random random=new Random();
    for(int i=0;i<row;i++)
      {
        for(int j=0;j<coloumn;j++)
          {
            int probability=random.nextInt(15);
                if(probability<3)
                  {
                    board[i][j].hasbomb=true;
                    bombscount++;
                  }
          }
      }
    debugPrint("total bombs $bombscount");
//
      for(int i=0;i<row;i++)
        {
          for(int j=0;j<coloumn;j++)
            {
                if(i-1>=0 && j-1>=0)
                  {
                     if(board[i-1][j-1].hasbomb)
                       board[i][j].bombsaround++;
                  }
                if(i-1>=0)
                  {
                     if(board[i-1][j].hasbomb)
                       board[i][j].bombsaround++;
                  }
                if(i-1>=0 && j+1<coloumn)
                  {
                    if(board[i-1][j+1].hasbomb)
                       board[i][j].bombsaround++;
                  }
                if(j-1>0)
                  {
                    if(board[i][j-1].hasbomb)
                       board[i][j].bombsaround++;
                  }
                if(j-1>0 && i+1<row)
                  {
                    if(board[i+1][j-1].hasbomb)
                       board[i][j].bombsaround++;
                  }
                if(j+1<coloumn)
                  {
                    if(board[i][j+1].hasbomb)
                       board[i][j].bombsaround++;
                  }
                if(i+1<row)
                  {
                    if(board[i+1][j].hasbomb)
                       board[i][j].bombsaround++;
                  }
                if(i+1<row && j+1<coloumn)
                  {
                    if(board[i+1][j+1].hasbomb)
                       board[i][j].bombsaround++;
                  }
            }
        }
      setState(() {
      });
  }
  handleTap(int rowindex,int coloumnindex,int index)
  {
    if(board[rowindex][coloumnindex].hasbomb)
      {
        showbombsquares();
      }
    if(board[rowindex][coloumnindex].bombsaround==0)
      {
        checkneighboursquares(rowindex, coloumnindex);
      }
    else
      {
        setState(() {
      openedSquare[index]=true;
      squaresLeft--;
         });
      }
    if(squaresLeft<=bombscount)
      {
        handleWin();
      }
  }

  checkneighboursquares(int i,int j)
  {
    int position = (i * coloumn) + j;
    openedSquare[position] = true;
    squaresLeft = squaresLeft - 1;
    if(i-1>=0)
      {
        if(!board[i-1][j].hasbomb && !openedSquare[(i-1)*coloumn+j])
          {
             if (board[i-1][j].bombsaround == 0)
            checkneighboursquares(i-1, j);
          }
      }
    if(j-1>=0)
      {
        if(!board[i][j-1].hasbomb && !openedSquare[(i)*coloumn+j-1])
          {
            if (board[i][j-1].bombsaround == 0)
            checkneighboursquares(i, j-1);
          }
      }
    if(i+1<row)
      {
        if(!board[i+1][j].hasbomb && !openedSquare[(i+1)*coloumn+j])
          {
            if (board[i+1][j].bombsaround == 0)
            checkneighboursquares(i+1, j);
          }
      }
    if(j+1<coloumn)
      {
        if(!board[i][j+1].hasbomb && !openedSquare[(i)*coloumn+j+1])
          {
            if (board[i][j+1].bombsaround == 0)
            checkneighboursquares(i, j+1);
          }
      }
    setState(() {});
  }
  List<List<Square>> board;
  List<bool> openedSquare;
  int row=18;
  int coloumn=10;
  int bombscount;
  int squaresLeft;
  @override
  Widget build(BuildContext context) {
     var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height-kToolbarHeight) / row;
    final double itemWidth = (size.width) / coloumn;
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
                itemCount: row*coloumn,
                itemBuilder: (context, index) {
                    Image image;
                    int rowNumber = (index / coloumn).floor();
                    int columnNumber = (index % coloumn);
                    if(!openedSquare[index])
                      {
                        image=getImage(ImageType.facingDown);
                      }
                    else
                      {
                        if(board[rowNumber][columnNumber].hasbomb)
                          {
                            image=getImage(ImageType.bomb);
                          }
                        else
                          {
                            image=getImage(getImageTypeFromNumber(board[rowNumber][columnNumber].bombsaround));
                          }
                      }
                  return InkWell(child: image,onTap: (){handleTap(rowNumber,columnNumber,index);},
                  );
                },
              ),
          )

        )
      );
  }
  Image getImage(ImageType type) {
    switch (type) {
      case ImageType.zero:
        return Image.asset('images/0.png');
      case ImageType.one:
        return Image.asset('images/1.png');
      case ImageType.two:
        return Image.asset('images/2.png');
      case ImageType.three:
        return Image.asset('images/3.png');
      case ImageType.four:
        return Image.asset('images/4.png');
      case ImageType.five:
        return Image.asset('images/5.png');
      case ImageType.six:
        return Image.asset('images/6.png');
      case ImageType.seven:
        return Image.asset('images/7.png');
      case ImageType.eight:
        return Image.asset('images/8.png');
      case ImageType.bomb:
        return Image.asset('images/bomb.png');
      case ImageType.facingDown:
        return Image.asset('images/facingDown.png');
      default:
        return null;
    }
  }

  ImageType getImageTypeFromNumber(int number) {
    switch (number) {
      case 0:
        return ImageType.zero;
      case 1:
        return ImageType.one;
      case 2:
        return ImageType.two;
      case 3:
        return ImageType.three;
      case 4:
        return ImageType.four;
      case 5:
        return ImageType.five;
      case 6:
        return ImageType.six;
      case 7:
        return ImageType.seven;
      case 8:
        return ImageType.eight;
      default:
        return null;
    }
  }
   void handleGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over!"),
          content: Text("You stepped on a mine!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                initializeGame();
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
  }

  void handleWin() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You Win!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                initializeGame();
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
  }

  void showbombsquares() {
    for(int i=0;i<row;i++)
      {
       for(int j=0;j<coloumn;j++)
         {
           if(board[i][j].hasbomb)
             {
                setState(() {
                  openedSquare[i*coloumn+j]=true;
                  squaresLeft--;
                });
             }
         }
      }
     handleGameOver();
  }
 }