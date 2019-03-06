import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

//types of animation
//- Tween
//- Physics based

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//use SingleTickerProviderStateMixin for a single animationController
//use TickerProviderStateMixin for a class with multiple animation controllers
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    //init animationController using screen's vsync and a duration to complete
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    //init a tween animation
    //animation = Tween<double>(begin: 20.0, end: 100.0).animate(animationController);

    //init a color animation and attach it to the animationController
    animation = ColorTween(begin: Colors.blue, end: Colors.orange)
        .animate(animationController);

    //start the animation
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Color animation"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //AnimatedLogo holds the bulk of the widgets to be animated
            //while animationController holds the logic for controlling the animation
            AnimatedLogo(animation: animation),

            //flatbutton lets user forward or reverse an animation
            FlatButton(
              child: Text("Reverse animation"),
              color: Colors.white,
              onPressed: () {
                animationController.isCompleted
                    ? animationController.reverse()
                    : animationController.forward();
              },
            )
          ]),
      ),
    );
  }

  //dispose the animation controller when done
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}



//this class contains the widgets that will be animated which extends AnimatedWidget which
//rebuilds itself when given the listenable: property
class AnimatedLogo extends AnimatedWidget {

  //the constructor
  AnimatedLogo({Key key, @required Animation animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<Color> animation = listenable;

    //multiple widgets controlled by the same controller
    return Column(
      children: <Widget>[
        Container(
          height: 100, //animation.value,
          width: 100, //animation.value,
          child: FlutterLogo(),
          //changes the color according to the animation values
          color: animation.value,
        ),
        Container(
          child: Placeholder(),
          height: 200,
          width: 200,
          //changes the color according to the animation values
          color: animation.value,
        )
      ],
    );
  }
}
