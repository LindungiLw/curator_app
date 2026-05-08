import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/colors.dart';
import '../../blocs/curator/curator_bloc.dart';
import '../../blocs/curator/curator_event.dart';
import '../../blocs/curator/curator_state.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // Variabel untuk menampung foto hasil jepretan
  File? _selectedImage;

  // Fungsi untuk membuka Kamera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Kamu bisa ganti ImageSource.camera menjadi ImageSource.gallery jika ingin ambil dari galeri
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidianBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.silverAsh),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Digitize Artifact',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            color: AppColors.silverAsh,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOMBOL KAMERA YANG SUDAH BERFUNGSI
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.midnightBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.amethystGlow.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                // Menampilkan foto jika sudah memotret, atau menampilkan ikon jika belum
                child:
                    _selectedImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                        : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 50,
                              color: AppColors.amethystGlow,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Tap to capture artifact',
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'ARTIFACT DETAILS',
              style: TextStyle(
                color: AppColors.amethystGlow,
                letterSpacing: 2.0,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildGlassInput(
              'Artifact Title',
              'e.g., Vintage 1980s Polaroid',
              _titleController,
            ),
            const SizedBox(height: 16),
            _buildGlassInput(
              'Category',
              'e.g., Camera, Sneaker, Antique',
              _categoryController,
            ),

            const SizedBox(height: 40),

            BlocConsumer<CuratorBloc, CuratorState>(
              listener: (context, state) {
                if (state is CuratorLoaded) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Artifact archived to Vault!'),
                      backgroundColor: AppColors.amethystGlow,
                    ),
                  );
                } else if (state is CuratorError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                bool isLoading = state is CuratorLoading;

                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.amethystGlow.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                // Hanya bisa di-save jika teks TIDAK kosong dan FOTO sudah ada
                                if (_titleController.text.isNotEmpty &&
                                    _categoryController.text.isNotEmpty &&
                                    _selectedImage != null) {
                                  context.read<CuratorBloc>().add(
                                    AddCuratorItem(
                                      title: _titleController.text,
                                      category: _categoryController.text,
                                      imagePath:
                                          _selectedImage!
                                              .path, // Mengirim jalur file foto aslinya!
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill all fields and take a photo!',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amethystGlow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.auto_awesome, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Generate AI Story',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassInput(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.midnightBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white54),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
