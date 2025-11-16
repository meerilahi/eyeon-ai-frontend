import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cameras_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class CamerasScreen extends StatefulWidget {
  const CamerasScreen({super.key});

  @override
  State<CamerasScreen> createState() => _CamerasScreenState();
}

class _CamerasScreenState extends State<CamerasScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rtspController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CamerasController>().loadCameras();
    });
  }

  @override
  Widget build(BuildContext context) {
    final camerasController = context.watch<CamerasController>();
    return Scaffold(
      body: camerasController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : camerasController.cameras.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No cameras found'),
                  SizedBox(height: 8),
                  Text(
                    'Add your first camera!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: camerasController.cameras.length,
              itemBuilder: (context, index) {
                final camera = camerasController.cameras[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                camera.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                camerasController.deleteCamera(camera.cameraId);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          camera.description,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          camera.rtspUrl,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCameraDialog(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCameraDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Add Camera'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Camera Name',
                prefixIcon: const Icon(Icons.camera_alt),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                prefixIcon: const Icon(Icons.description),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _rtspController,
                label: 'RTSP URL',
                prefixIcon: const Icon(Icons.link),
                hint: 'rtsp://example.com/stream',
              ),
            ],
          ),
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
                  _descriptionController.text.isNotEmpty &&
                  _rtspController.text.isNotEmpty) {
                context.read<CamerasController>().addCamera(
                  _nameController.text,
                  _descriptionController.text,
                  _rtspController.text,
                );
                _nameController.clear();
                _descriptionController.clear();
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
