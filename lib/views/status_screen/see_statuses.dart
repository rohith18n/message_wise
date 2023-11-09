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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('status')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomIndicator();
          }
          final users = snapshot.data!.docs;

          return Column(
            children: [
              // Place the CircleAvatar list view at the top
              SizedBox(
                height: getProportionateScreenHeight(100),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length + 1, // Add 1 for "Add New Status"
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
                          height: getProportionateScreenHeight(
                              90), // Reduced height

                          child: ListTile(
                            contentPadding:
                                EdgeInsets.zero, // Remove ListTile padding
                            title: Column(
                              // Center content
                              children: [
                                CircleAvatar(
                                  // Use a plus icon or any other icon as needed
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
                      final user = users[index - 1].data();
                      final userId = users[index - 1].id;
                      final profileImage = user['profImage'];

                      return Container(
                        margin: EdgeInsets.only(
                            right: getProportionateScreenWidth(4)),
                        width: getProportionateScreenWidth(90),
                        height:
                            getProportionateScreenHeight(90), // Reduced height
                        //
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.zero, // Remove ListTile padding
                          title: Column(
                            // Center content
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(profileImage),
                                radius: getProportionateScreenWidth(27),
                              ),
                              Text(
                                user['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('EEE, hh:mm a z')
                                    .format(user['datePublished'].toDate()),
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
                                  statusId: userId,
                                  statusMap: user,
                                ),
                              ),
                            );
                          },
                        ),
                      );
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
