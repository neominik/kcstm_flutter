import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'event.dart';
import 'participate_screen.dart';

class DetailScreen extends StatelessWidget {
  final Event event;

  DetailScreen({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.launch),
            onPressed: () => launch(
                  event.link,
                  forceSafariVC: false,
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
    final _headlineFont = const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.normal,
      fontFamily: "Roboto",
      color: Colors.black,
      decoration: TextDecoration.none,
    );
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
        Hero(
          tag: event.link,
          child: Text(
            event.title,
            style: _headlineFont,
          ),
        ),
        Text('$_date Anmeldeschluss am ${event.registerDate}'),
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
        Text(event.email),
        Text(
          'Teilnehmer',
          style: _headlineFont,
        ),
        Text(_participants),
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
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch('tel:$number');
                  }))
            .expand((textSpan) => <TextSpan>[textSpan, TextSpan(text: ' ')])
            .toList(),
      ));
    }
    return Text('Keine Telefonnummer angegeben');
  }
}
