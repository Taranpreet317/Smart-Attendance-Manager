import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Sessionqrdialog extends StatefulWidget {
  final Map<String, dynamic> sessionData;
  final String qrData;
  final String className;

  const Sessionqrdialog({
    Key? key,
    required this.sessionData,
    required this.qrData,
    required this.className,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SessionqrdialogState();
}

class SessionqrdialogState extends State<Sessionqrdialog> {
  late DateTime expiryTime;
  late Duration remainingTime;

  @override
  void initState() {
    super.initState();
    expiryTime = DateTime.parse(widget.sessionData['expiresAt']);
    _updateRemainingTime();
  }

  void _updateRemainingTime() {
    setState(() {
      remainingTime = expiryTime.difference(DateTime.now());
    });

    if (remainingTime.inSeconds > 0) {
      Future.delayed(Duration(seconds: 1), _updateRemainingTime);
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds <= 0) return "Expired";
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return "${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    bool isExpired = remainingTime.inSeconds <= 0;
    return AlertDialog(
      title: Column(
        children: [
          Text(
            "QR for ${widget.className}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isExpired ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isExpired
                  ? "Session Expired"
                  : "Active: ${_formatDuration(remainingTime)}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        height: 280,
        width: 280,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 100),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Students can scan this QR to mark attendance",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}
