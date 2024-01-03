class APIConstants {
  static const String baseUrl = 'https://api.naemonemon.com/'; // dev
  static const String naemonemonStore = 'https://play.google.com/store/apps/details?id=com.naemo.nemon'; //store link

  ///Users
  static const String usersLogin = '${baseUrl}users/login';
  static const String usersInfo = '${baseUrl}users/info';
  static const String usersUpdate = '${baseUrl}users/update';

  ///Group
  static const String getGroups = '${baseUrl}groups';

  ///cart
  static const String getCarts = '${baseUrl}carts';

  ///poll
  static const String polls = '${baseUrl}polls';
  static const String pollFinish = '${baseUrl}polls/finish';
  static const String pollWebGet = '${baseUrl}polls/webget/';
  static const String joinPoll = '${baseUrl}polls/join/';






  static String getParamsFromBody(Map<String, dynamic>? body) {
    String params = '?';
    for (var i = 0; i < body!.keys.length; i++) {
      params += '${List.from(body.keys)[i]}=${List.from(body.values)[i]}';
      if (i != body.keys.length - 1) {
        params += '&';
      }
    }
    return params;
  }
}

