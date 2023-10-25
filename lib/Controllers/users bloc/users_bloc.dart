import 'dart:developer';

import 'package:message_wise/Models/user_model.dart';
import 'package:message_wise/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../service/chat/chat_service.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    List<UserModels> allUser = [];
    final chatService = ChatService();
    on<UsersListEvent>((event, emit) async {
      emit(LoadingState());

      final request = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("request")
          .snapshots();
      final sendRequest = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("sendRequest")
          .snapshots();
      final connections = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("connections")
          .snapshots();
      final users = FirebaseFirestore.instance.collection("users").snapshots();

      CombineLatestStream.list([request, sendRequest, connections, users])
          .listen((value) {
        List<UserModels> temp = [];
        for (var element in value[3].docs) {
          log("user in users ${value[1].docs}");
          int flag = 0;
          if (FirebaseAuth.instance.currentUser?.uid !=
              element.data()["userId"]) {
            if (value[0].docs.isNotEmpty) {
              //checking  user in request list
              for (var req in value[0].docs) {
                log("entered all user iteration ${req.data()["userId"]}");
                if (element.data()["userId"] == req.data()["userId"]) {
                  log("entered at request ${element.data()["userId"]}");
                  temp.add(UserModels(
                      uid: element.data()["userId"],
                      email: element.data()["email"],
                      state: UserConnections.request,
                      photo: element.data()["photo"] ??
                          "assets/images/nullPhoto.jpeg",
                      username: element.data()["userName"] ?? ""));
                  flag = 1;
                  log(" enterd into req");
                  break;
                }
              }
            }
            if (flag == 1) {
              continue;
            }
            //checking user in send request or not
            if (value[1].docs.isNotEmpty) {
              for (var sent in value[1].docs) {
                if (element.data()["userId"] == sent.data()["userId"]) {
                  temp.add(UserModels(
                      uid: element.data()["userId"],
                      email: element.data()["email"],
                      state: UserConnections.pending,
                      photo: element.data()["photo"] ??
                          "assets/images/nullPhoto.jpeg",
                      username: element.data()["userName"] ?? ""));
                  log(" entered into pending ${element.data()["userId"]}");
                  flag = 1;
                  break;
                }
              }
            }
            if (flag == 1) {
              continue;
            }
            if (value[2].docs.isNotEmpty) {
              for (var connection in value[2].docs) {
                if (element.data()["userId"] == connection.data()["botid"]) {
                  temp.add(UserModels(
                      uid: element.data()["userId"],
                      email: element.data()["email"],
                      state: UserConnections.connected,
                      photo: element.data()["photo"] ??
                          "assets/images/nullPhoto.jpeg",
                      username: element.data()["userName"] ?? ""));
                  log(" entered into connected");
                  flag = 1;
                  break;
                }
              }
            }
            if (flag == 1) {
              continue;
            } else {
              temp.add(UserModels(
                  uid: element.data()["userId"],
                  email: element.data()["email"],
                  state: UserConnections.connect,
                  photo:
                      element.data()["photo"] ?? "assets/images/nullPhoto.jpeg",
                  username: element.data()["userName"] ?? ""));
            }
          }
        }
        allUser = temp;
        log("count of all users ${allUser.length}");
        add(ProvidUserListEvent(alluser: allUser));
      });
    });
    on<ProvidUserListEvent>((event, emit) {
      log("provided list of all the users ${event.alluser.length}");
      emit(OtherUsers(bots: event.alluser));
    });
    //send request
    on<SendRequestEvent>((event, emit) async {
      log("send request event");
      await chatService
          .sendRequest(event.botId)
          .then((value) => emit(OtherUsers(bots: allUser)));
    });
    //accept request
    on<AcceptRequestEvent>((event, emit) async {
      await chatService.connnections(event.botId);
    });
    //remove request
    on<RemoveRequestEvent>((event, emit) async {
      await chatService.removeRequest(event.botId);
    });
    //dicline request
    on<DeclineRequestevent>((event, emit) async {
      chatService.diclineRequest(event.botId);
    });
  }
}
