import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/status_screen/add_statuses.dart';
import 'package:message_wise/views/status_screen/widgets/status_view.dart';

class SeeStatus extends StatefulWidget {
  const SeeStatus({super.key});

  @override
  State<SeeStatus> createState() => _SeeStatusState();
}

class _SeeStatusState extends State<SeeStatus> {
  final subtractionTime = DateTime.now().subtract(const Duration(minutes: 10));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('status')
            .where('datePublished', isGreaterThan: subtractionTime)
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Text('No data available');
          }

          final users = snapshot.data!.docs;

          // Create a map to group statuses by uid
          Map<String, List<Map<String, dynamic>>> statusMap = {};

          for (var userDocument in users) {
            final user = userDocument.data();
            final userId = userDocument.id;
            final uid = user['uid'];

            if (user['profImage'] != null) {
              if (!statusMap.containsKey(uid)) {
                statusMap[uid] = [];
              }

              statusMap[uid]?.add({
                'userId': userId,
                'user': user,
              });
            }
          }

          return Column(
            children: [
              // Place the CircleAvatar list view at the top
              SizedBox(
                height: getProportionateScreenHeight(100),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: statusMap.length + 1, // Add 1 for "Add New Status"
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Display "Add New Status" as the first item
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the AddStatus page when clicking the first CircleAvatar
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddStatus(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: getProportionateScreenWidth(90),
                          height: getProportionateScreenHeight(90),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  radius: getProportionateScreenWidth(27),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  "Status",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      final uid = statusMap.keys.elementAt(index - 1);
                      final statuses = statusMap[uid];
                      log(statuses.toString());

                      if (statuses!.isNotEmpty) {
                        return Container(
                          margin: EdgeInsets.only(
                              right: getProportionateScreenWidth(4)),
                          width: getProportionateScreenWidth(90),
                          height: getProportionateScreenHeight(90),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Column(
                              children: [
                                if (statuses.first['user']['profImage'] != null)
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        statuses.first['user']['profImage']),
                                    radius: getProportionateScreenWidth(27),
                                  ),
                                Text(
                                  statuses.first['user']['username'] ??
                                      'No username',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('EEE, hh:mm a z').format(statuses
                                          .first['user']['datePublished']
                                          ?.toDate() ??
                                      DateTime.now()),
                                  style: const TextStyle(
                                    color: kTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigate to a new screen to display the user's statuses
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StatusViewPage(
                                    statuses: statuses,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        // Handle the case where statuses are empty or missing
                        return const Text('No statuses available');
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
