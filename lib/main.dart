import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xylophone',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Xylophone',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple,
                Colors.purple.shade300,
                Colors.pink.shade200,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: Note(getColor: Colors.red, getNote: 1, label: 'C')),
                  Expanded(child: Note(getColor: Colors.orange, getNote: 2, label: 'D')),
                  Expanded(child: Note(getColor: Colors.yellow, getNote: 3, label: 'E')),
                  Expanded(child: Note(getColor: Colors.green, getNote: 4, label: 'F')),
                  Expanded(child: Note(getColor: Colors.blue, getNote: 5, label: 'G')),
                  Expanded(child: Note(getColor: Colors.indigo, getNote: 6, label: 'A')),
                  Expanded(child: Note(getColor: Colors.purple, getNote: 7, label: 'B')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Note extends StatefulWidget {
  const Note({
    super.key,
    required this.getColor,
    required this.getNote,
    required this.label,
  });

  final Color getColor;
  final int getNote;
  final String label;

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playNote() async {
    setState(() {
      _isPressed = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    final player = AudioPlayer();
    await player.setSource(AssetSource('note${widget.getNote}.wav'));
    await player.resume();

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Material(
              elevation: _isPressed ? 2 : 8,
              borderRadius: BorderRadius.circular(15),
              shadowColor: widget.getColor.withOpacity(0.5),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: _playNote,
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.getColor,
                        widget.getColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
