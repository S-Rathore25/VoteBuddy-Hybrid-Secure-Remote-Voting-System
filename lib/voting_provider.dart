import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoterData {
  final String epicId;
  final String name;
  final int age;
  final String constituency;

  VoterData({required this.epicId, required this.name, required this.age, required this.constituency});
}

class VotingProvider extends ChangeNotifier {
  VoterData? _voterData;
  String? _currentLocation;
  bool _hasVoted = false;
  String? _confirmationId;

  VoterData? get voterData => _voterData;
  String? get currentLocation => _currentLocation;
  bool get hasVoted => _hasVoted;
  String? get confirmationId => _confirmationId;

  VotingProvider() {
    _loadVotingStatus();
  }

  Future<void> _loadVotingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasVoted = prefs.getBool('hasVoted') ?? false;
    _confirmationId = prefs.getString('confirmationId');
    notifyListeners();
  }

  Future<void> fetchVoterData(String epicId) async {
    // Mock fetching data
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate database
    if (epicId == "LOCAL123") {
      _voterData = VoterData(epicId: epicId, name: "Rahul Sharma", age: 34, constituency: "Delhi");
    } else if (epicId == "REMOTE123") {
      _voterData = VoterData(epicId: epicId, name: "Priya Singh", age: 25, constituency: "Mumbai");
    } else if (epicId == "UNDERAGE") {
      _voterData = VoterData(epicId: epicId, name: "Aman Verma", age: 17, constituency: "Delhi");
    } else {
      _voterData = VoterData(epicId: epicId, name: "Unknown User", age: 40, constituency: "Delhi");
    }
    notifyListeners();
  }

  Future<void> fetchLocation() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock current location. In a real app, use geolocator.
    // For testing, we hardcode to 'Delhi'. 
    _currentLocation = "Delhi";
    notifyListeners();
  }

  bool get isEligible => _voterData != null && _voterData!.age >= 18;

  bool get isLocalVoter => _voterData != null && _currentLocation == _voterData!.constituency;

  Future<void> submitVote() async {
    await Future.delayed(const Duration(seconds: 2));
    _hasVoted = true;
    _confirmationId = "VOTE-${DateTime.now().millisecondsSinceEpoch}";
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasVoted', true);
    await prefs.setString('confirmationId', _confirmationId!);
    
    notifyListeners();
  }
  
  Future<void> resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _hasVoted = false;
    _confirmationId = null;
    _voterData = null;
    _currentLocation = null;
    notifyListeners();
  }
}
