import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/colors.dart';
import '../../blocs/curator/curator_bloc.dart';
import '../../blocs/curator/curator_state.dart';
import 'add_item_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidianBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIGITAL VAULT',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 2.0,
                          fontFamily: 'Inter',
                          color: AppColors.amethystGlow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your Gallery',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Playfair Display',
                          color: AppColors.silverAsh,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.midnightBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.amethystGlow.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.silverAsh,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Search Bar dengan Glassmorphism
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.midnightBlue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const TextField(
                      style: TextStyle(
                        color: AppColors.silverAsh,
                        fontFamily: 'Inter',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search artifacts...',
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: AppColors.amethystGlow),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // BACA DATA DARI DATABASE
              Expanded(
                child: BlocBuilder<CuratorBloc, CuratorState>(
                  builder: (context, state) {
                    if (state is CuratorLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.amethystGlow,
                        ),
                      );
                    } else if (state is CuratorLoaded) {
                      if (state.items.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.museum_outlined,
                                size: 60,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Your vault is empty.',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            // Jarak antar card diperlebar
                            decoration: BoxDecoration(
                              color: AppColors.midnightBlue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- UPDATE: AREA FOTO ARTEFAK ---
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: Container(
                                    height: 180,
                                    width: double.infinity,
                                    color: AppColors.obsidianBlack.withOpacity(
                                      0.5,
                                    ),
                                    // Sementara memunculkan ikon jika fotonya masih data bohongan (dummy)
                                    // Nanti akan otomatis memunculkan foto asli jika link Supabase dimasukkan
                                    child:
                                        item.imagePath == 'dummy_image.jpg' ||
                                                item.imagePath.isEmpty
                                            ? const Center(
                                              child: Icon(
                                                Icons.image_outlined,
                                                size: 50,
                                                color: Colors.white24,
                                              ),
                                            )
                                            : Image.network(
                                              item.imagePath,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.white24,
                                                  ),
                                            ),
                                  ),
                                ),
                                // --- END AREA FOTO ---

                                // Area Teks (Judul, Kategori, Cerita)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'Playfair Display',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.amethystGlow
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              item.category,
                                              style: const TextStyle(
                                                color: AppColors.amethystGlow,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        item.aiNarrative ??
                                            'No story generated.',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                          height: 1.5,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: Text('Error loading vault.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.amethystGlow.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: AppColors.amethystGlow,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemScreen()),
            );
          },
          child: const Icon(Icons.add_a_photo, color: Colors.white),
        ),
      ),
    );
  }
}
