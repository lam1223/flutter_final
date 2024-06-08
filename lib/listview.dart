import 'package:flutter/material.dart';
import 'homepage.dart';
import 'usser.dart'; // Sửa tên file user.dart
import 'edit.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  late Future<List<Book>> theList;
  String search = '';

  @override
  void initState() {
    super.initState();
    theList = SaveData.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('Danh sách', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.red, width: 2)),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
            },
            icon: Icon(Icons.app_registration),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/anhnen.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Tìm kiếm",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.black,
                      filled: true,
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: FutureBuilder<List<Book>>(
                      future: theList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('ERROR: ${snapshot.error}');
                        } else {
                          final books = snapshot.data!.where((book) {
                            return book.id.contains(search) || book.name.contains(search);
                          }).toList();
                          return ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              return ListTile(
                                title: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text('ID: ${book.id}', style: TextStyle(color: Colors.white)),
                                      Text('Name: ${book.name}', style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ViewDetail(book: book)),
                                  );
                                },
                                onLongPress: () {
                                  showDeleteDialog(context, book);
                                },
                                // Thêm nút chỉnh sửa vào ListTile
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditBookPage(book: book)),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list, color: Colors.black),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Số lượng danh sách'),
                content: SizedBox(
                  height: 40,
                  width: 200,
                  child: FutureBuilder<List<Book>>(
                    future: SaveData.getBooks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('ERROR: ${snapshot.error}');
                      } else {
                        final books = snapshot.data!;
                        return Text('${books.length}');
                      }
                    },
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Đóng'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void showDeleteDialog(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa'),
          content: Text('Bạn có chắc chắn muốn xóa ${book.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await SaveData.deleteBook(book.id);
                  Navigator.of(context).pop();
                  setState(() {
                    theList = SaveData.getBooks();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Xóa thành công')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã xảy ra lỗi khi xóa')));
                }
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}

class ViewDetail extends StatelessWidget {
  final Book book;
  ViewDetail({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết',
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 6, 46, 179),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: const Color
                        .fromARGB(255, 243, 242, 242), width: 2)),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/anh.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            child: Container(
              alignment: Alignment.topCenter,
              width: 400,
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${book.id}', style: TextStyle(color: Colors.white, fontSize: 30)),
                  SizedBox(height: 40),
                  Text('Name: ${book.name}', style: TextStyle(color: Colors.white, fontSize: 25)),
                  Text('Category: ${book.category}', style: TextStyle(color: Colors.white, fontSize: 17)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditBookPage extends StatefulWidget {
  final Book book;

  EditBookPage({required this.book});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.book.name);
    _categoryController = TextEditingController(text: widget.book.category);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _updateBook() async {
    try {
      await SaveData.updateBook(widget.book.id, _nameController.text, _categoryController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật thành công')));
      Navigator.pop(context, true); // Trả về true nếu cập nhật thành công
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật thất bại: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa sách'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên sách'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Thể loại'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateBook,
              child: Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}

