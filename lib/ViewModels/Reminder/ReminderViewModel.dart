import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../Models/Reminder.dart';
import '../../Services/network_service.dart';

class RemindersViewModel extends ChangeNotifier {
  final NetworkService _networkService = NetworkService();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  RemindersViewModel() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> fetchReminders() async {
    try {
      List<Map<String, dynamic>> remindersData = await _networkService.fetchAll('Reminders');
      _reminders = remindersData.map((data) {
        String documentId = data['documentId'] ?? '';
        return Reminder.fromMap(data, documentId);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch reminders: $e');
    }
  }

  Future<void> acknowledgeReminder(String reminderId) async {
    try {
      await _networkService.updateData('Reminders', 'id', reminderId, {'acknowledged': true});
      await fetchReminders();
    } catch (e) {
      print('Failed to acknowledge reminder: $e');
    }
  }

  Future<void> checkAndAddReminder(String productId) async {
    try {
      Map<String, dynamic> productData = await _networkService.fetchData('products', 'id', productId);
      int currentStock = productData['quantity'];
      String productName = productData['productName'];
      DateTime? expDate = (productData['expDate'] as Timestamp?)?.toDate();

      // Check if the product is near sold out
      if (currentStock <= 5) {
        Reminder newReminder = Reminder(
          id: '',
          productId: productId,
          productName: productName,
          currentStock: currentStock,
          timestamp: DateTime.now(),
        );

        await _networkService.sendData('Reminders', newReminder.toMap());
        await fetchReminders();
        _showNotification(productName, 'Low stock: $currentStock remaining');
      }

      // Check if the expiration date is within 10 days
      if (expDate != null && expDate.difference(DateTime.now()).inDays <= 10) {
        Reminder newReminder = Reminder(
          id: '',
          productId: productId,
          productName: productName,
          currentStock: currentStock,
          timestamp: DateTime.now(),
          expDate: expDate,
        );

        await _networkService.sendData('Reminders', newReminder.toMap());
        await fetchReminders();
        _showNotification(productName, 'Product expiring soon');
      }
    } catch (e) {
      print('Failed to check and add reminder: $e');
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      // 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
