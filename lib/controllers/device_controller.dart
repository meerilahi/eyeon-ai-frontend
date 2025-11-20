import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/supabase_service.dart';

class DeviceController extends ChangeNotifier {
  SupabaseService? _service;
  DeviceController(this._service);

  set service(SupabaseService? service) => _service = service;

  List<Device> _devices = [];
  bool _isLoading = false;

  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;

  Future<void> loadDevices() async {
    _isLoading = true;
    notifyListeners();
    try {
      _devices = await _service!.getDevices();
    } catch (e) {
      debugPrint('DeviceController: Error loading devices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDevice({
    required String name,
    required String type,
    required String ipAddress,
    required String port,
    required String username,
    required String password,
  }) async {
    try {
      final device = await _service!.addDevice(
        name: name,
        type: type,
        ipAddress: ipAddress,
        port: port,
        username: username,
        password: password,
      );
      _devices.add(device);
      notifyListeners();
    } catch (e) {
      debugPrint('DeviceController: Error adding device: $e');
    }
  }

  Future<void> updateDevice(Device device) async {
    try {
      await _service!.updateDevice(device);
      final index = _devices.indexWhere((d) => d.deviceId == device.deviceId);
      if (index != -1) {
        _devices[index] = device;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('DeviceController: Error updating device: $e');
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      await _service!.deleteDevice(deviceId);
      _devices.removeWhere((d) => d.deviceId == deviceId);
      notifyListeners();
    } catch (e) {
      debugPrint('DeviceController: Error deleting device: $e');
    }
  }

  Future<void> addCamera(String deviceId, String name, String rtspUrl) async {
    try {
      final camera = await _service!.addCamera(deviceId, name, rtspUrl);
      final device = _devices.firstWhere((d) => d.deviceId == deviceId);
      device.cameras.add(camera);
      notifyListeners();
    } catch (e) {
      debugPrint('DeviceController: Error adding camera: $e');
    }
  }

  Future<void> updateCamera(
    String deviceId,
    String cameraId,
    String name,
    String rtspUrl,
  ) async {
    try {
      await _service!.updateCamera(cameraId, name, rtspUrl);
      final device = _devices.firstWhere((d) => d.deviceId == deviceId);
      final index = device.cameras.indexWhere((c) => c.cameraId == cameraId);
      if (index != -1) {
        device.cameras[index] = Camera(
          cameraId: cameraId,
          name: name,
          rtspUrl: rtspUrl,
          createdAt: device.cameras[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('DeviceController: Error updating camera: $e');
    }
  }

  Future<void> deleteCamera(String deviceId, String cameraId) async {
    try {
      await _service!.deleteCamera(cameraId);
      final device = _devices.firstWhere((d) => d.deviceId == deviceId);
      device.cameras.removeWhere((c) => c.cameraId == cameraId);
      notifyListeners();
    } catch (e) {
      debugPrint('DeviceController: Error deleting camera: $e');
    }
  }

  void clearData() {
    _devices.clear();
    _isLoading = false;
  }
}
