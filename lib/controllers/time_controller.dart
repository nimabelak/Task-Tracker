import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopwatchController extends GetxController {
  final _isRunning = false.obs;
  final _elapsedTime = 0.obs;
  final _savedTimes = <String>[].obs;
  final _savedDates = <String>[].obs;

  Timer? _timer;

  bool get isRunning => _isRunning.value;
  List<String> get savedTimes => _savedTimes;
  List<String> get savedDates => _savedDates;

  void startStop() {
    getCurrentDate();
    _isRunning.value = !_isRunning.value;
    if (_isRunning.value) {
      print("TIMER STARTED");
      _startTimer();
    } else {
      print("TIMER STOPPED");
      _timer?.cancel(); // Stop the timer
    }
  }

  void saveTime() {
    if (!_isRunning.value && _elapsedTime.value > 0) {
      String formattedTime = _formatTime(_elapsedTime.value);
      String currentDate = getCurrentDate();
      _savedTimes.add(formattedTime);
      _savedDates.add(currentDate);
      saveTimesToLocalStorage();
    }
  }

  void reset() {
    _isRunning.value = false;
    _timer?.cancel(); // Stop the timer
    _elapsedTime.value = 0;
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String get displayTime => _formatTime(_elapsedTime.value);

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_isRunning.value) {
        _elapsedTime.value++;
      } else {
        _timer?.cancel();
      }
    });
  }

  String getCurrentDate() {
    Jalali jNow = Jalali.now();
    String formattedDate = "${jNow.year}/${jNow.month}/${jNow.day}";
    return formattedDate;
  }

  void removeDate(int index) {
    _savedTimes.removeAt(index);
    saveTimesToLocalStorage();
  }

  void loadSavedTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? times = prefs.getStringList('savedTimes');
    final List<String>? dates = prefs.getStringList('savedDates');
    final int? elapsedTime = prefs.getInt('elapsedTime');

    if (times != null && dates != null) {
      _savedTimes.assignAll(times);
      _savedDates.assignAll(dates);
    }

    if (elapsedTime != null) {
      _elapsedTime.value = elapsedTime; // Restore elapsed time
    }

    print("Loaded saved times: $_savedTimes");
    print("Loaded elapsed time: $_elapsedTime");
  }

  void saveTimesToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedTimes', _savedTimes.toList());
    await prefs.setStringList('savedDates', _savedDates.toList());
    await prefs.setInt('elapsedTime', _elapsedTime.value);
    print("Saved times: ${_savedTimes.toList()}");
    print("Saved dates: ${_savedDates.toList()}");
    print("Saved elapsed time: ${_elapsedTime.value}");
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
