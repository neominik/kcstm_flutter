import 'dart:async';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class Event {
  final String title;
  final String dateStart;
  final String dateEnd;
  final String dateSingle;
  final String organizer;
  final String description;

  Event(
      {this.title,
      this.dateStart,
      this.dateEnd,
      this.dateSingle,
      this.organizer,
      this.description});
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
      description:
          getTextFromBody(tr.getElementsByClassName('views-field-body')));
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

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'KCSTM',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primaryColor: Colors.grey.shade800,
      ),
      home: new EventListPage(title: 'KCSTM'),
    );
  }
}

class EventListPage extends StatefulWidget {
  EventListPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _EventListPageState createState() => new _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // TODO
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: _buildEvents(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.autorenew),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildEvents() {
    return FutureBuilder<List<Event>>(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data.map(_buildRow).toList(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildRow(Event event) {
    final String date = (event.dateStart != null
            ? "${event.dateStart}\n- ${event.dateEnd}"
            : event.dateSingle) +
        '\n${event.organizer.toString().replaceAll(RegExp(r"[\s/,]+"), '\n')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
          subtitle: Text(
            event.description,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
          trailing: Text(
            date,
            textAlign: TextAlign.right,
            overflow: TextOverflow.fade,
            maxLines: 3,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                          event: event,
                        )));
          },
        ),
        Divider(),
      ],
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Event event;

  DetailScreen({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _biggerFont = const TextStyle(fontSize: 18.0);
    final _headlineFont = const TextStyle(fontSize: 22.0);
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(event.title, style: _headlineFont,),
            Text('Von bis anmeldung event.dateStart'),
            Text('Beschreibung', style: _headlineFont,),
            Text(event.description),
            Text('link'),
            Text('Kontakt', style: _headlineFont,),
            Text(event.organizer),
            Text('phone'),
            Text('email'),
            Text('Teilnehmer', style: _headlineFont,),
            Text('teilnehmer'),
          ],
        ));
  }
}
