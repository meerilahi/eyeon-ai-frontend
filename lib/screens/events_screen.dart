import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/events_controller.dart';
import '../models/event.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EventsController>().loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventsController = context.watch<EventsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: eventsController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: eventsController.events.length,
              itemBuilder: (context, index) {
                final event = eventsController.events[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text(event.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: event.isActive,
                        onChanged: (value) => eventsController.updateEvent(
                          event.id,
                          event.name,
                          event.description,
                          value,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => eventsController.deleteEvent(event.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context, eventsController),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, EventsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: _nameController, label: 'Event Name'),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
            ),
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
                  _descriptionController.text.isNotEmpty) {
                controller.addEvent(
                  _nameController.text,
                  _descriptionController.text,
                );
                _nameController.clear();
                _descriptionController.clear();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
