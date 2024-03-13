import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int topScore;
  HomePage({
    super.key,
    required this.topScore,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<String>> displayElements = [
    ["", "", ""],
    ["", "", ""],
    ["", "", ""],
  ];
  bool hasEmptyCell = true;
  bool ignoring = false;
  bool isXTurn = true;
  int xScore = 0;
  int oScore = 0;
  int filledBoxes = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: [
                          const Text(
                            "Player X",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            xScore.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Player O",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            oScore.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30)),
                height: 353,
                width: 353,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return IgnorePointer(
                      ignoring: ignoring,
                      child: GestureDetector(
                        onTap: () {
                          _tapped(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Text(
                              displayElements[index ~/ 3][index % 3],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (displayElements[index ~/ 3][index % 3] == "") {
        filledBoxes++;
        displayElements[index ~/ 3][index % 3] = isXTurn ? "X" : "O";
        isXTurn = !isXTurn;
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    for (var row in displayElements) {
      for (var element in row) {
        if (element == '') {
          hasEmptyCell = true;
          break;
        } else {
          hasEmptyCell = false;
        }
      }
      if (hasEmptyCell) {
        break;
      }
    }

    if (hasEmptyCell == false) {
      _resetIfOver();
    }

    for (var row in displayElements) {
      if (row.every((cell) => cell == "X")) {
        xScore++;
        ignoring = true;
        _resetIfOver();
      }

      if (row.every((cell) => cell == "O")) {
        oScore++;
        ignoring = true;
        _resetIfOver();
      }
    }

    for (int col = 0; col < displayElements[0].length; col++) {
      if (displayElements.every((row) => row[col] == "X")) {
        xScore++;
        ignoring = true;
        _resetIfOver();
      }

      if (displayElements.every((row) => row[col] == "O")) {
        oScore++;
        ignoring = true;
        _resetIfOver();
      }
    }

    if (displayElements[2][0] == "X" &&
        displayElements[1][1] == "X" &&
        displayElements[0][2] == "X") {
      xScore++;
      ignoring = true;
      _resetIfOver();
    }

    if (displayElements[0][0] == "X" &&
        displayElements[1][1] == "X" &&
        displayElements[2][2] == "X") {
      xScore++;
      ignoring = true;
      _resetIfOver();
    }

    if (displayElements[2][0] == "O" &&
        displayElements[1][1] == "O" &&
        displayElements[0][2] == "O") {
      oScore++;
      ignoring = true;
      _resetIfOver();
    }

    if (displayElements[0][0] == "O" &&
        displayElements[1][1] == "O" &&
        displayElements[2][2] == "O") {
      oScore++;
      ignoring = true;
      _resetIfOver();
    }
  }

  void _resetBoard() {
    setState(() {
      displayElements = [
        ["", "", ""],
        ["", "", ""],
        ["", "", ""],
      ];
      filledBoxes = 0;
      isXTurn = true;
      xScore = 0;
      oScore = 0;
      ignoring = false;
    });
  }

  void _resetIfOver() async {
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          displayElements = [
            ["", "", ""],
            ["", "", ""],
            ["", "", ""],
          ];
          ignoring = false;
        });
        if (xScore == widget.topScore || oScore == widget.topScore) {
          xScore = 0;
          oScore = 0;
          _winDialog();
        }
      },
    );
  }

  void _winDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              alignment: Alignment.center,
              height: 300,
              child: isXTurn
                  ? const Text('Player O wins')
                  : const Text('Player X wins'),
            ),
          );
        });
  }
}
