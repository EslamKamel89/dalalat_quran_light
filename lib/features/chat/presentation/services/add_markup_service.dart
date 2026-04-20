import 'dart:convert';

import 'package:dalalat_quran_light/env.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:http/http.dart' as http;

Future<String> structureTextToHtml(String rawText) async {
  const prompt = """
You are a semantic document structuring engine.

Your job is to convert RAW PLAIN TEXT into semantically rich, well-structured HTML.

The text is verbatim and must remain EXACTLY the same letter-by-letter. You may only ADD markup.

DO NOT rewrite, correct, remove, or add words.

STRUCTURE RULES:
• Use <h1>, <h2>, <p> for document structure.
• Preserve paragraph flow.

SEMANTIC ANNOTATION RULES:

1. Quran verses (text inside ﴿ ﴾):
   Wrap them in:
   <span data-type="quran">...</span>

2. Definitions or explanations after words like "يعني", "أي", ":":
   Wrap the defining sentence in:
   <blockquote data-type="definition">...</blockquote>

3. Logical contrasts (غير, ولا, نفي, etc.):
   Wrap the phrase in:
   <strong data-type="contrast">...</strong>

4. Section titles:
   Use <h2>

FORBIDDEN:
• No tables
• No inline styling
• No class attributes
• No id attributes

Return ONLY HTML.


""";
  final response = await http.post(
    Uri.parse("https://api.deepinfra.com/v1/openai/chat/completions"),
    headers: {
      "Authorization": "Bearer ${Env.DEEP_INFRA_API_KEY}",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "model": "meta-llama/Meta-Llama-3-70B-Instruct",
      "temperature": 0.0,
      "messages": [
        {"role": "system", "content": prompt},
        {"role": "user", "content": rawText},
      ],
    }),
  );
  if (response.statusCode != 200) {
    pr("DeepInfra error: ${response.body}");
    return '';
  }

  final data = jsonDecode(response.body);
  final html = data["choices"][0]["message"]["content"];
  return html.trim();
}
