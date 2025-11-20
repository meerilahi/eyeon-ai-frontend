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
    final events = eventsController.events;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddEventDialog(context),
          backgroundColor: Colors.red.shade600,
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Event'),
          elevation: 12,
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              // Events List
              Expanded(
                child: eventsController.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : events.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy_rounded,
                              size: 64,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No Events Found',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Create your first event to get started',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.08),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          event.eventDescription,
                                          style: TextStyle(
                                            color: event.isActive
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            decoration: event.isActive
                                                ? null
                                                : TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 0.9,
                                        child: Switch(
                                          value: event.isActive,
                                          activeColor: Colors.red.shade400,
                                          activeTrackColor: Colors.red.shade400
                                              .withOpacity(0.5),
                                          inactiveThumbColor: Colors.grey,
                                          inactiveTrackColor: Colors.grey
                                              .withOpacity(0.3),
                                          onChanged: (value) {
                                            eventsController.updateEvent(
                                              event.eventId,
                                              event.eventDescription,
                                              value,
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.red.shade400,
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmation(
                                            context,
                                            event.eventId,
                                            event.eventDescription,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.white.withOpacity(0.4),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Created ${index + 1} day${index != 0 ? 's' : ''} ago',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String eventId,
    String eventDescription,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade400),
            const SizedBox(width: 12),
            const Text('Delete Event', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "$eventDescription"?',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EventsController>().deleteEvent(eventId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.event_rounded,
                      color: Colors.red.shade400,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Create New Event',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _eventDescriptionController,
                label: 'Event Description',
                prefixIcon: const Icon(Icons.description_outlined),
                hint: 'Enter event details...',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Create Event',
                      onPressed: () {
                        if (_eventDescriptionController.text.isNotEmpty) {
                          context.read<EventsController>().addEvent(
                            _eventDescriptionController.text,
                          );
                          _eventDescriptionController.clear();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
