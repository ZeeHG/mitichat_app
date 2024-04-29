## 2.1.0 - 2023.01.29

* Follow the file naming convention in Effective Dart, #59
* fix: AM/PM are backward for 12:00, #185
* added ROMANIAN localization

## 2.0.5 - 2022.07.19

* close debug log (#178)

## 2.0.4 - 2022.06.28

* Add `PickerLocalizations.registerCustomLanguage` function
* Add `onBuilderItem` params. Allow custom item to be generated.
* Fixed bug: #158, #168, #169, #177

## 2.0.3 - 2022.02.212

* Fixed bug: #161, #165 ...
* Add `onBuilder`, `backgroundColor` parameter to `show`, `showDialog`, `showModal`

## 2.0.2 - 2021.06.25

* Fixed bug: #142, #98
* Add demo DurationPicker
* Add onConfirmBefore callback event;

## 2.0.1
* Fixed bug.
* Add PickerWidget.of(context) Get Picker
* Add selectedIconTheme property

## 2.0.0
* Support Null safety
* Optimize code, Update demo list

## 1.1.5
* Repair BUG (Including the problem of datetime adapter before the month, add the needUpdatePrev interface to the adapter)
* add builderHeader params. Allow custom headers to be generated.
* DateTimePickerAdapter add minHour, maxHour.
* Thank you for your timely feedback in GitHub!

## 1.1.4
* performance optimization
* Add a demo with a pop-up fillet background at the bottom.

## 1.1.3
* return for showDialog , add barrierDismissible (thanks: Ali1Ammar)

## 1.1.2
* Add the ability to jump minutes in DateTimePickerAdapter #76 (thank: MoacirSchmidt)
* Repair BUG

## 1.1.1
* Add localization for Turkish language
* Refactor localization code
* Repair BUG

## 1.1.0

* Project reconstruction, removing Android, IOS directory. 
* Add localization for Spanish language

## 1.0.15

* Move the edge of the head to the bottom of the head so that it can be hidden by customization. #55 (thank: @StarOfLife)
* Repair bug: .showDialog(contex) - error for define style #49 (thank: @nielgomes)
* Repair bug: Change superior data, lower data display blank #48 (thank: @DemoJameson)

## 1.0.14

* Added return for showModal #44 (thank: @GiorgioBertolotti)

## 1.0.13

* Add parameter: selectedTextStyle, Styles for setting selected items. (thank: @TristanWYL)
* Add parameter: footer, Widgets can be added at the bottom.

## 1.0.12

* Repair BUG: #38, #40
* DateTimePickerAdapter: Add the twoDigitYear attribute to support small screens (#39)

## 1.0.11

* Add localization for Arabic language
* Add parameter: cancel and confirm,  Allow yourself to specify widgets to be placed in the identified and cancelled locations
* DateTimePickerAdapter supports minValue and maxValue, which are used to limit the upper and lower bounds for selecting date and time.

## 1.0.10

* Solving #25 Problem  
* Add attributes: headerDecoration, Can be used to control header borders.
* Add Italian locale.

## 1.0.9

* Add the ability to jump numbers in NumberPickerColumn (thank: @jesusrp98)

## 1.0.8

* Repair Bug: showDialog

## 1.0.7

* Add korea locale

## 1.0.6

* Remove debugging output information

## 1.0.5

* Modifying description information

## 1.0.3

* Repair Bug.
* NumberPickerAdapter, data Add onFormatValue property
* DateTimePickerAdapter, Add customColumnType property, Support custom column order.

## 1.0.2

* Repair Bug.

## 1.0.1

* NumberPickerAdapter Support postfix; suffix.

## 1.0.0

* Add NumberPickerAdapter, Support specified number range
* Add isLinkage property, Support Array.
* Add delimiter, Insert separators between columns
* Add localization support
* Optimization code

## 0.0.5

* Adapter add notifyDataChanged function.

## 0.0.4

*  Add PickerDateTimeType.kYM.

## 0.0.3

* Support column Flex setting. Add new DateTimeAdapter type.

## 0.0.2

* Code refactoring, adding adapters. Support dialog box. Increase the date and time selection.


## 0.0.1

* Describe initial release.
