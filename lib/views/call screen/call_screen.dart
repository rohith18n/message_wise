// ignore_for_file: use_build_context_synchronously

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:message_wise/Models/call_model.dart';
import 'package:message_wise/Service/call/call_services.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/config/agora_config.dart';

class CallScreen extends StatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;

  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final callRepository = CallRepository();
  AgoraClient? client;
  String baseUrl = '';
  bool isClientInitialized = false;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  Future<void> initAgora() async {
    await client!.initialize();
    setState(() {
      isClientInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isClientInitialized
          ? SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        callRepository.endCall(
                          widget.call.callerId,
                          widget.call.receiverId,
                          context,
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.call_end),
                    ),
                  ),
                ],
              ),
            )
          : const CustomIndicator(),
    );
  }
}
