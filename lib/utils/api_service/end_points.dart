class EndPoint {
  static const String pyBackend = "https://api.rag-ai.org";
  // static const String pyBackend = "http://quran-api-alb-2112244203.eu-north-1.elb.amazonaws.com";
  static const String initSession = "$pyBackend/rag/initsession";
  static const String ayat = "$pyBackend/Ayat";
  static const String generate = "$pyBackend/rag/generate";
  static const String initTicket = "$pyBackend/rag/init-ticket";
  static const String checkTicket = "$pyBackend/rag/check-ticket";
  static const String deleteTicket = "$pyBackend/rag/clear-ticket";
  static const String wordsBaseUrl = "https://words.safqauae.com/api";
  static const String roots = '$wordsBaseUrl/roots';
  static const String allroots = '$wordsBaseUrl/allroots';
  static const String words = '$wordsBaseUrl/words';
  static const String verses = '$wordsBaseUrl/verses';
  static const String quranRootsSearch = '$wordsBaseUrl/quran-search';
  static const String notificationsIndex = 'notifications';
}
