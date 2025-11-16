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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rtspController = TextEditingController();
  late Future<List<Camera>> _camerasFuture;

  @override
  void initState() {
    super.initState();
    _camerasFuture = context.read<CamerasController>().fetchCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cameras')),
      body: FutureBuilder<List<Camera>>(
        future: _camerasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final cameras = snapshot.data!;
            return ListView.builder(
              itemCount: cameras.length,
              itemBuilder: (context, index) {
                final camera = cameras[index];
                return ListTile(
                  title: Text(camera.name),
                  subtitle: Text('${camera.description}\n${camera.rtspUrl}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<CamerasController>().deleteCamera(
                        camera.cameraId,
                      );
                      setState(() {
                        _camerasFuture = context
                            .read<CamerasController>()
                            .fetchCameras();
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No cameras found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCameraDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCameraDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Camera'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: _nameController, label: 'Camera Name'),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
            ),
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
            onPressed: () async {
              if (_nameController.text.isNotEmpty &&
                  _descriptionController.text.isNotEmpty &&
                  _rtspController.text.isNotEmpty) {
                await context.read<CamerasController>().addCamera(
                  _nameController.text,
                  _descriptionController.text,
                  _rtspController.text,
                );
                _nameController.clear();
                _descriptionController.clear();
                _rtspController.clear();
                Navigator.of(context).pop();
                setState(() {
                  _camerasFuture = context
                      .read<CamerasController>()
                      .fetchCameras();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
