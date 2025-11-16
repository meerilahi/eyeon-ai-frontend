# Refactoring Plan for Cameras, Events, and Alerts Screens/Controllers

## Information Gathered
- **CamerasScreen**: Currently uses `FutureBuilder` with `_camerasFuture` initialized in `initState` and refreshed via `setState` after add/delete operations. This leads to repeated fetches.
- **EventsScreen**: Similar to CamerasScreen, uses `FutureBuilder` with `_eventsFuture` and repeated `setState` refreshes.
- **AlertsScreen**: Already uses `ChangeNotifier` properly with `context.watch<AlertsController>()`, calls `loadAlerts()` once in `initState`, and subscribes to real-time updates.
- **CamerasController**: Has `loadCameras()` (not used in screen) and `fetchCameras()` (used in FutureBuilder). Needs to ensure `loadCameras` is called once and reactivity via `ChangeNotifier`.
- **EventsController**: Has `loadEvents()` and `fetchEvents()`. Similar to cameras.
- **AlertsController**: Already reactive with `loadAlerts()` and subscription.

## Plan
- **CamerasScreen**:
  - Replace `FutureBuilder` with `Consumer<CamerasController>` or `context.watch<CamerasController>()`.
  - Call `loadCameras()` once in `initState` instead of `fetchCameras()`.
  - Remove `setState` calls that refresh `_camerasFuture` after add/delete; rely on `ChangeNotifier` for rebuilds.
  - Use `camerasController.cameras` for the list.
- **EventsScreen**:
  - Similar changes: Replace `FutureBuilder` with reactivity.
  - Call `loadEvents()` in `initState`.
  - Remove repeated `setState` for future refreshes.
- **AlertsScreen**: No changes needed; already compliant.
- **Controllers**:
  - Ensure `loadCameras()` and `loadEvents()` are called once in respective screens' `initState`.
  - Keep `fetchCameras()` and `fetchEvents()` if used elsewhere, but remove their usage in screens.
  - AlertsController is fine.

## Dependent Files to Edit
- `lib/screens/cameras_screen.dart`
- `lib/screens/events_screen.dart`
- (AlertsScreen: no changes)

## Followup Steps
- Test the app to ensure reactivity works (add/delete/update triggers rebuilds).
- Verify no repeated fetches occur.
- Run the app and check for errors.

## Completed Tasks
- [x] Refactored CamerasScreen to use ChangeNotifier reactivity instead of FutureBuilder.
- [x] Called loadCameras() once in initState for CamerasScreen.
- [x] Removed setState calls for repeated Future refreshes in CamerasScreen.
- [x] Refactored EventsScreen to use ChangeNotifier reactivity instead of FutureBuilder.
- [x] Called loadEvents() once in initState for EventsScreen.
- [x] Removed setState calls for repeated Future refreshes in EventsScreen.
- [x] Removed unused imports.
- [x] Fixed async gap warning by removing await in addCamera call.
- [x] Ran flutter analyze to check for issues (only unrelated warnings remain).
