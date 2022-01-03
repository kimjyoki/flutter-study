import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Bottom Navigation Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

// static const TextStyle optionStyle = TextStyle( fontSize: 30, fontWeight: FontWeight.bold );
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text('index 0 Home', style: optionStyle),
  //   Text('index 1 Business', style: optionStyle),
  //   Text('index 2 School', style: optionStyle)
  // ];

  var a = 1;
  final List<String> contacts = <String>['김영숙', '홍길동', '엘리자베스', '메리'];
  //final List<String> contacts = [];
  final List<int> likeCount = [0, 0, 0, 0];

  final Map<int, String> contactMap = {
    0: '김영숙',
    1: '홍길동',
    2: '엘리자베스',
    3: '메리',
  };

  // int integer = 1;
  // String str = 'test str';
  // double pi = 3.1425;
  // bool foo = false;

  @override
  void initState() {
    super.initState();
  }

  Future getContacts() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      var contactResponse = await ContactsService.getContacts();
      // setState(() {
      //   contacts = contactResponse;
      // });
    } else {
      // openAppSettings();
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onIncrement() {
    setState(() {
      a += 1;
    });
  }

  void addContact(String name) {
    setState(() {
      contacts.add(name);
    });
  }

  void addContactFromMap(String name) {
    setState(() {
      contactMap[contacts.length + 1] = name;
      likeCount.add(0);
    });
  }

  @override
  Widget build(BuildContext context) {
// late TextEditingController _controller;

    // @override
    // void initState() {
    //   super.initState();
    //   _controller = TextEditingController();
    // }
    //
    // @override
    // void dispose() {
    //   _controller.dispose();
    //   super.dispose();
    // }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[const Text('Bottom Navi'), Text(contacts.length.toString())],
        ),
        actions: [
          IconButton(
            onPressed: () {
              getContacts();
            },
            icon: const Icon(Icons.contacts),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_box),
        onPressed: () =>
            showDialog<String>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) =>
                  DialogUI(contacts: contacts, amount: a, addContactFromMap: addContactFromMap),
            ),
      ),
      body: ListView.builder(
        itemCount: contactMap.length,
        itemBuilder: (c, i) {
          return ListTile(
            // leading: Text(likeCount[i].toString()),
            leading: const Icon(Icons.account_circle),
            title: Row(
              children: [
                Text(likeCount[i].toString() + ' '),
                Text(contactMap[i].toString()),
              ],
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(5.0),
                primary: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  likeCount[i] += 1;
                });
              },
              child: const Text('Like'),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class DialogUI extends StatefulWidget {
  const DialogUI({Key? key, required this.contacts, required this.amount, required this.addContactFromMap})
      : super(key: key);

  final List<String> contacts;
  final int amount;
  final ValueSetter<String> addContactFromMap;

  @override
  State<DialogUI> createState() => _DialogUIState();
}

class _DialogUIState extends State<DialogUI> {
  final _controller = TextEditingController();
  final _contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dialog Header'),
      content: Wrap(
        runSpacing: 20,
        children: <Widget>[
          TextField(
            controller: _contactController,
            obscureText: false,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
          ),
          // TextField(
          //   controller: _controller,
          //   obscureText: true,
          //   decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
          // ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(widget.contacts[1]),
          onPressed: () => widget.addContactFromMap(_contactController.text),
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, 'Cancel'),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context, 'OK'),
        )
      ],
    );
  }
}
