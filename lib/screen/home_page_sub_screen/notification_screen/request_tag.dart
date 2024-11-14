import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/confirm_dialog.dart';
import 'package:spark_up/common_widget/event_card_skeleton.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/applicant_list_received.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/applicant_path.dart';
import 'package:spark_up/route.dart';

class RequestTag extends StatefulWidget {
  const RequestTag({super.key});

  @override
  State<RequestTag> createState() => _RequestTagState();
}

class _RequestTagState extends State<RequestTag>
    with AutomaticKeepAliveClientMixin {
  late List<ApplicantListReceived> haveApplicantEvents;
  late List<bool> dropDownStatus;
  bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    haveApplicantEvents = [];
    dropDownStatus = [];
    getApplicantList();
  }

  Future getApplicantList() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

    final resposne = await Network.manager.sendRequest(
        method: RequestMethod.get,
        path: ApplicantPath.list,
        pathMid: ["${Network.manager.userId}"]);

    if (context.mounted) {
      if (resposne["status"] == "success") {
        haveApplicantEvents = (resposne["data"]["posts"] as List<dynamic>)
            .map((element) => ApplicantListReceived.initfromData(element))
            .toList();
        dropDownStatus = List.filled(haveApplicantEvents.length, false);
      } else {
        showDialog(
            context: context,
            builder: (context) => const SystemMessage(
                  content: "Something Went Wrong Pleas Try Againg Later",
                ));
      }
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? const eventCardSkeletonList()
        : RefreshIndicator(
            child: ListView(
              children: [
                for (int index = 0;
                    index < haveApplicantEvents.length;
                    index++) ...[applyDroper(index)]
              ],
            ),
            onRefresh: () async {
              haveApplicantEvents.clear();
              await getApplicantList();
              return;
            });
  }

  Widget applyDroper(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: dropDownStatus[index]
                    ? const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0))
                    : BorderRadius.circular(10.0),
                color: const Color(0xFFF5A278)),
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  haveApplicantEvents[index].postTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      dropDownStatus[index] = !dropDownStatus[index];
                      setState(() {});
                    },
                    icon: dropDownStatus[index]
                        ? const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                          ))
              ],
            )),
        if (dropDownStatus[index]) ...[
          for (var element in haveApplicantEvents[index].applicants) ...[
            ApplyUserCard(
              applicantUser: element,
              postId: haveApplicantEvents[index].postId,
              removeApplyUserCard: removeApplyUserCard,
            )
          ]
        ]
      ],
    );
  }

  void removeApplyUserCard(ApplicantUser applicantUser, int postId) {
    haveApplicantEvents
        .firstWhere((event) => event.postId == postId)
        .applicants
        .remove(applicantUser);
  }
}

class ApplyUserCard extends StatefulWidget {
  const ApplyUserCard(
      {super.key,
      required this.applicantUser,
      required this.postId,
      required this.removeApplyUserCard});

  final int postId;
  final ApplicantUser applicantUser;
  final Function(ApplicantUser, int) removeApplyUserCard;

  @override
  State<ApplyUserCard> createState() => _ApplyUserCardState();
}

class _ApplyUserCardState extends State<ApplyUserCard> {
  bool isLoading = false;
  bool approve = false;
  bool reject = false;

  Future approveProcess() async {
    if (isLoading) return;
    bool result = await confirmDialog(
        context, "You sure to approve", widget.applicantUser.nickname);
    if (result) {
      isLoading = true;
      setState(() {});

      final response = await Network.manager.sendRequest(
          method: RequestMethod.post,
          path: ApplicantPath.review,
          data: {
            "user_id": widget.applicantUser.userId,
            "post_id": widget.postId,
            "approve": true
          });

      if (context.mounted) {
        if (response["status"] == "success") {
          showDialog(
              context: context,
              builder: (context) =>
                  const SystemMessage(content: "Approve Successs"));
          approve = true;
          widget.removeApplyUserCard(widget.applicantUser, widget.postId);
        } else {
          showDialog(
              context: context,
              builder: (context) => const SystemMessage(
                  content: "Something Went Wrong Pleas Try Again Later"));
        }
      }

      isLoading = false;
      setState(() {});
    }
  }

  Future rejectProcess() async {
    if (isLoading) return;
    bool result = await confirmDialog(
        context, "You sure to reject", widget.applicantUser.nickname);
    if (result) {
      isLoading = true;
      setState(() {});

      final response = await Network.manager.sendRequest(
          method: RequestMethod.post,
          path: ApplicantPath.review,
          data: {
            "user_id": widget.applicantUser.userId,
            "post_id": widget.postId,
            "approve": false
          });

      if (context.mounted) {
        if (response["status"] == "success") {
          showDialog(
              context: context,
              builder: (context) =>
                  const SystemMessage(content: "Reject Successs"));
          reject = true;
          widget.removeApplyUserCard(widget.applicantUser, widget.postId);
        } else {
          showDialog(
              context: context,
              builder: (context) => const SystemMessage(
                  content: "Something Went Wrong Pleas Try Again Later"));
        }
      }

      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFADADAD)))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //User Head
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      RouteMap.profileShowPage,
                      arguments: (widget.applicantUser.userId, false)),
                  child: const SizedBox(
                    child: Icon(
                      Icons.circle,
                      color: Colors.black12,
                      size: 60.0,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                          RouteMap.profileShowPage,
                          arguments: (widget.applicantUser.userId, false)),
                      child: Container(
                        margin: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          widget.applicantUser.nickname,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: const Text(
                        "Bio: ",
                        style: TextStyle(
                            color: Color(0xFF4B4B4B),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "${widget.applicantUser.appliedTime.year}-${widget.applicantUser.appliedTime.month}-${widget.applicantUser.appliedTime.day}",
                        style: const TextStyle(
                            color: Color(0xFF7F7E7E),
                            fontSize: 10.0,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (approve || reject) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: approve ? Colors.green : Colors.red),
                    child: Text(
                      approve ? "Approve" : "Reject",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )
                ] else ...[
                  Container(
                      width: 90.0,
                      height: 35.0,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: const Color(0xff478BA2),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: InkWell(
                        onTap: () {
                          approveProcess();
                        },
                        child: isLoading
                            ? const SizedBox(
                                height: 10.0,
                                width: 10.0,
                                child: CircularProgressIndicator(
                                  color: Colors.black12,
                                  strokeWidth: 2.0,
                                ))
                            : const Text(
                                "Approve",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                      )),
                  Container(
                      width: 90.0,
                      height: 35.0,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: const Color(0xff7F7E7E),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: InkWell(
                        onTap: () {
                          rejectProcess();
                        },
                        child: isLoading
                            ? const SizedBox(
                                width: 10.0,
                                height: 10.0,
                                child: CircularProgressIndicator(
                                  color: Colors.black12,
                                  strokeWidth: 2.0,
                                ))
                            : const Text(
                                "Reject",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                      )),
                ]
              ],
            )
          ],
        ));
  }
}
