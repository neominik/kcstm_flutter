import 'package:flutter/material.dart';

import 'event.dart';

class DetailScreen extends StatelessWidget {
  final Event event;

  DetailScreen({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: _buildDetails(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Mitfahren',
        child: Icon(Icons.group_add),
      ),
    );
  }

  Widget _buildDetails() {
    final _headlineFont = const TextStyle(fontSize: 22.0);
    final _date = event.dateStart != null
        ? 'vom ${event.dateStart} bis zum ${event.dateEnd}'
        : 'am ${event.dateSingle}';
    final _participants = event.participants
        .split(RegExp(r"[,;]"))
        .map((s) => s.trim())
        .join('\n');
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Text(
          event.title,
          style: _headlineFont,
        ),
        Text('$_date Anmeldeschluss am ${event.registerDate}'),
        Text(
          'Beschreibung',
          style: _headlineFont,
        ),
        Text(event.description),
        Text(event.link),
        Text(
          'Kontakt',
          style: _headlineFont,
        ),
        Text(event.organizer),
        Text(event.phone.isNotEmpty
            ? event.phone
            : 'Keine Telefonnummer angegeben'),
        Text(event.email),
        Text(
          'Teilnehmer',
          style: _headlineFont,
        ),
        Text(_participants),
      ],
    );
  }
}
