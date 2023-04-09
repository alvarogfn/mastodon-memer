import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memerly/models/meme.dart';

class Memer {
  static const endpoint = "https://meme-api.com/gimme";

  Stream<Meme> meming({Duration polling = const Duration(hours: 5)}) {
    late StreamController<Meme> controller;
    late Timer timer;

    Future<void> tick(_) async {
      final meme = await fetchMeme();
      controller.add(meme);
    }

    Future<void> startTimer() async {
      timer = Timer.periodic(polling, tick);

      final meme = await fetchMeme();
      controller.add(meme);
    }

    stopTimer() {
      timer.cancel();
    }

    controller = StreamController(onListen: startTimer, onCancel: stopTimer);

    return controller.stream;
  }

  Future<Meme> fetchMeme() async {
    final response = await http.get(Uri.parse('https://meme-api.com/gimme'));

    return Meme.fromMap(jsonDecode(response.body));
  }
}
