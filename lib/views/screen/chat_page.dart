import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../controller/datelable.dart';
import '../../helper/firestore_helper.dart';
import '../../modal/chat_modal.dart';
import '../../modal/user_modal.dart';
import '../../utils/colors.dart';
import '../../utils/current_utils.dart';
import '../components/chat_cart.dart';
import '../components/date_methods.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    String tmpDate = '';
    bool fisrRunScroll = true;

    scrollistener() {
      ValueNotifier vn = scrollController.position.isScrollingNotifier;
      ScrollPosition sp = scrollController.position;
      Logger logger = Logger();
      if ((scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          scrollController.position.userScrollDirection ==
              ScrollDirection.reverse)) {
        if (Provider.of<DateLabelController>(context, listen: false)
                .dateLabelVisibility ==
            false) {
          Provider.of<DateLabelController>(context, listen: false)
              .setVisibilityTrue();
        }
        Provider.of<DateLabelController>(context, listen: false)
            .setText(text: tmpDate);
      } else {
        Timer.periodic(Duration(seconds: 3), (timer) {
          Provider.of<DateLabelController>(context, listen: false)
              .setVisibilityFalse();
        });
      }
      // if (scrollController.position.userScrollDirection ==
      //         ScrollDirection.forward ||
      //     scrollController.position.userScrollDirection ==
      //         ScrollDirection.reverse) {
      //   Provider.of<DateLabelController>(context, listen: false)
      //       .setText(text: tmpDate);
      //   if (!Provider.of<DateLabelController>(context, listen: false)
      //       .dateLabelVisibility) {
      //     Provider.of<DateLabelController>(context, listen: false)
      //         .setVisibilityTrue();
      //   }
      //
      //   Timer.periodic(Duration(seconds: 4), (timer) {
      //     if (Provider.of<DateLabelController>(context, listen: false)
      //         .dateLabelVisibility) {
      //       Provider.of<DateLabelController>(context, listen: false)
      //           .setVisibilityFalse();
      //     }
      //   });
      // }
    }

    // scrollController

    scrollController.addListener(() {
      scrollistener();
    });

    double alignmentX = 0, alignmentY = 0;
    TextEditingController chatTextController = TextEditingController();
    UserModal user = ModalRoute.of(context)!.settings.arguments as UserModal;
    Size s = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: darkBlue,
          foregroundColor: whiteTheme,
          shadowColor: Colors.black,
          title: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(0),
                    children: [
                      BlurryContainer(
                        blur: 18,
                        child: Container(
                          height: s.height,
                          width: s.width,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        size: 30,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Center(
                                child: CircleAvatar(
                                  radius: 120,
                                  foregroundImage:
                                      NetworkImage(user.profilepic),
                                ),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  // radius: 20,
                  foregroundImage: NetworkImage(user.profilepic),
                ),
                const Gap(5),
                Container(
                  width: 200,
                  child: Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          height: s.height,
          width: s.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://i.pinimg.com/564x/e0/0b/9a/e00b9a6bce8958583185fd2b49dd6c74.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: StreamBuilder(
                    stream: FireStoreHelper.fireStoreHelper.getChatData(
                        receiverEmail: user.email,
                        senderEmail: CurrentUser.user.email),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot<Map<String, dynamic>>? snaps =
                            snapshot.data;
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>?
                            data = snaps?.docs;
                        List<ChatModal> chats = data!
                            .map((e) => ChatModal.fromMap(data: e.data()))
                            .toList();

                        chats.forEach((element) {
                          if (element.type == 'rec') {
                            if (element.status == 'notseen') {
                              element.status = "seen";
                              FireStoreHelper.fireStoreHelper.updateStatus(
                                  chatModal: element,
                                  receiverEmail: user.email,
                                  sendereEmail: CurrentUser.user.email);
                            }
                          }
                        });
                        List<GlobalKey> key =
                            List.generate(chats.length, (index) => GlobalKey());
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            ChatModal chatModal = chats[index];

                            if (fisrRunScroll) {
                              Timer(
                                Duration(milliseconds: 100),
                                () => scrollController.jumpTo(
                                    scrollController.position.maxScrollExtent),
                              );
                              fisrRunScroll = false;
                            }

                            String checkDate = '';
                            if (index > 0) {
                              checkDate = getCheckDate(
                                  timeMsgData: chats[index - 1]
                                      .time
                                      .millisecondsSinceEpoch
                                      .toString());
                            }
                            tmpDate = getCheckDate(
                                timeMsgData: chatModal
                                    .time.millisecondsSinceEpoch
                                    .toString());
                            // Logger logger = Logger();
                            // logger.i(
                            //     "Date: $tmpDate  Msg: ${chatModal.msg}, time: ${chatModal.time}/n tmpDate : ${tmpDate} checkDate : ${checkDate},,${tmpDate == checkDate}");

                            return (checkDate ==
                                    getCheckDate(
                                        timeMsgData: chatModal
                                            .time.millisecondsSinceEpoch
                                            .toString()))
                                ? getChatCard(
                                    chatModal: chatModal,
                                    key: key[index],
                                    alignmentX: alignmentX,
                                    alignmentY: alignmentY,
                                    s: s,
                                    context: context,
                                    user: user)
                                : Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 23,
                                          width: 90,
                                          margin: EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          padding:
                                              EdgeInsets.fromLTRB(8, 2, 8, 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xffE9E6DF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: greyTheme,
                                                blurRadius: 1,
                                                offset: Offset(0, 1),
                                              )
                                            ],
                                          ),
                                          child: Text(
                                            (tmpDate.contains(':'))
                                                ? 'Today'
                                                : tmpDate,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      getChatCard(
                                          chatModal: chatModal,
                                          key: key[index],
                                          alignmentX: alignmentX,
                                          alignmentY: alignmentY,
                                          s: s,
                                          context: context,
                                          user: user),
                                    ],
                                  );
                          },
                        );
                        // return Text("Data Gated...");
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )),
                  Container(
                    width: s.width,
                    height: 80,
                    color: Colors.white.withOpacity(0.7),
                    padding: EdgeInsetsDirectional.only(
                        top: 10, bottom: 16, end: 16, start: 16),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: chatTextController,
                      decoration: InputDecoration(
                        hintText: "Type a Message here..",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: darkBlue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: darkBlue,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: darkBlue,
                          ),
                        ),
                        fillColor: greyTheme,
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (chatTextController.text != "") {
                              ChatModal chatModal = ChatModal(
                                  msg: chatTextController.text,
                                  type: 'sent',
                                  time: DateTime.now(),
                                  status: 'notseen',
                                  star: "unstar",
                                  react: "null");
                              FireStoreHelper.fireStoreHelper
                                  .sendMessage(
                                      chatModal: chatModal,
                                      receiverEmail: user.email,
                                      senderEmail: CurrentUser.user.email)
                                  .then((value) => chatTextController.clear());
                              Timer(
                                Duration(milliseconds: 100),
                                () => scrollController.jumpTo(
                                    scrollController.position.maxScrollExtent),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: darkBlue,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (val) {
                        if (chatTextController.text != "") {
                          ChatModal chatModal = ChatModal(
                              msg: val,
                              type: 'sent',
                              time: DateTime.now(),
                              status: 'notseen',
                              star: 'unstar',
                              react: 'null');
                          FireStoreHelper.fireStoreHelper.sendMessage(
                              chatModal: chatModal,
                              receiverEmail: user.email,
                              senderEmail: CurrentUser.user.email);
                        }
                        Timer(
                          Duration(milliseconds: 10),
                          () => scrollController.jumpTo(
                              scrollController.position.maxScrollExtent),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
