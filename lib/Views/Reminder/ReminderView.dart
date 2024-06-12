import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/Reminder.dart';
import '../../ViewModels/Reminder/ReminderViewModel.dart';
import '../../res/AppColor.dart';
import '../../res/AppText.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'ReminderDetailScreen.dart';

class RemindersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RemindersViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColor.primary),
          title: Text(
            AppLocalizations.of(context)!.reminders,
            style: TextStyle(
              color: AppColor.primary,
              fontSize: AppText.HeadingOne.fontSize,
              fontWeight: AppText.HeadingOne.fontWeight,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Consumer<RemindersViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.reminders.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: viewModel.reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = viewModel.reminders[index];
                      String message = 'This product ${reminder.productName} is nearing the end of the quantity';
                      return Center(
                        child: Container(
                          width: 350,
                          height: 100,
                          child: Card(
                            color: Colors.grey[300],
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                message,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReminderDetailScreen(reminder: reminder),
                                  ),
                                );
                              },
                              onLongPress: () {
                                _showReminderDialog(context, reminder, viewModel);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderDialog(BuildContext context, Reminder reminder, RemindersViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('This product ${reminder.productName} is nearing the end of the quantity'),
        content: Text('Do you want to acknowledge this reminder?'),
        actions: [
          TextButton(
            onPressed: () {
              viewModel.acknowledgeReminder(reminder.id);
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
