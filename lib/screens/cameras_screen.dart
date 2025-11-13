import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cameras_controller.dart';
import '../models/camera.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class CamerasScreen extends StatefulWidget {
  const CamerasScreen({super.key});

  @override
  State<CamerasScreen> createState() => _CamerasScreenState();
}

class _CamerasScreenState extends State<CamerasScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rtspController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CamerasController>().loadCameras();
  }

  @override
  Widget build(BuildContext context) {
    final camerasController = context.watch<CamerasController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cameras')),
      body: camerasController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: camerasController.cameras.length,
              itemBuilder: (context, index) {
                final camera = camerasController.cameras[index];
                return ListTile(
                  title: Text(camera.name),
                  subtitle: Text(camera.rtspUrl),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => camerasController.deleteCamera(camera.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCameraDialog(context, camerasController),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCameraDialog(
    BuildContext context,
    CamerasController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Camera'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: _nameController, label: 'Camera Name'),
            const SizedBox(height: 16),
            CustomTextField(controller: _rtspController, label: 'RTSP URL'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Add',
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _rtspController.text.isNotEmpty) {
                controller.addCamera(
                  _nameController.text,
                  _rtspController.text,
                );
                _nameController.clear();
                _rtspController.clear();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
