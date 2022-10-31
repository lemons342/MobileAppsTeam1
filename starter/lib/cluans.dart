// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class Clue {
  String? answer;
  String? clue;
  String? date;
  String? picture;
  Clue({this.answer, this.clue, this.date, this.picture});
}

class CluansWidget extends StatefulWidget {
  CluansWidget({Key? key}) : super(key: key);

  @override
  State<CluansWidget> createState() => _CluansWidgetState();
}

class _CluansWidgetState extends State<CluansWidget> {
  List<Clue> cluans = [
    Clue(answer: 'LETHARGIC', clue: 'Sleepy', date: '2022-10-08', picture: 'pic'),
    Clue(answer: 'PETAL', clue: 'Flower part', date: '2022-10-08', picture: 'pic'),
    Clue(answer: 'GO', clue: 'Monopoly starting space', date: '2022-10-08', picture: 'pic'),
    Clue(answer: 'CYGNET', clue: 'Young swan', date: '2022-10-08', picture: 'pic'),
    Clue(answer: 'TAC', clue: 'Tic-___-toe', date: '2022-10-08', picture: 'pic'),
    Clue(answer: 'ODORS', clue: 'Smells', date: '2022-10-08', picture: 'pic'),
  ];

  /**
   * Called when 'Sort by Answer' button is pressed
   */
  void sortByAnswer() {
    setState(() {
      //cluans.sort((a, b) => a.answer.compareTo(b.answer));
    });
  }
  /**
   * Called when 'Sort by Clue' button is pressed
   */
  void sortByClue() {
    setState(() {
      //cluans.sort((a, b) => a.clue.compareTo(b.clue));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListView.separated(
          shrinkWrap: true,
          itemCount: cluans.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(cluans[index].answer!),
                subtitle: Text(cluans[index].clue!),
                trailing: Text(cluans[index].date!),
                leading: Text(cluans[index].picture!),);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.lightBlue,
              thickness: 1,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              onPressed: () {
                sortByAnswer();
              },
              child: Text('Sort by Clue'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              onPressed: () {
                sortByClue();
              },
              child: Text('Sort by Answer'),
            ),
          ],
        ),
      ],
    );
  }
}
