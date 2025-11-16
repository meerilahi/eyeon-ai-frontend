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
    debugPrint('CamerasController: Loading cameras');
    _isLoading = true;
    notifyListeners();
    try {
      _cameras = await _supabaseService.getCameras();
      debugPrint('CamerasController: Loaded ${_cameras.length} cameras');
    } catch (e) {
      debugPrint('CamerasController: Error loading cameras: $e');
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Camera>> fetchCameras() async {
    debugPrint('CamerasController: Fetching cameras');
    try {
      final cameras = await _supabaseService.getCameras();
      debugPrint('CamerasController: Fetched ${cameras.length} cameras');
      return cameras;
    } catch (e) {
      debugPrint('CamerasController: Error fetching cameras: $e');
      rethrow;
    }
  }

  Future<void> addCamera(
    String name,
    String description,
    String rtspUrl,
  ) async {
    debugPrint('CamerasController: Adding camera: $name');
    try {
      final camera = await _supabaseService.addCamera(
        name,
        description,
        rtspUrl,
      );
      _cameras.add(camera);
      debugPrint('CamerasController: Added camera: ${camera.cameraId}');
      notifyListeners();
    } catch (e) {
      debugPrint('CamerasController: Error adding camera: $e');
      // Handle error
    }
  }

  Future<void> updateCamera(
    String id,
    String name,
    String description,
    String rtspUrl,
  ) async {
    debugPrint('CamerasController: Updating camera: $id');
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
        debugPrint('CamerasController: Updated camera: $id');
      }
    } catch (e) {
      debugPrint('CamerasController: Error updating camera: $e');
      // Handle error
    }
  }

  Future<void> deleteCamera(String id) async {
    debugPrint('CamerasController: Deleting camera: $id');
    try {
      await _supabaseService.deleteCamera(id);
      _cameras.removeWhere((c) => c.cameraId == id);
      notifyListeners();
      debugPrint('CamerasController: Deleted camera: $id');
    } catch (e) {
      debugPrint('CamerasController: Error deleting camera: $e');
      // Handle error
    }
  }

  void clearData() {
    debugPrint('CamerasController: Clearing data');
    _cameras.clear();
    _isLoading = false;
    notifyListeners();
  }
}
