import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'ring.dart';
import 'game_webview_page.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VerbTable(),
    );
  }
}

class VerbTable extends StatefulWidget {
  const VerbTable({super.key});

  @override
  State<VerbTable> createState() => _VerbTableState();
}

class _VerbTableState extends State<VerbTable> {
  final AudioPlayer _player = AudioPlayer();

  // la începutul _VerbTableState (după player), adaugă:
final Map<String, WidgetBuilder> verbPages = {
  'ring': (_) => const RingPage(),   // din ring.dart
  // 'sing': (_) => const SingPage(), // apoi adaugi treptat
};

  Future<void> _play(String baseName) async {
    try {
      await _player.setAsset('assets/audio/$baseName.mp3');
      await _player.play();
    } catch (e) {
      debugPrint('Eroare audio: $e');
    }
  }


  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

    final verbs = <List<String>>[
      ['ring.png',   'ring',   'rang',   'rung',   'a suna'],
      ['sing.png',   'sing',   'sang',   'sung',   'a cânta'],
      ['sink.png',   'sink',   'sank',   'sunk',   'a se scufunda'],
      ['drink.png',  'drink',  'drank',  'drunk',  'a bea'],
      ['shrink.png', 'shrink', 'shrank', 'shrunk', 'a micșora(se)'],
      ['swim.png',   'swim',   'swam',   'swum',   'a înota'],
      ['begin.png',  'begin',  'began',  'begun',  'a începe'],
      ['run.png',    'run',    'ran',    'run',    'a alerga'],
    ];

    return Scaffold(
  appBar: AppBar(
    title: const Text('Irregular Verbs'),
    actions: [
  IconButton(
    icon: const Icon(Icons.videogame_asset),
    tooltip: 'Deschide jocul',
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const GameWebViewPage(
            url: 'https://speakenglish.ro/Games/group1/playgr1.html',
            title: 'Group 1 – Game',
          ),
        ),
      );
    },
  ),
],
    ),


  body: InteractiveViewer(
    constrained: false,
    minScale: 0.8,
    maxScale: 2.5,
    boundaryMargin: const EdgeInsets.all(64),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: const WidgetStatePropertyAll(Color(0xFF6EB26E)),
          columns: const [
            DataColumn(label: Text('dicționar', style: headerStyle)),
            DataColumn(label: Text('audio', style: headerStyle)),
            DataColumn(label: Text('Infinitive', style: headerStyle)),
            DataColumn(label: Text('Past simple', style: headerStyle)),
            DataColumn(label: Text('Past participle', style: headerStyle)),
            DataColumn(label: Text('Română', style: headerStyle)),
          ],
          rows: verbs.map((v) {
            final img  = v[0];
            final inf  = v[1];
            final past = v[2];
            final part = v[3];
            final ro   = v[4];

            return DataRow(
              cells: [
                DataCell(
                  Image.asset('assets/img/$img', width: 60, height: 40, fit: BoxFit.cover),
                  onTap: () {
                    final builder = verbPages[inf];
                    if (builder != null) {
                      Navigator.of(context).push(MaterialPageRoute(builder: builder));
                    }
                  },
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () => _play('$inf-full'),
                  ),
                ),
                DataCell(Text(inf),  onTap: () => _play(inf)),
                DataCell(Text(past, style: const TextStyle(color: Colors.blue)), onTap: () => _play(past)),
                DataCell(Text(part, style: const TextStyle(color: Colors.red)),  onTap: () => _play(part)),
                DataCell(Text(ro)),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  ),
);
 

  }
}

