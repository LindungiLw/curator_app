import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'curator_event.dart';
import 'curator_state.dart';
import '../../data/models/curator_item.dart';

class CuratorBloc extends Bloc<CuratorEvent, CuratorState> {
  final supabase = Supabase.instance.client;

  CuratorBloc() : super(CuratorInitial()) {

    // LOGIKA LOAD DATA
    on<LoadCuratorItems>((event, emit) async {
      emit(CuratorLoading());
      try {
        final data = await supabase
            .from('curator_items')
            .select()
            .order('created_at', ascending: false);

        final items = (data as List).map((e) => CuratorItem.fromJson(e)).toList();
        emit(CuratorLoaded(items: items));
      } catch (e) {
        emit(CuratorError(message: "Gagal memuat Gallery Vault."));
      }
    });

    // LOGIKA UPLOAD FOTO & SIMPAN DATA
    on<AddCuratorItem>((event, emit) async {
      emit(CuratorLoading());
      try {
        // 1. Siapkan File Foto dari Kamera
        final file = File(event.imagePath);
        final fileExtension = event.imagePath.split('.').last;
        final fileName = 'artifact_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

        // 2. Upload ke Supabase Storage (Bucket 'artifact_images')
        await supabase.storage
            .from('artifact_images')
            .upload(fileName, file);

        // 3. Dapatkan Link URL Foto yang sudah online
        final String finalImageUrl = supabase.storage
            .from('artifact_images')
            .getPublicUrl(fileName);

        // 4. Simulasi Narasi AI
        String aiStory = "Artifact ini adalah saksi bisu sejarah yang sangat berharga dalam kategori ${event.category}.";

        // 5. Simpan semua data (Teks + Link Foto) ke Tabel Database
        final newItem = CuratorItem(
          id: '', // Diisi otomatis oleh Supabase
          title: event.title,
          category: event.category,
          imageUrl: finalImageUrl,
          aiNarrative: aiStory,
          createdAt: DateTime.now(),
        );

        await supabase.from('curator_items').insert(newItem.toMap());

        // 6. Refresh layar Dashboard
        add(LoadCuratorItems());
      } catch (e) {
        emit(CuratorError(message: "Gagal memproses artefak."));
      }
    });
  }
}