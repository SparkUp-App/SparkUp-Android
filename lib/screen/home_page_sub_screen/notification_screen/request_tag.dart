import 'package:flutter/material.dart';
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
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(bottom: BorderSide(color: Color(0xFFADADAD)))),
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
                              arguments: (element.userId, false)),
                          child: Container(
                            child: const Icon(
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
                                  arguments: (element.userId, false)),
                              child: Container(
                                margin: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  element.nickname,
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
                                "${element.appliedTime.year}-${element.appliedTime.month}-${element.appliedTime.day}",
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
                        Container(
                            width: 90.0,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                color: const Color(0xff478BA2),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: InkWell(
                              onTap: () {
                                //Approve Fuction
                              },
                              child: const Text(
                                "Approve",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            )),
                        Container(
                            width: 90.0,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                color: const Color(0xff7F7E7E),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: InkWell(
                              onTap: () {
                                //Reject Button
                              },
                              child: const Text(
                                "Reject",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            )),
                      ],
                    )
                  ],
                )),
          ]
        ]
      ],
    );
  }
}
