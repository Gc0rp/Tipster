// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constraints.dart';
// import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class sectionHeading {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TIP\$TER',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          textTheme: TextTheme(
            headline2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          )),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: AppBar(
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              title: Text('TIP\$TER',
                  style: TextStyle(
                      fontSize: 25.0,
                      letterSpacing: 2.0,
                      color: kPrimaryTextColor,
                      fontWeight: FontWeight.w600)),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
            )),
        body: const Center(child: billInfo()),
      ),
    );
  }
}

class billInfo extends StatefulWidget {
  const billInfo({Key? key}) : super(key: key);

  @override
  _billInfoState createState() => _billInfoState();
}

class _billInfoState extends State<billInfo> {
  int splitNumber = 1;

  void handleTap(String tapOperation) {
    setState(() {
      if (tapOperation == "+") {
        splitNumber += 1;
      } else if (tapOperation == "-" && splitNumber > 1) {
        splitNumber -= 1;
      }
    });
  }

  double tip = 0;
  String selectedChoice = "";

  void handleTip(String tipSelected) {
    setState(() {
      switch (tipSelected) {
        case "10%":
          {
            tip = 10 / 100;
            selectedChoice = "10%";
          }
          break;
        case "15%":
          {
            tip = 15 / 100;
            selectedChoice = "15%";
          }
          break;
        case "20%":
          {
            tip = 20 / 100;
            selectedChoice = "20%";
          }
          break;
        case "25%":
          {
            tip = 25 / 100;
            selectedChoice = "25%";
          }
          break;
      }

      print("tip " + tip.toString());
    });
  }

  double bill = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.8,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height > 650 ? height * 0.1 : height * 0.03),
          TextField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9 .]'))
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                prefixText: "\$", hintText: " Enter total bill"),
            onChanged: (text) {
              setState(() {
                bill = text == "" ? 0 : double.parse(text);
                print(bill);
              });
            },
          ),
          SizedBox(height: height > 650 ? height * 0.1 : height * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose Tip", style: Theme.of(context).textTheme.headline2),
              tipOptions(
                  options: ["10%", "15%", "20%", "25%"],
                  tipSelected: handleTip,
                  selectedChoice: selectedChoice),
              SizedBox(height: height > 650 ? height * 0.1 : height * 0.03),
              Text("Split", style: Theme.of(context).textTheme.headline2),
              splitOption(
                splitNumber: splitNumber,
                onChanged: handleTap,
              )
            ],
          ),
          SizedBox(height: height > 650 ? height * 0.1 : 0),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: individualBill(
                    totalPerPerson: (bill + (bill * tip)) / splitNumber,
                    tip: (bill * tip),
                    bill: bill,
                  )))
        ],
      ),
    );
  }
}

class tipOptions extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> tipSelected;
  final String selectedChoice;

  const tipOptions(
      {Key? key,
      required this.options,
      required this.tipSelected,
      required this.selectedChoice})
      : super(key: key);

  @override
  _tipOptionsState createState() => _tipOptionsState();
}

class _tipOptionsState extends State<tipOptions> {
  String selectedChoice = "";

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      for (String element in widget.options)
        Padding(
            padding: EdgeInsets.all(8.0),
            child: ChoiceChip(
              elevation: 1.0,
              backgroundColor: Colors.white,
              label: Text(
                element,
                style: TextStyle(
                    color: (widget.selectedChoice == element)
                        ? Colors.white
                        : choiceChipDefault,
                    fontWeight: FontWeight.bold),
              ),
              selected: widget.selectedChoice == element,
              onSelected: (bool selected) {
                widget.tipSelected(element);
              },
              selectedColor: kPrimaryColor,
            ))
    ]);
  }
}

class splitOption extends StatelessWidget {
  const splitOption({Key? key, this.splitNumber = 0, required this.onChanged})
      : super(key: key);

  final int splitNumber;
  final ValueChanged<String> onChanged;

  void _handleTap(String operator) {
    onChanged(operator);
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      IconButton(onPressed: () => _handleTap("-"), icon: Icon(Icons.remove)),
      Text(splitNumber.toString()),
      IconButton(onPressed: () => _handleTap("+"), icon: Icon(Icons.add))
    ]);
  }
}

class individualBill extends StatefulWidget {
  individualBill(
      {Key? key,
      required this.totalPerPerson,
      required this.bill,
      required this.tip})
      : super(key: key);

  final double totalPerPerson;
  double bill;
  final double tip;
  @override
  _individualBillState createState() => _individualBillState();
}

class _individualBillState extends State<individualBill> {
  double billTest = 0.0;
  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Flex(
          direction: height < 500 ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: height < 500
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.03,
            ),

            Column(
              children: [
                Text("Total per person",
                    style: Theme.of(context).textTheme.headline2),
                Text("\$" + widget.totalPerPerson.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: height < 500 ? 15 : 30,
                        fontWeight: FontWeight.bold,
                        color: price)),
              ],
            ),

            // Text(widget.totalPerPerson),

            SizedBox(
              height: height * 0.01,
            ),
            Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: [
                          Text("bill",
                              style: Theme.of(context).textTheme.headline2),
                          Text("\$ " + widget.bill.toStringAsFixed(2))
                        ],
                      )),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: [
                          Text("tip",
                              style: Theme.of(context).textTheme.headline2),
                          Text("\$ " + widget.tip.toStringAsFixed(2)),
                        ],
                      ))
                ])
          ],
        ));
  }
}
