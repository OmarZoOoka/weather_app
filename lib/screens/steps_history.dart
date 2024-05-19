import 'package:flutter/material.dart';

class StepHistoryScreen extends StatefulWidget {
  final List<int> stepHistory;
  final Function(int) onDelete;

  const StepHistoryScreen(
      {Key? key, required this.stepHistory, required this.onDelete})
      : super(key: key);

  @override
  _StepHistoryScreenState createState() => _StepHistoryScreenState();
}

class _StepHistoryScreenState extends State<StepHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Step History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.stepHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              'Steps:                   ${widget.stepHistory[index]}',
              style: TextStyle(fontSize: 20),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onDelete(index);
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
