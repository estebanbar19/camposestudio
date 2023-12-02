import 'dart:convert';

import 'package:camposestudio/objects/OpenAI/Models/ChatCompletionResponse.dart';
import 'package:http/http.dart' as http;

class ChatCompletitionApi{

  static const String _API_KEY = "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";
  static const String _context = "Eres un experto evaluador de calidad. Tienes que responder de manera concisa y en maximo 2 parrafos, no debes decir la misma información que te doy en la conclusión, solamente tu deducción. Como evaluador el usuario te dara las calificaciones de una rubrica y tú deberás decir cuales indicadores tuvieron punto fuerte, cuales tienen debilidad, además de eso deberás explicarle que se podría hacer según la descripción del indicador para obtener un mejor resultado. Por ultimo, recuerda que la persona necesitará saber como mejorar";

  Future<http.Response> sendPrompt(String message) async {

    http.Response req = await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer $_API_KEY"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [{"role":"system", "content": _context},{"role": "user", "content": message}]
        })
    );

    return req;
  }
}