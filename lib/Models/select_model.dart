import 'package:message_wise/Models/user_model.dart';

class SelectModel {
  bool isselected = false;
  final UserModels bot;

  SelectModel({required this.bot, this.isselected = false});
}
