import 'package:flutter/material.dart';
import '../databases/DatabaseHelper.dart';  // Import DatabaseHelper
import '../element/custom_input.dart';      // Import CustomInput

class DataDosenPage extends StatefulWidget {
  @override
  _DataDosenPageState createState() => _DataDosenPageState();
}

class _DataDosenPageState extends State<DataDosenPage> {
  late Future<List<Map<String, dynamic>>> dataDosenFuture;

  @override
  void initState() {
    super.initState();
    dataDosenFuture = DatabaseHelper().getAllDosen();
  }

  // Fungsi untuk memperbarui data dosen
  void _refreshData() {
    setState(() {
      dataDosenFuture = DatabaseHelper().getAllDosen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Dosen'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dataDosenFuture, // Mengambil data dosen dari SQLite
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data dosen'));
          } else {
            final dataDosen = snapshot.data!; // Ambil data dosen yang berhasil diambil

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: dataDosen.length,
                itemBuilder: (context, index) {
                  final dosen = dataDosen[index];

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        child: Icon(Icons.person),
                      ),
                      title: Text(dosen['nama']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text('No HP: ${dosen['noHp']}'),
                          Text('Email: ${dosen['email']}'),
                          Text('Alamat: ${dosen['alamat']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  // Menampilkan dialog untuk edit data dosen
  void _showEditDialog(BuildContext context, Map<String, dynamic> dosen) {
    TextEditingController namaController = TextEditingController(text: dosen['nama']);
    TextEditingController noHpController = TextEditingController(text: dosen['noHp']);
    TextEditingController emailController = TextEditingController(text: dosen['email']);
    TextEditingController alamatController = TextEditingController(text: dosen['alamat']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Data Dosen'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CustomInput(
                  labelText: 'Nama Dosen',
                  icon: Icons.person,
                  controller: namaController,
                ),
                CustomInput(
                  labelText: 'No HP Dosen',
                  icon: Icons.phone,
                  controller: noHpController,
                  keyboardType: TextInputType.phone,
                ),
                CustomInput(
                  labelText: 'Email Dosen',
                  icon: Icons.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomInput(
                  labelText: 'Alamat Dosen',
                  icon: Icons.home,
                  controller: alamatController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, String> updatedDosen = {
                  'nama': namaController.text,
                  'noHp': noHpController.text,
                  'email': emailController.text,
                  'alamat': alamatController.text,
                };
                await DatabaseHelper().updateDosen(dosen['id'], updatedDosen);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data dosen berhasil diperbarui')),
                );
                _refreshData(); // Memperbarui UI setelah data diperbarui
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
