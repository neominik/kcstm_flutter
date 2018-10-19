import 'package:device_calendar/device_calendar.dart' as calendar;
import 'package:flutter/material.dart';

import 'event.dart';

class AddToCalendarAction extends StatelessWidget {
  final Event event;

  AddToCalendarAction(this.event);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.event),
        onPressed: () async {
          final plugin = calendar.DeviceCalendarPlugin();
          if (!(await plugin.hasPermissions()).data) {
            final result = await plugin.requestPermissions();
            if (!result.data) return;
          }

          final calendars = await plugin.retrieveCalendars();
          if (calendars.isSuccess) {
            final selectedCalendar = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Kalender auswählen'),
                    children: calendars.data
                        .where((c) => !c.isReadOnly)
                        .map((c) => SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, c.id);
                              },
                              child: Text(c.name),
                            ))
                        .toList(),
                  );
                });
            final calEvent = calendar.Event(
              selectedCalendar,
              title: event.title,
              start: DateTime.parse(
                  (event.dateStart != null ? event.dateStart : event.dateSingle)
                      .split('.')
                      .reversed
                      .join()),
              end: DateTime.parse(
                      (event.dateEnd != null ? event.dateEnd : event.dateSingle)
                          .split('.')
                          .reversed
                          .join())
                  .add(Duration(days: 1)),
            );
            final res = await plugin.createOrUpdateEvent(calEvent);
            if (res.isSuccess)
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Zu Kalender hinzugefügt!")));
          }
        });
  }
}
