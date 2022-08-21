import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'add_to_calendar.dart';
import 'event.dart';
import 'participate_screen.dart';

class DetailScreen extends StatelessWidget {
  final Event event;
  final _linkStyle =
      const TextStyle(color: Colors.blue, decoration: TextDecoration.underline);
  final _headlineFont = const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.normal,
    fontFamily: "Roboto",
    decoration: TextDecoration.none,
  );

  DetailScreen({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: <Widget>[
          AddToCalendarAction(event),
          IconButton(
            icon: Icon(Icons.launch),
            onPressed: () => launchUrl(
                  Uri.parse(event.link),
                ),
            tooltip: 'Im Browser öffnen',
          )
        ],
      ),
      body: SafeArea(child: _buildDetails()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ParticipateScreen(
                        event: event,
                      )));
        },
        tooltip: 'Mitfahren',
        child: Icon(Icons.group_add),
      ),
    );
  }

  Widget _buildDetails() {
    final _date = formatDate(event.dateStart, event.dateEnd);
    final _participants = event.participants
        .split(RegExp(r"[,;]"))
        .map((s) => s.trim())
        .join('\n');
    final _emailUrl =
        Uri.parse('mailto:${event.email}?subject=${Uri.encodeComponent(event.title)}');
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Hero(
          tag: event.hashCode,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              event.title,
              style: _headlineFont,
            ),
          ),
        ),
        Text('$_date\nAnmeldeschluss am ${event.registerDate}'),
        Text(
          'Beschreibung',
          style: _headlineFont,
        ),
        Text(
          event.description,
        ),
        Text(
          'Kontakt',
          style: _headlineFont,
        ),
        Text(event.organizer),
        _buildPhoneNumbers(),
        RichText(
          text: TextSpan(
            text: event.email,
            style: _linkStyle,
            recognizer: TapGestureRecognizer()..onTap = () => launchUrl(_emailUrl),
          ),
        ),
        Text(
          'Teilnehmer',
          style: _headlineFont,
        ),
        Text(_participants),
        Text(
          'Adresse',
          style: _headlineFont,
        ),
        RichText(
          text: TextSpan(
            text: event.address,
            style: _linkStyle,
            recognizer: TapGestureRecognizer()..onTap = () => MapsLauncher.launchQuery(event.address),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumbers() {
    if (event.phone.isNotEmpty) {
      return RichText(
          text: TextSpan(
        children: event.phone
            .split(',')
            .map((s) => s.trim().replaceAll(RegExp(r"\s+"), '-'))
            .map((number) => TextSpan(
                text: number,
                style: _linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri.parse('tel:$number'))))
            .expand((textSpan) => <TextSpan>[textSpan, TextSpan(text: ' ')])
            .toList(),
      ));
    }
    return Text('Keine Telefonnummer angegeben');
  }

  String formatDate(String start, String end) {
    final startDate = start.substring(0, 10);
    final endDate = end.substring(0, 10);
    final endTime = end.substring(13);
    return startDate == endDate ? "$start bis $endTime" : "$start bis $endDate $endTime";
  }
}
