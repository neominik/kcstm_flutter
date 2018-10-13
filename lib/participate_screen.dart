import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'event.dart';

class ParticipateScreen extends StatefulWidget {
  final Event event;

  ParticipateScreen({Key key, @required this.event}) : super(key: key);

  @override
  ParticipateScreenState createState() {
    return ParticipateScreenState(event);
  }
}

class ParticipateScreenState extends State<ParticipateScreen> {
  final Event _event;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentsController = TextEditingController();
  final _participantsController = TextEditingController(text: '1');

  ParticipateScreenState(this._event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mitfahren'),
      ),
      body: SafeArea(
        child: Form(
          child: _buildInputs(_formKey),
          key: _formKey,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _sendEmail();
          }
        },
        tooltip: 'Email senden',
        child: Icon(Icons.send),
      ),
    );
  }

  Widget _buildInputs(GlobalKey<FormState> formKey) {
    final _headlineFont = const TextStyle(fontSize: 22.0);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Text(
          'Name',
          style: _headlineFont,
        ),
        TextFormField(
          autofocus: true,
          controller: _nameController,
          validator: (value) {
            if (value.isEmpty) return 'Bitte Namen eingeben!';
          },
        ),
        Text(
          'Telefon',
          style: _headlineFont,
        ),
        TextFormField(
          controller: _phoneController,
          validator: (value) {
            if (value.isEmpty)
              return 'Bitte Telefonnummer für Rückfragen angeben!';
          },
        ),
        Text(
          'E-Mail',
          style: _headlineFont,
        ),
        TextFormField(
          controller: _emailController,
          validator: (value) {
            if (!RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
                .hasMatch(value)) return 'Bitte valide E-Mail angeben!';
          },
        ),
        Text(
          'Bemerkungen',
          style: _headlineFont,
        ),
        TextFormField(controller: _commentsController),
        Text(
          'Anzahl Teilnehmende',
          style: _headlineFont,
        ),
        TextFormField(
          controller: _participantsController,
          validator: (value) {
            if (value.isEmpty)
              return 'Bitte die Anzahl der Teilnehmenden angeben!';
          },
        ),
      ],
    );
  }

  _sendEmail() async {
    final subject =
        Uri.encodeQueryComponent('Anmeldung zu einer Veranstaltung des KCSTM');
    final body = Uri.encodeQueryComponent('Hallo ${_event.organizer},' +
        '\n\nfolgende Anmeldung für deine Veranstaltung:\n\n' +
        'Name: ${_nameController.text}\n' +
        'Datum der Tour: ${_event.dateStart != null ? 'Von ${_event.dateStart} bis ${_event.dateEnd}' : 'Am ${_event.dateSingle}'}\n' +
        'Veranstaltung: ${_event.title}\n' +
        'Bemerkungen: ${_commentsController.text}\n' +
        'Anzahl Teilnehmende: ${_participantsController.text}\n' +
        'E-Mail: ${_participantsController.text}\n' +
        'Telefon: ${_phoneController.text}\n\n' +
        'Diese Mail wurde erstellt durch die KCSTM-APP von Dominik Engelhardt.');
    final url = 'mailto:${_event.email}?subject=$subject?body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not send email: $url';
    }
  }
}