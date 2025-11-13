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

  Future<List<Camera>> fetchCameras() async {
    return await _supabaseService.getCameras();
  }

  Future<void> addCamera(
    String name,
    String description,
    String rtspUrl,
  ) async {
    try {
      final camera = await _supabaseService.addCamera(
        name,
        description,
        rtspUrl,
      );
      _cameras.add(camera);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateCamera(
    String id,
    String name,
    String description,
    String rtspUrl,
  ) async {
    try {
      await _supabaseService.updateCamera(id, name, description, rtspUrl);
      final index = _cameras.indexWhere((c) => c.cameraId == id);
      if (index != -1) {
        _cameras[index] = Camera(
          cameraId: id,
          name: name,
          description: description,
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
      _cameras.removeWhere((c) => c.cameraId == id);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
