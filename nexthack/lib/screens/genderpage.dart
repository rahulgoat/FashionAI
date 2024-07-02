import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nexthack/screens/imagepickscreen.dart';

class genderpage extends StatefulWidget {
  const genderpage({super.key});

  @override
  State<genderpage> createState() => _genderpageState();
}

class _genderpageState extends State<genderpage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _controller1;
  late Animation<double> _animation1;

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation1 = CurvedAnimation(
      parent: _controller1,
      curve: Curves.decelerate,
    );

    _controller1.forward();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/genderpage.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
            height: 800,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FadeTransition(
                      opacity: _animation1,
                      alwaysIncludeSemantics: false,
                      child: SlideTransition(
                        textDirection: TextDirection.ltr,
                        position: Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset(0, 0),
                        ).animate(_animation1),
                        child: Container(
                          height: 500,
                          width: double.maxFinite,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            backgroundBlendMode: BlendMode.difference,
                            color: Color.fromRGBO(114, 80, 161, 1),
                            borderRadius: BorderRadiusDirectional.vertical(
                                top: Radius.elliptical(360, 190)),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color.fromRGBO(114, 80, 161, 1),
                                  Color.fromARGB(255, 138, 79, 152),
                                ]),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _animation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.purple,
                                            Colors.transparent
                                          ],
                                          stops: [0.5, 1],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.purple.withOpacity(0.6),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.black,
                                        child: Image.asset(
                                          'assets/logo.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 100),
                              Text(
                                'Could you share your preferred gender identity, if you feel comfortable?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              SizedBox(height: 50),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                controller: _textEditingController,
                                autocorrect: true,
                                expands: false,
                                decoration: InputDecoration(
                                  hintText: 'Enter your gender',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  counterStyle: TextStyle(color: Colors.white),
                                  filled: false,
                                  fillColor: Colors.grey[400],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              ElevatedButton(
                                onPressed: () {
                                  String gender = _textEditingController.text;
                                  if (gender.isNotEmpty) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImagePickScreen(
                                                      gender: gender)));
                                    });
                                    _textEditingController.clear();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                ),
                                child: Text(
                                  'Let\'s go Genie  ✨',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
