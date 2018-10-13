import 'dart:async';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class Event {
  final String title;
  final String dateStart;
  final String dateEnd;
  final String dateSingle;
  final String organizer;
  final String description;
  final String registerDate;
  final String phone;
  final String email;

  Event({
    this.title,
    this.dateStart,
    this.dateEnd,
    this.dateSingle,
    this.organizer,
    this.description,
    this.registerDate,
    this.phone,
    this.email,
  });
}

Future<List<Event>> fetchEvents() async {
  final response =
      await http.get('https://kanu-club-steinhuder-meer.de/?q=mobilkalender');

  if (response.statusCode == 200) {
    return decode(response.body);
  } else {
    throw Exception('Failed to load events');
  }
}

List<Event> decode(String body) {
  final document = parse(body);
  var events = document
      .getElementsByTagName('tbody')
      .expand((tBody) => tBody.getElementsByTagName('tr'))
      .map(trToEvent)
      .toList();
  return events;
}

Event trToEvent(dom.Element tr) {
  return Event(
    title: nodeToText(tr
        .getElementsByClassName('views-field-title')
        .expand((td) => td.getElementsByTagName('a'))),
    dateStart: nodeToText(tr.getElementsByClassName('date-display-start')),
    dateEnd: nodeToText(tr.getElementsByClassName('date-display-end')),
    dateSingle: nodeToText(tr
        .getElementsByClassName('views-field-field-datum')
        .expand((td) => td.getElementsByClassName('date-display-single'))),
    organizer: nodeToText(
        tr.getElementsByClassName('views-field-field-veranstalter-1')),
    description: getTextFromBody(tr.getElementsByClassName('views-field-body')),
    registerDate: nodeToText(tr
        .getElementsByClassName('views-field-field-anmeldedatum')
        .expand((td) => td.getElementsByClassName('date-display-single'))),
    phone: nodeToText(
        tr.getElementsByClassName('views-field-field-telefon-fahrtenleiter')),
    email: nodeToText(tr
        .getElementsByClassName('views-field-field-email-fahrtenleiter')
        .expand((td) => td.getElementsByTagName('a'))),
  );
}

String nodeToText(Iterable<dom.Element> node) {
  if (node.isEmpty) return null;
  return (node.first.firstChild as dom.Text).data.trim();
}

String getTextFromBody(Iterable<dom.Node> nodes) {
  return nodes
      .expand((n) => n.nodes)
      .map((n) => n.text.trim())
      .where((s) => s.isNotEmpty)
      .join('\n');
}
