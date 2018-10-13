import 'package:flutter/material.dart';

import 'event.dart';

class DetailScreen extends StatelessWidget {
  final Event event;

  DetailScreen({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _headlineFont = const TextStyle(fontSize: 22.0);
    final date = event.dateStart != null
        ? 'vom ${event.dateStart} bis zum ${event.dateEnd}'
        : 'am ${event.dateSingle}';
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              event.title,
              style: _headlineFont,
            ),
            Text('$date Anmeldeschluss am ${event.registerDate}'),
            Text(
              'Beschreibung',
              style: _headlineFont,
            ),
            Text(event.description),
            Text('link'),
            Text(
              'Kontakt',
              style: _headlineFont,
            ),
            Text(event.organizer),
            Text('phone'),
            Text('email'),
            Text(
              'Teilnehmer',
              style: _headlineFont,
            ),
            Text('teilnehmer'),
          ],
        ));
  }
}
