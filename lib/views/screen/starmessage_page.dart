import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../helper/firestore_helper.dart';
import '../../modal/user_modal.dart';
import '../../utils/colors.dart';
import '../../utils/current_utils.dart';
import '../components/date_methods.dart';

class StarMessagePage extends StatelessWidget {
  const StarMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        title: const Text(
          "Starred Message",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: darkBlue,
      body: Container(
        height: s.height,
        width: s.width,
        margin: EdgeInsetsDirectional.only(top: 20),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(30),
            topEnd: Radius.circular(30),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 1, bottom: 16, right: 16, left: 16),
          child: StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper
                .getStarMessage(senderEmail: CurrentUser.user.email),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot<Map<String, dynamic>>? data = snapshot.data!;
                List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                    data.docs;

                return (docs.length > 0)
                    ? ListView.separated(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FireStoreHelper.fireStoreHelper
                                .getUserById(email: docs[index]['email']),
                            builder: (context, snapshot2) {
                              if (snapshot2.hasData) {
                                DocumentSnapshot? snap = snapshot2.data;
                                UserModal userModal = UserModal.fromMap(
                                    data: snap!.data() as Map<String, dynamic>);
                                return ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage:
                                        NetworkImage(userModal.profilepic),
                                  ),
                                  title:
                                      (userModal.name == CurrentUser.user.name)
                                          ? Text(
                                              "You",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              userModal.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                  subtitle: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Card(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusDirectional.only(
                                              bottomStart: Radius.circular(0),
                                              topEnd: Radius.circular(15),
                                              topStart: Radius.circular(15),
                                              bottomEnd: Radius.circular(15),
                                            ),
                                          ),
                                          color: docs[index]['type'] == "sent"
                                              ? darkBlue
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(docs[index]['msg'],
                                                    maxLines: 10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: docs[index]
                                                                  ['type'] ==
                                                              'sent'
                                                          ? Colors.white
                                                          : null,
                                                    )),
                                                const Gap(8),
                                                Column(
                                                  children: [
                                                    const Gap(8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: docs[index][
                                                                      'type'] ==
                                                                  'sent'
                                                              ? Colors.white
                                                                  .withOpacity(
                                                                      0.7)
                                                              : Colors.grey
                                                                  .withOpacity(
                                                                      0.7),
                                                          size: 15,
                                                        ),
                                                        getTimeData(
                                                            time: docs[index]
                                                                ['time'],
                                                            type: docs[index]
                                                                ['type']),
                                                        const Gap(3),
                                                        (docs[index]['type'] ==
                                                                'sent')
                                                            ? Icon(
                                                                Icons.done_all,
                                                                size: 20,
                                                                color: (docs[index]
                                                                            [
                                                                            'status'] ==
                                                                        'seen')
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.4),
                                                              )
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Gap(60),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Text("No Starred Message..!");
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/store.png',
                              scale: 1,
                            ),
                            Text(
                              "No Starred Messages..!!",
                              style: TextStyle(
                                  fontSize: 26,
                                  color: darkBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                            Gap(100),
                          ],
                        ),
                      );
              } else {
                return Text("No Starred Message..!");
              }
            },
          ),
        ),
      ),
    );
  }
}
