import 'package:flutter/material.dart';

import 'detail_screen.dart';
import 'event.dart';

class EventListPage extends StatefulWidget {
  EventListPage({Key key, this.title}) : super(key: key);

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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: SafeArea(child: _buildEvents()),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.autorenew),
      ),
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
