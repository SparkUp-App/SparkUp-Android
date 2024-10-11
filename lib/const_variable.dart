//Using these infomation in Profile
List<String> genderList = Gender.values.map((element)=>element.label).toList();
const List<String> educationLevelList = ['No Formal Education','Primary School','Secondary School','Undergraduate','Postgraduate','PhD','Prefer not to say'];
const List<String> mbtiList = ['INTJ', 'INTP', 'ENTJ', 'ENTP', 'INFJ', 'INFP', 'ENFJ', 'ENFP', 'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ', 'ISTP', 'ISFP', 'ESTP', 'ESFP', 'Prefer not to say'];
const List<String> constellationList = ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces', 'Prefer not to say'];
const List<String> bloodTypeList = ['A','B','AB','O','Other','Prefer not to say'];
const List<String> religionList = ['Agnostic', 'Atheist', 'Buddhist', 'Catholic', 'Christian', 'Hindu', 'Jewish', 'Muslim', 'Sikh', 'Spiritual', 'Orthodox Christian', 'Protestant', 'Shinto', 'Taoist', 'Other', 'Prefer not to say'];
const List<String> sexualityList = ['Straight', 'Gay', 'Lesbian', 'Bisexual','Asexual', 'Pansexual', 'Queer', 'Questioning', 'Not listed', 'Prefer not to say'];
const List<String> ethnicityList = ['Black/African Descent', 'East Asian', 'South Asian', 'Southeast Asian', 'Hispanic/Latino', 'Middle Eastern/North African', 'Native American/Indigenous', 'Pacific Islander','White/Caucasian', 'Multiracial', 'Other', 'Prefer not to say'];
const List<String> dietList = ['Omnivore', 'Vegetarian', 'Vegan', 'Pescatarian', 'Ketogenic', 'Paleo','Other', 'Prefer not to say'];
const List<String> eventType = ['Competiton', 'Roommate', 'Sport', 'Study', 'Social', 'Travel', 'Meal','Speech','Parade', 'Exhibition'];
List<String> smokeList = Smoke.values.map((element)=>element.label).toList();
List<String> drinkingList = Drinking.values.map((element) => element.label).toList();
List<String> marijuanaList = Marijuana.values.map((element)=>element.label).toList();
List<String> drugsList = Drugs.values.map((element) => element.label).toList();

//Phone Number Checker 10 ~ 15 Digits
RegExp phoneRegex = RegExp(r'^\d{10,15}$');


enum Gender{
    male(label: "Male", value: 0),
    female(label: "Female", value: 1),
    nonBinary(label: "Non-Binary", value: 2),
    notToSay(label: "Prefer not to say", value: 3);

    final String label;
    final int value;

    const Gender({this.label = "Prefer not to say", this.value = 3});

    factory Gender.fromString(String label){
        return Gender.values.firstWhere((element) => element.label == label, orElse: ()=>Gender.notToSay);
    }

    factory Gender.fromint(int? value){
        return Gender.values.firstWhere((element) => element.value == value, orElse: ()=>Gender.notToSay);
    }
}


enum Smoke{
    no(label: "No", value: 0),
    yes(label: "Yes", value: 1),
    occasionally(label: "Occasionally", value: 2),
    notToSay(label: "Prefer not to say", value: 3);

    final String label;
    final int value;

    const Smoke({this.label = "Prefer not to say", this.value = 3});

    factory Smoke.fromString(String label){
        return Smoke.values.firstWhere((element) => element.label == label, orElse: ()=>Smoke.notToSay);
    }

    factory Smoke.fromint(int? value){
        return Smoke.values.firstWhere((element) => element.value == value, orElse: ()=>Smoke.notToSay);
    }
}

enum Drinking{
    no(label: "No", value: 0),
    yes(label: "Yes", value: 1),
    occasionally(label: "Occasionally", value: 2),
    notToSay(label: "Prefer not to say", value: 3);

    final String label;
    final int value;

    const Drinking({this.label = "Prefer not to say", this.value = 3});

    factory Drinking.fromString(String label){
        return Drinking.values.firstWhere((element) => element.label == label, orElse: ()=>Drinking.notToSay);
    }

    factory Drinking.fromint(int? value){
        return Drinking.values.firstWhere((element) => element.value == value, orElse: ()=>Drinking.notToSay);
    }
}

enum Marijuana{
    no(label: "No", value: 0),
    yes(label: "Yes", value: 1),
    occasionally(label: "Occasionally", value: 2),
    notToSay(label: "Prefer not to say", value: 3);

    final String label;
    final int value;

    const Marijuana({this.label = "Prefer not to say", this.value = 3});

    factory Marijuana.fromString(String label){
        return Marijuana.values.firstWhere((element) => element.label == label, orElse: ()=>Marijuana.notToSay);
    }

    factory Marijuana.fromint(int? value){
        return Marijuana.values.firstWhere((element) => element.value == value, orElse: ()=>Marijuana.notToSay);
    }
}

enum Drugs{
    no(label: "No", value: 0),
    yes(label: "Yes", value: 1),
    occasionally(label: "Occasionally", value: 2),
    notToSay(label: "Prefer not to say", value: 3);

    final String label;
    final int value;

    const Drugs({this.label = "Prefer not to say", this.value = 3});

    factory Drugs.fromString(String label){
        return Drugs.values.firstWhere((element) => element.label == label, orElse: ()=>Drugs.notToSay);
    }

    factory Drugs.fromint(int? value){
        return Drugs.values.firstWhere((element) => element.value == value, orElse: ()=>Drugs.notToSay);
    }
}
