import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/events_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsController>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsController = context.watch<EventsController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: eventsController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventsController.events.isEmpty
          ? const Center(child: Text('No events found'))
          : ListView.builder(
              itemCount: eventsController.events.length,
              itemBuilder: (context, index) {
                final event = eventsController.events[index];
                return ListTile(
                  title: Text(event.eventDescription),
                  subtitle: Text(event.isActive ? 'Active' : 'Inactive'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: event.isActive,
                        onChanged: (value) {
                          eventsController.updateEvent(
                            event.eventId,
                            event.eventDescription,
                            value,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          eventsController.deleteEvent(event.eventId);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _eventDescriptionController,
              label: 'Event Description',
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
              if (_eventDescriptionController.text.isNotEmpty) {
                context.read<EventsController>().addEvent(
                  _eventDescriptionController.text,
                );
                _eventDescriptionController.clear();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
