import 'package:flutter/material.dart';
import '../element/custom_input.dart';  // Import custom_input.dart
import '../databases/DatabaseHelper.dart';  // Import DatabaseHelper

class InputDataPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();  // Controller untuk alamat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data Dosen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Nama Dosen
            CustomInput(
              labelText: 'Nama Dosen',
              icon: Icons.person,
              controller: namaController,
            ),

            // Input No HP Dosen
            CustomInput(
              labelText: 'No HP Dosen',
              icon: Icons.phone,
              controller: noHpController,
              keyboardType: TextInputType.phone,  // Menampilkan keyboard angka untuk no HP
            ),

            // Input Email Dosen
            CustomInput(
              labelText: 'Email Dosen',
              icon: Icons.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,  // Menampilkan keyboard email
            ),

            // Input Alamat Dosen
            CustomInput(
              labelText: 'Alamat Dosen',
              icon: Icons.home,
              controller: alamatController,
              keyboardType: TextInputType.streetAddress,  // Menampilkan keyboard teks untuk alamat
            ),

            SizedBox(height: 20),

            // Tombol Simpan
            ElevatedButton(
              onPressed: () async {
                // Ambil data dari controller
                String nama = namaController.text;
                String noHp = noHpController.text;
                String email = emailController.text;
                String alamat = alamatController.text;

                if (nama.isEmpty || noHp.isEmpty || email.isEmpty || alamat.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Harap lengkapi semua field')),
                  );
                } else {
                  // Simpan data ke SQLite
                  Map<String, String> dosenData = {
                    'nama': nama,
                    'noHp': noHp,
                    'email': email,
                    'alamat': alamat,
                  };

                  await DatabaseHelper().insertDosen(dosenData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data berhasil disimpan')),
                  );

                  // Reset input fields setelah berhasil
                  namaController.clear();
                  noHpController.clear();
                  emailController.clear();
                  alamatController.clear();
                }
              },
              child: Text('Simpan Data'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
