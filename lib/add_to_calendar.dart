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
            String selectedCalendar;
            Iterable<calendar.Calendar> writableCalendars =
                calendars.data.where((c) => !c.isReadOnly);
            if (writableCalendars.length == 1) {
              selectedCalendar = writableCalendars.first.id;
            } else {
              selectedCalendar = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Kalender auswählen'),
                      children: writableCalendars
                          .map((c) => SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context, c.id);
                                },
                                child: Text(c.name),
                              ))
                          .toList(),
                    );
                  });
            }
            final calEvent = calendar.Event(
              selectedCalendar,
              title: event.title,
              start: parse(event.dateStart),
              end: parse(event.dateEnd),
              allDay: false,
            );
            final res = await plugin.createOrUpdateEvent(calEvent);
            if (res.isSuccess)
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Zu Kalender hinzugefügt!")));
          }
        });
  }

  DateTime parse(String date) {
    final formatted = date.substring(0,10).split(".").reversed.join() + "T" + date.substring(13);
    return DateTime.parse(formatted);
  }
}
