import 'package:flutter/material.dart';
import 'usser.dart';

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
        title: Text(
          'Chỉnh sửa sách',
          style: TextStyle(color: Colors.white), // Thiết lập màu cho tiêu đề
        ),
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
