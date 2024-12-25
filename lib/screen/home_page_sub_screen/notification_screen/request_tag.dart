import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/confirm_dialog.dart';
import 'package:spark_up/common_widget/request_tag_skeleton.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/common_widget/user_head.dart';
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
        ? const RequestSkeletonListRandomLength()
        : RefreshIndicator(
            child: haveApplicantEvents.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // 讓內容根據內容大小適配
                        children: [
                          Image.asset(
                            'assets/No_Event_space.png', // 替換為你的 PNG 圖片路徑
                            width: MediaQuery.of(context).size.width *
                                0.9, // 寬度設置為屏幕的 90%
                            height: MediaQuery.of(context).size.height * 0.35,
                            fit: BoxFit.contain, // 確保圖片不會變形
                          ),
                          const SizedBox(height: 16), // 圖片與文字之間的間距
                          const Text(
                            "Nobody Apply. Please wait...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center, // 確保文字居中
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      for (var element in haveApplicantEvents)
                        ApplyDroper(applicantListReceived: element),
                      if (haveApplicantEvents.isEmpty)
                        const Center(
                          child: Text(
                            "Nobody Apply",
                            style: TextStyle(color: Colors.black26),
                          ),
                        ),
                    ],
                  ),
            onRefresh: () async {
              haveApplicantEvents.clear();
              await getApplicantList();
              return;
            });
  }
}

class ApplyDroper extends StatefulWidget {
  const ApplyDroper({super.key, required this.applicantListReceived});

  final ApplicantListReceived applicantListReceived;

  @override
  State<ApplyDroper> createState() => _ApplyDroperState();
}

class _ApplyDroperState extends State<ApplyDroper> {
  bool dropStatus = false;
  final buttonKey = GlobalKey();

  void removeApplyUserCard(ApplicantUser applicantUser) {
    widget.applicantListReceived.applicants.remove(applicantUser);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(16),
              bottom: Radius.circular(dropStatus ? 0 : 16),
            ),
            color: const Color(0xFFF5A278),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF5A278).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  dropStatus = !dropStatus;
                });
              },
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(16),
                bottom: Radius.circular(dropStatus ? 0 : 16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.assignment,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.applicantListReceived.postTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: dropStatus ? 0.5 : 0,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 150),
          crossFadeState:
              dropStatus ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: widget.applicantListReceived.applicants.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No one is waiting for apply",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Check back later for new applicants",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: widget.applicantListReceived.applicants
                        .map(
                          (element) => ApplyUserCard(
                            applicantUser: element,
                            postId: widget.applicantListReceived.postId,
                            removeApplyUserCard: removeApplyUserCard,
                          ),
                        )
                        .toList(),
                  ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
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
  final Function(ApplicantUser) removeApplyUserCard;

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
          widget.removeApplyUserCard(widget.applicantUser);
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
          widget.removeApplyUserCard(widget.applicantUser);
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
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: () => Navigator.of(context).pushNamed(
              //     RouteMap.profileShowPage,
              //     arguments: (widget.applicantUser.userId, false),
              //   ),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       border:
              //           Border.all(color: const Color(0xFFE0E0E0), width: 2),
              //     ),
              //     child: const CircleAvatar(
              //         radius: 30,
              //         backgroundColor: Color(0xFFF5F5F5),
              //         child: SizedBox()),
              //   ),
              // ),
              UserHead(
                userId: widget.applicantUser.userId,
                level: widget.applicantUser.level,
                size: 60,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        RouteMap.profileShowPage,
                        arguments: (widget.applicantUser.userId, false),
                      ),
                      child: Text(
                        widget.applicantUser.nickname,
                        style: const TextStyle(
                          color: Color(0xFF2C2C2C),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          "Bio: ",
                          style: TextStyle(
                            color: Color(0xFF4B4B4B),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "User biography here...",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.applicantUser.appliedTime.year}-${widget.applicantUser.appliedTime.month.toString().padLeft(2, '0')}-${widget.applicantUser.appliedTime.day.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (approve || reject) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: approve
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE53935),
                  ),
                  child: Text(
                    approve ? "Approved" : "Rejected",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ] else if (isLoading) ...[
                Container(
                  width: 140.0,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Processing...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                _ActionButton(
                  onTap: approveProcess,
                  text: "Approve",
                  color: const Color(0xff478BA2),
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  onTap: rejectProcess,
                  text: "Reject",
                  color: const Color(0xff7F7E7E),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;

  const _ActionButton({
    required this.onTap,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80.0,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
