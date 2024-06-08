import 'package:flutter/material.dart';
import 'usser.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _namect = TextEditingController();
  final _categoryct = TextEditingController();
  String book_id = '';

  void reset() {
    _namect.clear();
    _categoryct.clear();
  }

  void adds() async {
    try {
      await SaveData.addBook(_namect.text, _categoryct.text);
      final books = await SaveData.getBooks();
      book_id = books.last.id;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('thành công')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("thất bại")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Đăng ký sách", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          toolbarHeight: 80,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.blueAccent, width: 2))),
          ),
          actions: <Widget>[
            IconButton(onPressed: reset, icon: Icon(Icons.refresh))
          ]),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/anhnen2.jpg'),
                  fit: BoxFit.cover)),
        ),
        Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(15),
          height: 700,
          decoration: BoxDecoration(
              color: Colors.black54,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(15)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _namect,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: "nhập tên",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.black,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2))),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _categoryct,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: "nhập thể loại",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.black,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2))),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: adds,
                      child: Text(
                        'đăng kí',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.black),
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Colors.white, width: 2))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/list');
                      },
                      child: Text(
                        'danh sách',
                        style: TextStyle(color: Color.fromARGB(255, 3, 248, 105)),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.black),
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Colors.white, width: 2))),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
