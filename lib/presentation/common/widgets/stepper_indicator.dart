library steps_indicator;

import 'package:flutter/material.dart';

class StepsIndicatorCustom extends StatelessWidget {
  final int selectedStep;
  final int nbSteps;
  final Color selectedStepColorOut;
  final Color selectedStepColorIn;
  final Color doneStepColor;

  //Step colors for unselected in and out
  final Color unselectedStepColorOut;
  final Color unselectedStepColorIn;
  final Color doneLineColor;
  final Color undoneLineColor;
  final bool isHorizontal;
  final double lineLength;

  //Line thickness for done and Undone
  final double doneLineThickness;
  final double undoneLineThickness;
  final double doneStepSize;
  final double unselectedStepSize;
  final double selectedStepSize;
  final double selectedStepBorderSize;

  //Border size for unselectedStep
  final double unselectedStepBorderSize;
  final Widget? doneStepWidget;
  final Widget? unselectedStepWidget;
  final Widget? selectedStepWidget;
  final List<StepsIndicatorCustomLine>? lineLengthCustomStep;

  const StepsIndicatorCustom({
    this.selectedStep = 0,
    this.nbSteps = 4,
    this.selectedStepColorOut = Colors.blue,
    this.selectedStepColorIn = Colors.white,
    this.doneStepColor = Colors.blue,
    this.unselectedStepColorOut = Colors.blue,
    this.unselectedStepColorIn = Colors.blue,
    this.doneLineColor = Colors.blue,
    this.undoneLineColor = Colors.blue,
    this.isHorizontal = true,
    this.lineLength = 20,
    this.doneLineThickness = 2,
    this.undoneLineThickness = 2,
    this.doneStepSize = 10,
    this.unselectedStepSize = 10,
    this.selectedStepSize = 14,
    this.selectedStepBorderSize = 1,
    this.unselectedStepBorderSize = 1,
    this.doneStepWidget,
    this.unselectedStepWidget,
    this.selectedStepWidget,
    this.lineLengthCustomStep,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      // Display in Row
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < nbSteps; i++) stepBuilder(i),
        ],
      );
    } else {
      // Display in Column
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < nbSteps; i++) stepBuilder(i),
        ],
      );
    }
  }

  Widget stepBuilder(int i) {
    if (isHorizontal) {
      // Display in Row
      return (selectedStep == i
          ? Row(
              children: <Widget>[
                stepSelectedWidget(i + 1),
                selectedStep == nbSteps ? stepLineDoneWidget(i) : Container(),
                i != nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
              ],
            )
          : selectedStep > i
              ? Row(
                  children: <Widget>[
                    stepDoneWidget(),
                    i < nbSteps - 1 ? stepLineDoneWidget(i) : Container(),
                  ],
                )
              : Row(
                  children: <Widget>[
                    stepUnselectedWidget(i + 1),
                    i != nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
                  ],
                ));
    } else {
      // Display in Column
      return (selectedStep == i
          ? Column(
              children: <Widget>[
                stepSelectedWidget(i + 1),
                selectedStep == nbSteps ? stepLineDoneWidget(i) : Container(),
                i != nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
              ],
            )
          : selectedStep > i
              ? Column(
                  children: <Widget>[
                    stepDoneWidget(),
                    i < nbSteps - 1 ? stepLineDoneWidget(i) : Container(),
                  ],
                )
              : Column(
                  children: <Widget>[
                    stepUnselectedWidget(i + 1),
                    i != nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
                  ],
                ));
    }
  }

  Widget stepSelectedWidget(currentSelectedStepNumber) {
    return selectedStepWidget != null
        ? selectedStepWidget!
        : ClipRRect(
            borderRadius: BorderRadius.circular(selectedStepSize),
            child: Container(
              decoration: BoxDecoration(
                  color: selectedStepColorIn,
                  borderRadius: BorderRadius.circular(selectedStepSize),
                  border: Border.all(
                      width: selectedStepBorderSize,
                      color: selectedStepColorOut)),
              height: selectedStepSize,
              width: selectedStepSize,
            ),
          );
  }

  Widget stepDoneWidget() {
    return doneStepWidget != null
        ? doneStepWidget!
        : ClipRRect(
            borderRadius: BorderRadius.circular(doneStepSize),
            child: Container(
                color: doneStepColor,
                height: doneStepSize,
                width: doneStepSize,
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: doneStepSize / 2,
                  ),
                )),
          );
  }

  Widget stepUnselectedWidget(currentStepNumber) {
    return unselectedStepWidget != null
        ? unselectedStepWidget!
        : ClipRRect(
            borderRadius: BorderRadius.circular(unselectedStepSize),
            child: Container(
              decoration: BoxDecoration(
                  color: unselectedStepColorIn,
                  borderRadius: BorderRadius.circular(unselectedStepSize),
                  border: Border.all(
                      width: unselectedStepBorderSize,
                      color: unselectedStepColorOut)),
              height: unselectedStepSize,
              width: unselectedStepSize,
            ),
          );
  }

  Widget stepLineDoneWidget(int i) {
    return Container(
      height: isHorizontal ? doneLineThickness : getLineLength(i),
      width: isHorizontal ? getLineLength(i) : doneLineThickness,
      color: doneLineColor,
      margin: EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget stepLineUndoneWidget(int i) {
    return Container(
        height: isHorizontal ? undoneLineThickness : getLineLength(i),
        width: isHorizontal ? getLineLength(i) : undoneLineThickness,
        color: undoneLineColor);
  }

  double getLineLength(int i) {
    var nbStep = i + 1;
    if (lineLengthCustomStep != null && lineLengthCustomStep!.length > 0) {
      if (lineLengthCustomStep!.any((it) => (it.nbStep - 1) == nbStep)) {
        return lineLengthCustomStep!
            .firstWhere((it) => (it.nbStep - 1) == nbStep)
            .length;
      }
    }
    return lineLength;
  }
}

class StepsIndicatorCustomLine {
  final int nbStep;
  final double length;

  StepsIndicatorCustomLine({this.nbStep = 4, this.length = 20});
}
