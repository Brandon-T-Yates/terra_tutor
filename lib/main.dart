import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'Global_Elements/textbox.dart';

void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{ 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData
      (
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
{
  int _counter = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _incrementCounter() 
  {
    setState(() 
    {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            const Text
            (
              'You have pushed the button this many times:',
            ),
            Text
            (
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const CustomTextField
            (
              text: "Test for textbox code.\n" 
              "Lorem ipsum dolor sit amet, in omnis viderer\naccommodare nec, cibo officiis deseruisse ad nec.\n"
              "Qui albucius suscipit voluptaria in, sea cu putant\ncopiosae moderatius, sed admodum minimum\nmolestiae ne. "
              "Mei persius vivendum in, probo\nvoluptaria no nam. Est te stet vero, eu nostrud\ninermis eam. "
              "Duo wisi percipitur an, ei platonem\nrecteque sed. At fugit decore est. "
              "Ad regione\nantiopam duo, vix quidam dictas postulant ei. \nElitr quando eum ea. "
              "Duo ei epicurei constituto\nhonestatis, qualisque urbanitas sed et.\n"
              "Mel ei dicat populo accusam, et dolores\ninimicus vis.",
              height: 360.0,
              width: 400.0,
              fontColor: Colors.black,
              boxColor: Color.fromARGB(0, 224, 224, 224),
            ),
            UserInputTextBox
            (
              hint: 'Enter you name',
              fontColor: Colors.black,
              boxColor: const Color.fromARGB(0, 224, 224, 224),
              inputOption: UserInputOption.name,
              controller: nameController,
            ),
            UserInputTextBox
            (
              hint: 'Enter you email',
              fontColor: Colors.black,
              boxColor: const Color.fromARGB(0, 224, 224, 224),
              inputOption: UserInputOption.name,
              controller: emailController,
            ),
            UserInputTextBox
            (
              hint: 'Enter you password',
              fontColor: Colors.black,
              boxColor: const Color.fromARGB(0, 224, 224, 224),
              inputOption: UserInputOption.name,
              controller: passwordController,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton
      (
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


