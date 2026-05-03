import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLang = 'en'; // 'en' for English, 'hi' for Hindi

  String get currentLang => _currentLang;

  void toggleLanguage() {
    _currentLang = _currentLang == 'en' ? 'hi' : 'en';
    notifyListeners();
  }

  String translate(String key) {
    if (_currentLang == 'en') {
      return _en[key] ?? key;
    } else {
      return _hi[key] ?? key;
    }
  }

  // English Strings
  static const Map<String, String> _en = {
    'welcome_title': 'Welcome to VoteBuddy',
    'welcome_subtitle': 'Secure Remote Voting System',
    'enter_epic': 'Enter EPIC / Voter ID',
    'hint_epic': 'e.g. LOCAL123 or REMOTE123',
    'verify_id': 'VERIFY ID',
    'please_enter_id': 'Please enter an ID',
    'eligibility_check': 'Eligibility Check',
    'name': 'Name: ',
    'age': 'Age: ',
    'constituency': 'Constituency: ',
    'not_eligible': 'Not Eligible to Vote',
    'age_restriction': 'You must be 18 or older to vote.',
    'back': 'BACK',
    'eligible': 'Eligible to Vote',
    'verify_loc': 'VERIFY LOCATION',
    'voting_mode': 'Voting Mode',
    'your_loc': 'Your Location: ',
    'local_mode': 'LOCAL VOTING MODE',
    'remote_mode': 'REMOTE VOTING MODE',
    'local_msg': 'You are in your home constituency. Please proceed to your local booth.',
    'remote_msg': 'You are outside your constituency. Please proceed via AVN (Authorized Verification Node).',
    'continue': 'CONTINUE',
    'local_voting': 'Local Voting',
    'remote_voting': 'Remote Voting',
    'visit_local': 'Visit Local Booth',
    'visit_remote': 'Visit AVN Center',
    'local_steps': '1. Go to your designated polling booth.\n2. Show your ID to the officer.\n3. Proceed to the voting machine.',
    'remote_steps': '1. Book a slot at nearest AVN.\n2. Visit the AVN on your time.\n3. Complete biometric multi-level verification.',
    'start_verify': 'START VERIFICATION',
    'proceed_avn': 'PROCEED TO AVN VERIFICATION',
    'verification': 'Verification',
    'basic_id': 'Basic ID Check',
    'bio_scan': 'Biometric Fingerprint Scan',
    'verify': 'VERIFY',
    'voter_match': 'Voter List Match',
    'face_check': 'Face Liveness Check',
    'completing': 'Completing Verification...',
    'cast_vote': 'Cast Your Vote',
    'select_symbol': 'Select a symbol to vote:',
    'submit_vote': 'SUBMIT VOTE',
    'vote_success': 'Vote Submitted Successfully!',
    'vote_enc': 'Your vote is securely encrypted and stored.\nOne Person = One Vote',
    'conf_id': 'CONFIRMATION ID',
    'back_home': 'BACK TO HOME',
    'language': 'Language',
  };

  // Hindi Strings
  static const Map<String, String> _hi = {
    'welcome_title': 'वोटबडी में आपका स्वागत है',
    'welcome_subtitle': 'सुरक्षित रिमोट वोटिंग सिस्टम',
    'enter_epic': 'EPIC / वोटर आईडी दर्ज करें',
    'hint_epic': 'उदा. LOCAL123 या REMOTE123',
    'verify_id': 'आईडी सत्यापित करें',
    'please_enter_id': 'कृपया एक आईडी दर्ज करें',
    'eligibility_check': 'पात्रता जांच',
    'name': 'नाम: ',
    'age': 'आयु: ',
    'constituency': 'निर्वाचन क्षेत्र: ',
    'not_eligible': 'वोट देने के योग्य नहीं',
    'age_restriction': 'वोट देने के लिए आपकी आयु 18 या अधिक होनी चाहिए।',
    'back': 'वापस',
    'eligible': 'वोट देने के योग्य',
    'verify_loc': 'स्थान सत्यापित करें',
    'voting_mode': 'वोटिंग मोड',
    'your_loc': 'आपका स्थान: ',
    'local_mode': 'लोकल वोटिंग मोड',
    'remote_mode': 'रिमोट वोटिंग मोड',
    'local_msg': 'आप अपने गृह निर्वाचन क्षेत्र में हैं। कृपया अपने स्थानीय बूथ पर जाएं।',
    'remote_msg': 'आप अपने निर्वाचन क्षेत्र के बाहर हैं। कृपया AVN के माध्यम से आगे बढ़ें।',
    'continue': 'जारी रखें',
    'local_voting': 'स्थानीय वोटिंग',
    'remote_voting': 'रिमोट वोटिंग',
    'visit_local': 'स्थानीय बूथ पर जाएं',
    'visit_remote': 'AVN केंद्र पर जाएं',
    'local_steps': '1. अपने निर्धारित मतदान बूथ पर जाएं।\n2. अधिकारी को अपनी आईडी दिखाएं।\n3. वोटिंग मशीन की ओर बढ़ें।',
    'remote_steps': '1. निकटतम AVN पर स्लॉट बुक करें।\n2. अपने समय पर AVN पर जाएं।\n3. बायोमेट्रिक सत्यापन पूरा करें।',
    'start_verify': 'सत्यापन शुरू करें',
    'proceed_avn': 'AVN सत्यापन के लिए आगे बढ़ें',
    'verification': 'सत्यापन',
    'basic_id': 'बेसिक आईडी चेक',
    'bio_scan': 'बायोमेट्रिक फिंगरप्रिंट स्कैन',
    'verify': 'सत्यापित करें',
    'voter_match': 'मतदाता सूची मिलान',
    'face_check': 'फेस लाइवनेस चेक',
    'completing': 'सत्यापन पूरा हो रहा है...',
    'cast_vote': 'अपना वोट दें',
    'select_symbol': 'वोट देने के लिए एक प्रतीक चुनें:',
    'submit_vote': 'वोट जमा करें',
    'vote_success': 'वोट सफलतापूर्वक जमा किया गया!',
    'vote_enc': 'आपका वोट सुरक्षित रूप से एन्क्रिप्टेड है।\nएक व्यक्ति = एक वोट',
    'conf_id': 'पुष्टिकरण आईडी',
    'back_home': 'वापस होम पर',
    'language': 'भाषा',
  };
}
