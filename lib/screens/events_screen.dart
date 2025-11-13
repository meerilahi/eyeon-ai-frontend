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
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = context.read<EventsController>().fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.eventDescription),
                  subtitle: Text(event.isActive ? 'Active' : 'Inactive'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: event.isActive,
                        onChanged: (value) {
                          context.read<EventsController>().updateEvent(
                            event.eventId,
                            event.eventDescription,
                            value,
                          );
                          setState(() {
                            _eventsFuture = context
                                .read<EventsController>()
                                .fetchEvents();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<EventsController>().deleteEvent(
                            event.eventId,
                          );
                          setState(() {
                            _eventsFuture = context
                                .read<EventsController>()
                                .fetchEvents();
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No events found'));
          }
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
                setState(() {
                  _eventsFuture = context
                      .read<EventsController>()
                      .fetchEvents();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
