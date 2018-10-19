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
  Future<List<Event>> _fetcher = fetchEvents();

  void _reload() {
    setState(() {
      _fetcher = fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: SafeArea(
        child: _buildEvents(),
        bottom: false,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _reload,
        tooltip: 'Increment',
        child: new Icon(Icons.autorenew),
      ),
    );
  }

  Widget _buildEvents() {
    return FutureBuilder<List<Event>>(
      future: _fetcher,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) => _buildRow(snapshot.data[index]),
          );
        } else if (snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          return Text('${snapshot.error}');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildRow(Event event) {
    final String date = (event.dateStart != null
            ? "${event.dateStart}\n- ${event.dateEnd}"
            : event.dateSingle) +
        '\n${event.organizer.toString().replaceAll(RegExp(r"[\s/,]+"), '\n')}';
    final _titleStyle = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontFamily: "Roboto",
      color: Colors.black,
      decoration: TextDecoration.none,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Hero(
            tag: event.link,
            child: Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: _titleStyle,
            ),
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
