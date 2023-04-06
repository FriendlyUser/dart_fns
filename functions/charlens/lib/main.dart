import 'package:dart_appwrite/dart_appwrite.dart';

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status: status)' - function to return text response. Status code defaults to 200
    'json(obj, status: status)' - function to return JSON response. Status code defaults to 200
  
  If an error is thrown, a response with code 500 will be returned.
*/

Future<void> start(final req, final res) async {
  final client = Client();

  // Uncomment the services you need, delete the ones you don't
  // final account = Account(client);
  // final avatars = Avatars(client);
  // final database = Databases(client);
  // final functions = Functions(client);
  // final health = Health(client);
  // final locale = Locale(client);
  // final storage = Storage(client);
  // final teams = Teams(client);
  // final users = Users(client);

  if (req.variables['APPWRITE_FUNCTION_ENDPOINT'] == null ||
      req.variables['APPWRITE_FUNCTION_API_KEY'] == null) {
    print(
        "Environment variables are not set. Function cannot use Appwrite SDK.");
  } else {
    client
        .setEndpoint(req.variables['APPWRITE_FUNCTION_ENDPOINT'])
        .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'])
        .setKey(req.variables['APPWRITE_FUNCTION_API_KEY'])
        .setSelfSigned(status: true);
  }

  final input = req.payload;

  if (input == null) {
    res.status(400).json({'error': 'Payload is missing'});
    return;
  }
  
  final reversedString = reverseString(input);

  res.json({
    'message': 'String reversed successfully!',
    'originalString': input,
    'reversedString': reversedString,
  });
}

String reverseString(String input) {
  if (input.isEmpty) {
    return input;
  }

  final List<String> chars = input.split('');
  final int length = chars.length;
  final StringBuffer buffer = StringBuffer();

  for (int i = length - 1; i >= 0; i--) {
    buffer.write(chars[i]);
  }

  return buffer.toString();
}