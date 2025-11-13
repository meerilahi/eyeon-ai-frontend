import 'package:flutter/material.dart';
import '../models/camera.dart';
import '../services/supabase_service.dart';

class CamerasController extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<Camera> _cameras = [];
  bool _isLoading = false;

  List<Camera> get cameras => _cameras;
  bool get isLoading => _isLoading;

  Future<void> loadCameras() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cameras = await _supabaseService.getCameras();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCamera(String name, String rtspUrl) async {
    try {
      final camera = await _supabaseService.addCamera(name, rtspUrl);
      _cameras.add(camera);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateCamera(String id, String name, String rtspUrl) async {
    try {
      await _supabaseService.updateCamera(id, name, rtspUrl);
      final index = _cameras.indexWhere((c) => c.id == id);
      if (index != -1) {
        _cameras[index] = Camera(
          id: id,
          name: name,
          rtspUrl: rtspUrl,
          createdAt: _cameras[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteCamera(String id) async {
    try {
      await _supabaseService.deleteCamera(id);
      _cameras.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
