import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class RingPage extends StatefulWidget {
  const RingPage({super.key});

  @override
  State<RingPage> createState() => _RingPageState();
}

class _RingPageState extends State<RingPage> {
  final _player = AudioPlayer();

  Future<void> _play(String base) async {
    try {
      await _player.setAsset('assets/audio/$base.mp3');
      await _player.play();
    } catch (e) {
      debugPrint('audio err: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.w800);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ring – rang – rung'),
        actions: [
          IconButton(
            tooltip: 'FULL',
            onPressed: () => _play('ring-full'),
            icon: const Icon(Icons.volume_up),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Header ca în tabel: Infinitive / Past / Participle / Traducere
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF6EB26E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: const [
                  Expanded(child: Center(child: Text('Infinitive', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text('Past simple', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text('Past participle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text('Traducere', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Linia cu formele
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(child: Center(child: GestureDetector(onTap: () => _play('ring'), child: Text('ring', style: titleStyle)))),
                  Expanded(child: Center(child: GestureDetector(onTap: () => _play('rang'), child: const Text('rang', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700))))),
                  Expanded(child: Center(child: GestureDetector(onTap: () => _play('rung'), child: const Text('rung', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700))))),
                  const Expanded(child: Center(child: Text('a suna', style: TextStyle(fontStyle: FontStyle.italic)))),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Secțiuni cu propoziții + audio + traducere (Present Simple / Past / Present Perfect)
          _SentenceRow(
            label: 'Present Simple',
            sentence: 'I ring three times.',
            ro: 'Eu sun de trei ori.',
            onPlay: () => _play('ring'), // pronunția formei „ring”
          ),
          _SentenceRow(
            label: 'Past Simple',
            sentence: 'The phone rang three times yesterday.',
            ro: 'Telefonul a sunat de trei ori ieri.',
            onPlay: () => _play('rang'),
            labelColor: Colors.blue,
          ),
          _SentenceRow(
            label: 'Present Perfect',
            sentence: 'The phone has rung recently.',
            ro: 'Telefonul a sunat recent.',
            onPlay: () => _play('rung'),
            labelColor: Colors.red,
          ),

          const SizedBox(height: 16),

          // Imagine mare, puțin rotită (simil. mockup)
          Center(
            child: Transform.rotate(
              angle: -0.04, // ~ -2.3°
              child: Container(
                width: 360,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(blurRadius: 16, spreadRadius: 1, offset: Offset(0, 6), color: Colors.black12)],
                ),
                child: Stack(
                  children: [
                    Image.asset('assets/img/ring.png', fit: BoxFit.cover),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: ElevatedButton.icon(
                        onPressed: () => _play('ring-full'),
                        icon: const Icon(Icons.call),
                        label: const Text('Call sound'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

         
         
           
        ],
      ),
    );
  }
}

class _SentenceRow extends StatelessWidget {
  const _SentenceRow({
    required this.label,
    required this.sentence,
    required this.ro,
    required this.onPlay,
    this.labelColor,
  });

  final String label;
  final String sentence;
  final String ro;
  final VoidCallback onPlay;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final color = labelColor ?? Colors.black87;
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: onPlay, icon: const Icon(Icons.volume_up)),
            SizedBox(
              width: 120,
              child: Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(sentence, style: const TextStyle(fontSize: 16))),
            const SizedBox(width: 12),
            SizedBox(
              width: 220,
              child: Text(ro, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700])),
            ),
          ],
        ),
      ),
    );
  }
}
