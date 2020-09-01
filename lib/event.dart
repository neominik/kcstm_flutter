import 'dart:async';
import 'dart:io' show SocketException;

import 'package:http/http.dart' as http;
import 'package:csv/csv.dart' as csv;

final homepage = 'https://kanu-club-steinhuder-meer.de/Drupal8/kcstmkalender.csv';

class Event {
  final String title;
  final String link;
  final String dateStart;
  final String dateEnd;
  final String organizer;
  final String description;
  final String registerDate;
  final String phone;
  final String email;
  final String participants;
  final String address;

  Event({
    this.title,
    this.link,
    this.dateStart,
    this.dateEnd,
    this.organizer,
    this.description,
    this.registerDate,
    this.phone,
    this.email,
    this.participants,
    this.address,
  });
}

Future<List<Event>> fetchEvents() async {
  try {
    final response = await http.get(homepage);

    if (response.statusCode == 200) {
      return decode(response.body);
    } else {
      throw Exception(
          'Failed to load events, status code: ${response.statusCode}');
    }
  } catch (e) {
    if (e is SocketException) {
      throw '${e.message} - are you connected to the internet?';
    }
    throw e;
  }
}

List<Event> decode(String body) {
  final rows = const csv.CsvToListConverter(eol: '\n').convert(body);
  return rows.skip(1).map(trToEvent).toList();
}

Event trToEvent(List tr) {
  return Event(
    title: tr[0],
    dateStart: tr[1].toString().split("\n - ").first,
    dateEnd: tr[1].toString().split("\n - ").last,
    organizer: tr[2],
    description: tr[3],
    phone: tr[4],
    email: tr[5],
    participants: tr[6],
    link: tr[7],
    address: tr[8],
    registerDate: tr[9],
  );
}
