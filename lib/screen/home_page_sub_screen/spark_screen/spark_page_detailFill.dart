import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_step_forALL/spark_page_necessary_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_step_forALL/spark_page_lastPreview_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_sport_templete.dart';
import 'package:spark_up/common_widget/profile_Textfield.dart';
import 'package:spark_up/common_widget/profile_DatePicker.dart';
import 'package:spark_up/common_widget/profile_DropDown.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_study_templete.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class NextPage extends StatefulWidget {
  final String selectedEventType;

  const NextPage({Key? key, required this.selectedEventType}) : super(key: key);

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int _currentStep = 0;
  late List<Step> steps;
  BasePost basePost = BasePost.initfromDefaule(Network.manager.userId!);
  late double _screenSize;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    basePost.type = widget.selectedEventType;
    basePost.numberOfPeopleRequired = 4;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size.width;
    steps = getSteps(widget.selectedEventType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Event: ${widget.selectedEventType}'),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Color(0xFFE9765B),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: null,
                onStepCancel: null,
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Container();
                },
                steps: steps,
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

//建立活動流程的主幹，之後10種templete要導到10種可能
List<Step> getSteps(String eventType) {
  List<Step> steps = [];

  steps.addAll(createBaseInfoStep(_currentStep, basePost, _screenSize, context, setState)); // 所以人都需要的基本第一頁

  switch (eventType) { 
    case 'Sport'://運動標籤就加運動的templete
      steps.addAll(createSportSteps(_currentStep, basePost,setState));
      break;
    case 'Study'://讀書標籤就加讀書的templete
      steps.addAll(createStudySteps(_currentStep, basePost,setState));
      break;
    default:
      steps.add(_buildDefaultStep());
      break;
  }

  steps.add(previewStep(basePost));

  // Modify step states to show checkmark icon on completed steps
  for (int i = 0; i < steps.length; i++) {
    steps[i] = Step(
      title: steps[i].title,
      content: steps[i].content,
      isActive: _currentStep >= i,
      state: _currentStep > i ? StepState.complete : StepState.indexed,
    );
  }

  return steps;
}

  Widget _buildNavigationButtons() { //導航用的按鈕
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        ElevatedButton(
          onPressed: _currentStep > 0 ? _goToPreviousStep : null,
          child: Text('上一步'),
        ),
        ElevatedButton(
          onPressed: () {
            print('userId: ${basePost.userId}');
            print('type: ${basePost.type}');
            print('title: ${basePost.title}');
            print('content: ${basePost.content}');
            print('eventStartDate: ${basePost.eventStartDate}');
            print('eventEndDate: ${basePost.eventEndDate}');
            print('numberOfPeopleRequired: ${basePost.numberOfPeopleRequired}');
            print('location: ${basePost.location}');
            print('attributes: ${basePost.attributes}');
            print('postId: ${basePost.postId}');
            print('posterNickname: ${basePost.posterNickname}');
            print('likes: ${basePost.likes}');
            print('liked: ${basePost.liked}');
            print('bookmarks: ${basePost.bookmarks}');
            print('bookmarked: ${basePost.bookmarked}');
            print('comments: ${basePost.comments}');
            print('applicants: ${basePost.applicants}');
          },
          child: Text('testing'),
        ),
          ElevatedButton(
            onPressed: _currentStep < steps.length - 1 ? _goToNextStep : null,
            child: Text('下一步'),
          ),
        ],
      ),
    );
  }

  void _goToPreviousStep() {//導航用的邏輯
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
        steps = getSteps(widget.selectedEventType);
      });
    }
  }

  void _goToNextStep() {
    final validationResult = _validateCurrentStep();
    if (validationResult == null) {
      setState(() {
        _currentStep += 1;
        steps = getSteps(widget.selectedEventType);
      });
    } else {
      _showValidationError(validationResult);
    }
  }

  String? _validateCurrentStep() {
    switch (_currentStep) {
      case 0: 
        if (basePost.title.isEmpty) {
          return 'Please fill necessary data : Title';
        } else if (basePost.content.isEmpty) {
          return 'Please fill necessary data : Content';
        } else if (basePost.location.isEmpty) {
          return 'Please fill necessary data : Location';
        }
        return null; 
      case 1:
        if (basePost.eventStartDate.isAfter(basePost.eventEndDate)) {
          return 'End time can not eariler than Start time';
        } 
        return null; 
      default:
        return null;
    }
  }
  void _showValidationError(String? message) {
    ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: message,
    );
  }
  Step _buildDefaultStep() {
    return Step(
      title: const SizedBox.shrink(),
      content: Column(
        children: [
          
        ],
      ),
      isActive: _currentStep >= 2,
    );
  }
  
  void createEvent() async {
    if (basePost.type.isEmpty ||
        basePost.title.isEmpty ||
        basePost.content.isEmpty ||
        basePost.location.isEmpty) {
      ToastService.showErrorToast(
        context,
        length: ToastLength.medium,
        expandedHeight: 100,
        message: "Please fill in all required fields.",
      );
      return;
    } else if (basePost.numberOfPeopleRequired.isNegative ||
        basePost.numberOfPeopleRequired == 0) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message:
              "Please fill the correct interger of number of people requried.");
      return;
    } else if (basePost.eventStartDate.isAfter(basePost.eventEndDate)) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Event start time most before Event end time");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await Network.manager.sendRequest(
        method: RequestMethod.post,
        path: PostPath.create,
        data: basePost.toMap);

    setState(() {
      isLoading = false;
    });

    if (response["status"] == "success" && context.mounted) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Event Create Successful");
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (context) => SystemMessage(
              content:
                  "Event Create Failed (Error: ${response["data"]["message"]})"));
    }
  }
}