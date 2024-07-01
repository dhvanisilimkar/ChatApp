import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_chat_app/helper/auth_helper.dart';
import 'package:fb_chat_app/modal/chat_modal.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart';

import '../../helper/firestore_helper.dart';
import '../../modal/user_modal.dart';
import '../../utils/colors.dart';
import '../../utils/current_utils.dart';
import '../../utils/date_utils.dart';
import '../../utils/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModal user = CurrentUser.user;
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        title: const Text(
          "Chats",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     LocalNotificationHelper.localNotificationHelper
          //         .sendMediaNotification(title: 'demo', body: 'this is..');
          //   },
          //   icon: Icon(Icons.notification_add),
          // ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.star);
              },
              icon: Icon(
                Icons.star,
                size: 28,
              )),
          SizedBox(
            width: 5,
          )
        ],
        // elevation: 5,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: darkBlue),
              accountName: Text(
                user.name ?? "",
                style: TextStyle(fontSize: 20),
              ),
              accountEmail:
                  Text(user.email as String, style: TextStyle(fontSize: 16)),
              currentAccountPicture: CircleAvatar(
                foregroundImage: NetworkImage(
                  user.profilepic ??
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png',
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(MyRoutes.update);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: darkBlue,
                    size: 25,
                  ),
                ),
                Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: darkBlue),
                )
              ],
            ),
            Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    AuthHepler.authHepler.Signout();
                    Navigator.of(context).pushReplacementNamed(MyRoutes.sign);
                  },
                  icon: Icon(Icons.logout, color: darkBlue, size: 30),
                ),
                Text(
                  "Sign Out",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: darkBlue),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: darkBlue,
                contentPadding: EdgeInsetsDirectional.all(0),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    "Add Friend",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                content: SizedBox(
                  height: 360,
                  width: 360,
                  child: StreamBuilder(
                    stream: FireStoreHelper.fireStoreHelper.getAllUserData(),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData) {
                        QuerySnapshot? snap = snapshot2.data;

                        List<QueryDocumentSnapshot> allData = snap!.docs;

                        List<UserModal> allUsers = allData
                            .map(
                              (e) => UserModal.fromMap(
                                  data: e.data() as Map<String, dynamic>),
                            )
                            .toList();

                        allUsers.removeWhere(
                            (element) => element.email == user.email);
                        return Container(
                          height: 360,
                          width: 360,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: lightBlue,
                          ),
                          child: ListView.builder(
                            itemCount: allUsers.length,
                            itemBuilder: (context, index) {
                              UserModal member = allUsers[index];
                              return Card(
                                margin: EdgeInsets.only(top: 14),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      FireStoreHelper.fireStoreHelper
                                          .addContact(
                                              senderEmail: user.email,
                                              receiverEmail: member.email)
                                          .then((value) =>
                                              Navigator.of(context).pop());
                                    },
                                    title: Text(member.email),
                                    leading: CircleAvatar(
                                      foregroundImage:
                                          NetworkImage(member.profilepic),
                                    ),
                                    trailing: Container(
                                      height: 40,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: darkBlue,
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            // separatorBuilder:
                            //     (context, index) {
                            //   return const Divider();
                            // },
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      backgroundColor: darkBlue,
      body: Container(
        height: s.height,
        width: s.width,
        margin: EdgeInsetsDirectional.only(top: 20),
        decoration: BoxDecoration(
          color: whiteTheme,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(30),
            topEnd: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 1, bottom: 16, right: 16, left: 16),
          child: StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper
                .getCountactList(email: user.email),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("ERROR : ${snapshot.hasError}"),
                );
              } else if (snapshot.hasData) {
                DocumentSnapshot<Map<String, dynamic>>? snaps = snapshot.data;

                Map data = snaps?.data() as Map;

                List contacts = data['contact'] ?? [];

                return contacts.isNotEmpty
                    ? ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FireStoreHelper.fireStoreHelper
                                .getUserById(email: contacts[index]),
                            builder: (context, userSnap) {
                              if (userSnap.hasData) {
                                DocumentSnapshot? docs = userSnap.data;
                                UserModal userModal = UserModal.fromMap(
                                    data: docs!.data() as Map<String, dynamic>);

                                return GestureDetector(
                                  onLongPress: () {
                                    ChatModal chatModal =
                                        ChatModal.fromMap(data: data);

                                    print("Delete");
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.blue,
                                            title: Text("Delete Your Message?"),
                                            content: Row(
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Cancel")),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    chatModal.msg =
                                                        "You Deleted this Message.";
                                                    // chatModal.star ='unstar';
                                                    chatModal.react = 'null';
                                                    FireStoreHelper
                                                        .fireStoreHelper
                                                        .updateChat(
                                                      chatModal: chatModal,
                                                      receiverEmail:
                                                          userModal.email,
                                                      senderEmail: CurrentUser
                                                          .user.email,
                                                    );

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Delete"),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Card(
                                    margin: EdgeInsets.only(top: 14),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                          )),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            MyRoutes.chat,
                                            arguments: userModal,
                                          );
                                        },
                                        leading: CircleAvatar(
                                          foregroundImage: NetworkImage(
                                              userModal.profilepic),
                                        ),
                                        title: Text(
                                          userModal.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        subtitle: StreamBuilder(
                                          stream: FireStoreHelper
                                              .fireStoreHelper
                                              .getLastMsgAndCounter(
                                                  receiverEmail:
                                                      userModal.email,
                                                  sendereEmail:
                                                      CurrentUser.user.email),
                                          builder: (context, lastMsgSnapshot) {
                                            if (lastMsgSnapshot.hasData) {
                                              DocumentSnapshot<
                                                      Map<String, dynamic>>
                                                  snaps2 =
                                                  lastMsgSnapshot.data!;
                                              Map<String, dynamic> lastMsgData =
                                                  snaps2.data() ?? {};
                                              print(lastMsgData['lastMsg']);
                                              return lastMsgData.isNotEmpty
                                                  ? Row(
                                                      children: [
                                                        lastMsgData['lastMsg'] ==
                                                                'You Deleted this Message.'
                                                            ? Icon(
                                                                Icons.block,
                                                                size: 20,
                                                                color:
                                                                    Colors.grey,
                                                              )
                                                            : lastMsgData[
                                                                        'type'] ==
                                                                    "sent"
                                                                ? Icon(
                                                                    Icons
                                                                        .done_all,
                                                                    size: 20,
                                                                    color: (lastMsgData['counter'] ==
                                                                            0)
                                                                        ? lightBlue
                                                                        : darkBlue)
                                                                : SizedBox(),
                                                        const Gap(5),
                                                        Expanded(
                                                          child: Text(
                                                            lastMsgData[
                                                                'lastMsg'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontStyle: lastMsgData[
                                                                            'lastMsg'] ==
                                                                        'You Deleted this Message.'
                                                                    ? FontStyle
                                                                        .italic
                                                                    : null),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      "Click here to start Chat..!",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    );
                                            } else {
                                              return Text(
                                                "Click here to start Chat..!",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              );
                                            }
                                          },
                                        ),
                                        trailing: Column(
                                          children: [
                                            StreamBuilder(
                                              stream: FireStoreHelper
                                                  .fireStoreHelper
                                                  .getLastMsgAndCounter(
                                                      receiverEmail:
                                                          userModal.email,
                                                      sendereEmail: CurrentUser
                                                          .user.email),
                                              builder: (context, timeSnapshot) {
                                                if (timeSnapshot.hasData) {
                                                  DocumentSnapshot<
                                                          Map<String, dynamic>>
                                                      snaps2 =
                                                      timeSnapshot.data!;
                                                  Map<String, dynamic>
                                                      timeMsgData =
                                                      snaps2.data() ?? {};
                                                  if (timeMsgData.isNotEmpty) {
                                                    DateTime dt = DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                      int.parse(
                                                          timeMsgData['time']),
                                                    );

                                                    Duration day =
                                                        DateTime.now()
                                                            .difference(dt);
                                                    String date = "";
                                                    if (day.inDays > 0) {
                                                      print(
                                                          "Day: $day :days : ${day.inDays}");
                                                      if (day.inDays == 1) {
                                                        date = "YesterDay";
                                                      } else if (day.inDays >=
                                                              2 &&
                                                          day.inDays <= 7) {
                                                        date = getWeekDay(
                                                            day: dt.weekday);
                                                      } else {
                                                        date = "${dt.day}"
                                                                .padLeft(
                                                                    2, "0") +
                                                            "/" +
                                                            "${dt.month}"
                                                                .padLeft(
                                                                    2, "0") +
                                                            "/" +
                                                            "${dt.year}";
                                                      }
                                                    } else if (int.parse(day
                                                            .inHours
                                                            .toString()) >
                                                        DateTime.now().hour) {
                                                      date = "YesterDay";
                                                    } else {
                                                      date = "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}"
                                                              .padLeft(2, "0") +
                                                          ":" +
                                                          "${dt.minute}"
                                                              .padLeft(2, "0") +
                                                          " " +
                                                          "${(dt.hour > 12) ? "PM" : "Am"}";
                                                    }
                                                    return Text(date,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey));
                                                  } else {
                                                    return Text(
                                                      "",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    );
                                                  }
                                                  ;
                                                } else {
                                                  return Text(
                                                    "Click here to start Chat..!",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  );
                                                }
                                              },
                                            ),
                                            const Gap(8),
                                            StreamBuilder(
                                              stream: FireStoreHelper
                                                  .fireStoreHelper
                                                  .getLastMsgAndCounter(
                                                      receiverEmail:
                                                          userModal.email,
                                                      sendereEmail: CurrentUser
                                                          .user.email),
                                              builder:
                                                  (context, lastMsgSnapshot) {
                                                if (lastMsgSnapshot.hasData) {
                                                  DocumentSnapshot<
                                                          Map<String, dynamic>>
                                                      snaps2 =
                                                      lastMsgSnapshot.data!;
                                                  Map<String, dynamic>
                                                      lastMsgData =
                                                      snaps2.data() ?? {};
                                                  return (lastMsgData
                                                          .isNotEmpty)
                                                      ? (lastMsgData['counter'] ==
                                                                  0 ||
                                                              lastMsgData[
                                                                      'type'] ==
                                                                  'sent')
                                                          ? SizedBox()
                                                          : Container(
                                                              height: 25,
                                                              width: 25,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                      darkBlue),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                lastMsgData[
                                                                        'counter']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                      : SizedBox();
                                                } else {
                                                  return SizedBox();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                                  ),
                                  title: Text("Loading..."),
                                );
                              }
                            },
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                alignment: Alignment.centerRight,
                                image: AssetImage('assets/images/fd.png'),
                              )),
                            ),
                            Gap(30),
                            Text(
                              "Click on + button..!!",
                              style: TextStyle(
                                  fontSize: 26,
                                  color: darkBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                            //https://github.com/TingzhouJia/flutter-chat/blob/master/pubspec.yaml
                          ],
                        ),
                      );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
