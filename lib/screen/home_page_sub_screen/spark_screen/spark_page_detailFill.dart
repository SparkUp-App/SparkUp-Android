import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/base_post.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/post_path.dart';
import 'package:spark_up/route.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_competition_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_meal_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_roommate_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_social_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_speech_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_step_forALL/spark_page_necessary_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_step_forALL/spark_page_lastPreview_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_sport_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_study_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_travel_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_parade_templete.dart';
import 'package:spark_up/screen/home_page_sub_screen/spark_screen/spark_page_eventType_step_templete/spark_page_exhibition_templete.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

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
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    basePost.type = widget.selectedEventType;
    basePost.numberOfPeopleRequired = 4;
    switch (widget.selectedEventType) { 
    case 'Sport'://運動標籤就加運動的templete
     basePost.attributes["Sports Rule"] ="";
      basePost.attributes["Winning Prize"]="";
      basePost.attributes["Entry Fee"] ="";
      basePost.attributes["Requirements of Participants"] ="";
      break;
    case 'Study'://讀書標籤就加讀書的templete
      basePost.attributes["Kind of study topic"]="";
      basePost.attributes["Introduce the Topic"] ="";
      basePost.attributes["Participation Guidelines"]="";
      basePost.attributes["Entry Fee"] ="";
      break;
    case 'Competition':
        basePost.attributes["Rules"] = "";
        basePost.attributes["Requirements of Participants"] = "";
        basePost.attributes["Entry Fee"] = "";
        basePost.attributes["Prize"] = <String>[];
      break;
    case 'Roommate':
      basePost.attributes["Type"]="";
      basePost.attributes["Address"]="";
      basePost.attributes["Furniture and Equipment"] = <String>[];
      basePost.attributes["Amenities"] = <String>[];
      basePost.attributes["Gender"]="";
      basePost.attributes["Personality"]="";
      basePost.attributes["lifestyle"]="";
      basePost.attributes["Your contact information"]="";
      basePost.attributes["Move-in date"]="";
      basePost.attributes["Security deposit"]="";
      basePost.attributes["Rent(monthly)"]="";
      basePost.attributes["MISC"] = <String,String>{};
      break;
    case 'Social':
      basePost.attributes["Your activity"]="";
      basePost.attributes["Activity Schedule"] =<String,String>{};
      basePost.attributes["Requirements for Participants"]="";
      basePost.attributes["Entry fee"] ="";
      break;
    case 'Meal':
      basePost.attributes["Restaurant name"] = "";
      basePost.attributes["Signature dishes"] = "";
      basePost.attributes["Link of the restaurant"]= "";
      basePost.attributes["Intro of the restaurant"]="";  
      basePost.attributes["Participation guidelines"] ="";
      basePost.attributes["Price"]="";
      break;
    case 'Speech':
      basePost.attributes["Topic"]="";
      basePost.attributes["Speaker"]="";
      basePost.attributes["Introduce the Topic"]="";
      basePost.attributes["Entry fee"]="";
      basePost.attributes["Requirements for Participants"]="";
      break;
    case  'Travel':
      basePost.attributes["Introduce"]="";
      basePost.attributes["Price"]="";
      basePost.attributes["Participation guidelines"]="";
      basePost.attributes["Itinerary"]=<String, List<String>>{};
      break;
    case  'Parade':
    basePost.attributes["Introduce"] ="";
    basePost.attributes["Address"] ="";
    basePost.attributes["Parade route"] =<String>[];
    basePost.attributes["Participation guidelines"]="";
      break;
    case  'Exhibition':
      basePost.attributes["Introduction"] = "";
      basePost.attributes["Ticket price"] = "";
      break;
    default:
      break;
  }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size.width;
    steps = getSteps(widget.selectedEventType);
  }
  Widget regretDialog(){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 8),
          const Text(
            'Cancel whole activity?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: const Text(
        'After exiting, the information you entered will NOT be saved',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            foregroundColor: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, RouteMap.homePage),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await showDialog(
          context: context,
          builder: (context) => regretDialog(),
        );
    }, child:Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectedEventType,
          style: const TextStyle(
            color: Colors.white, // 設定文字顏色為白色
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFE9765B),
        centerTitle: true, // 讓標題置中
        automaticallyImplyLeading: false,
      ),
      body: Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
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
            if(!isKeyboardVisible) _buildNavigationButtons(),
          ],
        ),
      ),
    )
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
    case 'Competition'://讀書標籤就加讀書的templete
      steps.addAll(createCompetitionSteps(_currentStep, basePost,setState));
      break;
    case 'Roommate':
      steps.addAll(createRoommateSteps(_currentStep, basePost,setState));
      break;
    case 'Social':
      steps.addAll(createSocialSteps(_currentStep, basePost,setState));
      break;
    case 'Meal':
      steps.addAll(createMealSteps(_currentStep, basePost,setState));
      break;
    case 'Speech':
      steps.addAll(createSpeechSteps(_currentStep, basePost,setState));
      break;
    case  'Travel':
      steps.addAll(createTravelSteps(_currentStep, basePost,setState));
      break;
    case  'Parade':
      steps.addAll(createParadeSteps(_currentStep, basePost,setState));
      break;
    case  'Exhibition':
      steps.addAll(createExhibitionSteps(_currentStep, basePost,setState));
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
void updateStepperShow(){
    for (int i = 0; i < steps.length; i++) {
    steps[i] = Step(
      title: steps[i].title,
      content: steps[i].content,
      isActive: _currentStep >= i,
      state: _currentStep > i ? StepState.complete : StepState.indexed,
    );
  }
}
  Widget _buildNavigationButtons() { //導航用的按鈕
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: isLoading?Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Processing...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ):Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 150,
            height: 47,
            child: ElevatedButton(
              onPressed: _currentStep > 0 
                ? _goToPreviousStep 
                : () => showDialog(
                    context: context,
                    builder: (context) => regretDialog(),
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentStep > 0 ? const Color(0xFFF16743) : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                _currentStep > 0 ? 'Go back':"Regret",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            height: 47,
            child: ElevatedButton(
              onPressed: _currentStep < steps.length - 1 ? _goToNextStep : createEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor:_currentStep < steps.length - 1 ?const Color(0xFFF16743):Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                _currentStep < steps.length - 1 ? 'Next' : 'Send!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToPreviousStep() { //導航用的邏輯
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
        updateStepperShow();
      });
    }
  }

  void _goToNextStep() {
    final validationResult = _validateCurrentStep();
    if (validationResult == null) {
      setState(() {
        _currentStep += 1;
        updateStepperShow();
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
        } else if (basePost.location.isEmpty) {
          return 'Please fill necessary data : Location';
        }
        if (basePost.eventStartDate.isAfter(basePost.eventEndDate)) {
          return 'End time can not eariler than Start time';
        } 
        return null; 
      case 1:
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
      content: const Column(
        children: [
          
        ],
      ),
      isActive: _currentStep >= 2,
    );
  }
  
  void createEvent() async {
    if (basePost.type.isEmpty ||
        basePost.title.isEmpty ||
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
      ToastService.showSuccessToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Event Create Successful");
      
      Navigator.pushReplacementNamed(context, RouteMap.homePage);
    } else {
      showDialog(
          context: context,
          builder: (context) => SystemMessage(
              content:
                  "Event Create Failed (Error: ${response["data"]["message"]})"));
    }
  }
}