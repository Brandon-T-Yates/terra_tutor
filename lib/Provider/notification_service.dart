import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final String serverToken = '';
  final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

  NotificationService();

  Future<void> sendFCMNotification(String plantName) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      };

      final body = jsonEncode({
        'notification': {
          'title': 'Water Reminder',
          'body': 'It\'s time to water $plantName!',
        },
        'priority': 'high',
        'to': '/topics/all',
      });

      final response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('FCM notification sent successfully.');
      } else {
        print(
            'Failed to send FCM notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending FCM notification: $e');
    }
  }
}
