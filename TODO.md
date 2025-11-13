# Refactor Screens to Use FutureBuilder Instead of ListView Builders

## Overview
Refactor the Event screen, Chat screen, Alert screen, and Camera screen to use FutureBuilder for handling asynchronous data loading instead of manual loading state management with ListView.builder. This involves updating controllers to provide fetch methods and modifying screens to use FutureBuilder.

## Steps
- [x] Update EventsController: Add fetchEvents() method
- [x] Update AlertsController: Add fetchAlerts() method
- [x] Update CamerasController: Add fetchCameras() method
- [x] Update ChatController: Add fetchMessages() method
- [x] Refactor EventsScreen: Replace ListView.builder with FutureBuilder
- [x] Refactor AlertsScreen: Replace ListView.builder with FutureBuilder
- [x] Refactor CamerasScreen: Replace ListView.builder with FutureBuilder
- [x] Refactor ChatScreen: Replace ListView.builder with FutureBuilder
- [ ] Test the application to ensure functionality works correctly
