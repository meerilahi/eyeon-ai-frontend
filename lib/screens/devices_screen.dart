import 'package:eyeon_ai_frontend/models/device.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/device_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  // Device fields
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceTypeController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Camera fields
  final TextEditingController _cameraNameController = TextEditingController();
  final TextEditingController _rtspController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceController>().loadDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceController = context.watch<DeviceController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: deviceController.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : deviceController.devices.isEmpty
            ? _buildEmptyState(context)
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: deviceController.devices.length,
                itemBuilder: (context, index) {
                  final device = deviceController.devices[index];
                  return _buildDeviceCard(device);
                },
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddDeviceDialog(context),
          backgroundColor: Colors.red.shade600,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Device'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.devices_rounded, size: 64, color: Colors.white60),
          const SizedBox(height: 24),
          const Text(
            'No Devices Found',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first device to start monitoring',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddDeviceDialog(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Device'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        title: Text(
          device.name,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        subtitle: Text(
          device.type,
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
        trailing: IconButton(
          icon: Icon(Icons.settings, color: Colors.blue.shade300),
          onPressed: () => _showEditDeviceDialog(context, device),
        ),
        children: [
          _buildCameraList(device),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showAddCameraDialog(context, device.deviceId),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text(
                  'Add Camera',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraList(device) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: device.cameras.length,
      itemBuilder: (context, index) {
        final camera = device.cameras[index];
        return ListTile(
          title: Text(camera.name, style: const TextStyle(color: Colors.white)),
          subtitle: Text(
            camera.rtspUrl,
            style: TextStyle(color: Colors.white70),
          ),
          trailing: Wrap(
            spacing: 10,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () =>
                    _showEditCameraDialog(context, device.deviceId, camera),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.shade400,
                ),
                onPressed: () => _showDeleteCameraDialog(
                  context,
                  device.deviceId,
                  camera.cameraId,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // -----------------------------
  // ADD DEVICE
  // -----------------------------
  void _showAddDeviceDialog(BuildContext context) {
    _deviceNameController.clear();
    _deviceTypeController.clear();
    _ipController.clear();
    _portController.clear();
    _usernameController.clear();
    _passwordController.clear();

    _openDialog(
      title: "Add New Device",
      content: Column(
        children: [
          CustomTextField(controller: _deviceNameController, label: 'Name'),
          const SizedBox(height: 12),
          CustomTextField(controller: _deviceTypeController, label: 'Type'),
          const SizedBox(height: 12),
          CustomTextField(controller: _ipController, label: 'IP Address'),
          const SizedBox(height: 12),
          CustomTextField(controller: _portController, label: 'Port'),
          const SizedBox(height: 12),
          CustomTextField(controller: _usernameController, label: 'Username'),
          const SizedBox(height: 12),
          CustomTextField(controller: _passwordController, label: 'Password'),
        ],
      ),
      buttonText: "Add Device",
      onPressed: () {
        context.read<DeviceController>().addDevice(
          name: _deviceNameController.text,
          type: _deviceTypeController.text,
          ipAddress: _ipController.text,
          port: _portController.text,
          username: _usernameController.text,
          password: _passwordController.text,
        );
        Navigator.pop(context);
      },
    );
  }

  // -----------------------------
  // EDIT DEVICE
  // -----------------------------
  void _showEditDeviceDialog(BuildContext context, device) {
    _deviceNameController.text = device.name;
    _deviceTypeController.text = device.type;
    _ipController.text = device.ipAddress;
    _portController.text = device.port;
    _usernameController.text = device.username;
    _passwordController.text = device.password;

    _openDialog(
      title: "Edit Device",
      content: Column(
        children: [
          CustomTextField(controller: _deviceNameController, label: 'Name'),
          const SizedBox(height: 12),
          CustomTextField(controller: _deviceTypeController, label: 'Type'),
          const SizedBox(height: 12),
          CustomTextField(controller: _ipController, label: 'IP Address'),
          const SizedBox(height: 12),
          CustomTextField(controller: _portController, label: 'Port'),
          const SizedBox(height: 12),
          CustomTextField(controller: _usernameController, label: 'Username'),
          const SizedBox(height: 12),
          CustomTextField(controller: _passwordController, label: 'Password'),
        ],
      ),
      buttonText: "Save Changes",
      onPressed: () {
        Device updatedDevice = device.copyWith(
          name: _deviceNameController.text,
          type: _deviceTypeController.text,
          ipAddress: _ipController.text,
          port: _portController.text,
          username: _usernameController.text,
          password: _passwordController.text,
        );
        context.read<DeviceController>().updateDevice(updatedDevice);
        Navigator.pop(context);
      },
    );
  }

  // -----------------------------
  // ADD CAMERA
  // -----------------------------
  void _showAddCameraDialog(BuildContext context, String deviceId) {
    _cameraNameController.clear();
    _rtspController.clear();

    _openDialog(
      title: "Add Camera",
      content: Column(
        children: [
          CustomTextField(controller: _cameraNameController, label: 'Name'),
          const SizedBox(height: 12),
          CustomTextField(controller: _rtspController, label: 'RTSP URL'),
        ],
      ),
      buttonText: "Add Camera",
      onPressed: () {
        context.read<DeviceController>().addCamera(
          deviceId,
          _cameraNameController.text,
          _rtspController.text,
        );
        Navigator.pop(context);
      },
    );
  }

  // -----------------------------
  // EDIT CAMERA
  // -----------------------------
  void _showEditCameraDialog(BuildContext context, String deviceId, camera) {
    _cameraNameController.text = camera.name;
    _rtspController.text = camera.rtspUrl;

    _openDialog(
      title: "Edit Camera",
      content: Column(
        children: [
          CustomTextField(controller: _cameraNameController, label: 'Name'),
          const SizedBox(height: 12),
          CustomTextField(controller: _rtspController, label: 'RTSP URL'),
        ],
      ),
      buttonText: "Save Changes",
      onPressed: () {
        context.read<DeviceController>().updateCamera(
          deviceId,
          camera.cameraId,
          _cameraNameController.text,
          _rtspController.text,
        );
        Navigator.pop(context);
      },
    );
  }

  // -----------------------------
  // DELETE CAMERA
  // -----------------------------
  void _showDeleteCameraDialog(
    BuildContext context,
    String deviceId,
    String cameraId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Delete Camera',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this camera?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DeviceController>().deleteCamera(deviceId, cameraId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // REUSABLE DIALOG
  // -----------------------------
  void _openDialog({
    required String title,
    required Widget content,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              content,
              const SizedBox(height: 24),
              CustomButton(text: buttonText, onPressed: onPressed),
            ],
          ),
        ),
      ),
    );
  }
}
