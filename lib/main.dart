import 'package:flutter/material.dart';
import 'package:learning/constants/app_constant.dart';
import 'package:learning/controller/preference_controller.dart';
import 'package:learning/view/home.dart';
import 'package:learning/view/login.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceController.initPreference();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        PreferenceController.getBoolean(AppConstant.isLoggedIn);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.purple,
          appBarTheme: AppBarTheme(
              color: Colors.purple,
              elevation: 4,
              centerTitle: false,
              iconTheme: const IconThemeData(color: Colors.white, size: 16),
              foregroundColor: Colors.white, //<-
              titleTextStyle: Theme.of(context).textTheme.bodyMedium),
          inputDecorationTheme: InputDecorationTheme(
            prefixIconColor: Theme.of(context).iconTheme.color,
            suffixIconColor: Theme.of(context).iconTheme.color,
            filled: true,
            hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
          iconTheme: IconThemeData(
            size: 16,
            color: Theme.of(context).primaryColor,
          )),
      home: isLoggedIn ? const HomePage() : Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IO.Socket socket;
  List<String> messages = List.empty(growable: true);
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    initSocket();
    super.initState();
  }

  initSocket() {
    socket = IO.io(
        'http://192.168.21.7:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    socket.onConnect((_) {
      socket.emit('userReady', 100);
    });
    socket.on('message', (detail) {
      setState(() {
        messages.add(detail as String);
      });
    });
    socket.on('userList', (detail) {
      final userList = detail as List<dynamic>;
      setState(() {
        messages.clear();
        for (var value in userList) {
          messages.add('${value['id'] as int}');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _controller,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          socket.emit('message', _controller.text);
                          _controller.clear();
                        },
                        child: const Text('Send'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
