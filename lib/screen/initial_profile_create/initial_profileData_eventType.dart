import 'package:flutter/material.dart';

class EventTypeProfilePage extends StatefulWidget {
  const EventTypeProfilePage({super.key});

  @override
  State<EventTypeProfilePage> createState() => _EventTypeProfilePageState();
}

class _EventTypeProfilePageState extends State<EventTypeProfilePage> {
  List<String> _selectedItems = [];

  Widget eventTypeContainer(String eventName, String imagePath) {
    bool isSelected = _selectedItems.contains(eventName);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedItems.remove(eventName);
          } else {
            _selectedItems.add(eventName);
          }
        });
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack( //在當前的Container中，再疊一層用來顯示選擇與否的顯示法
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected? Colors.white.withOpacity(0.8): Colors.black.withOpacity(0.3),
              ),
            ),
            Align(//對其當前Container的底部中央
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  eventName,
                  style: TextStyle(
                    fontFamily: 'IowanOldStyle',
                    color: isSelected ? Color(0xFFF16743) : Colors.white,
                    fontSize: eventName.length>= 8 ? 18:24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Color(0xFFF16743),
                size: 80,
              ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF16743), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea( //會自動偵測，避免超過看的到的地方
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 30),
              const Center(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose the type you are interested in",
                      style: TextStyle(
                        fontFamily: 'IowanOldStyle',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "(Select one or more topics)",
                      style: TextStyle(
                        fontFamily: 'IowanOldStyle',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    eventTypeContainer("Competition", 'assets/event/competition.jpg'),
                    const SizedBox(height: 20),
                    eventTypeContainer("Roommate", 'assets/event/roommates.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    eventTypeContainer("Sport", 'assets/event/sports.jpg'),
                    const SizedBox(height: 20),
                    eventTypeContainer("Study", 'assets/event/study.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    eventTypeContainer("Social", 'assets/event/social.jpg'),
                    const SizedBox(height: 20),
                    eventTypeContainer("Travel", 'assets/event/travel.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    eventTypeContainer("Meal", 'assets/event/meal.jpg'),
                    const SizedBox(height: 20),
                    eventTypeContainer("Speech", 'assets/event/speech.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    eventTypeContainer("Parade", 'assets/event/parade.jpg'),
                    const SizedBox(height: 20),
                    eventTypeContainer("Exhibition", 'assets/event/exhibition.jpg'),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Center(
                  child: SizedBox(
                    width: 220,
                    height: 47,
                    child: ElevatedButton(
                      onPressed: () => _navigateToNextProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF16743),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'IowanOldStyle',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  void _navigateToNextProfile(){
     //Todo : 彥廷幫幫我儲存，List<String> 的資料
    _selectedItems.forEach((item) {
      debugPrint('Item: $item');
    });
  }
}
