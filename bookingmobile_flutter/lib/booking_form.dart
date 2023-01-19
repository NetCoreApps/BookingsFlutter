import 'package:bookingmobile_flutter/dtos.dart';
import 'package:bookingmobile_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  State<StatefulWidget> createState() => BookingFormState();
}

class BookingFormState extends State<BookingForm> {
  final form = FormGroup({
    'name': FormControl<String>(),
    'roomType': FormControl<RoomType>(),
    'roomNumber': FormControl<int>(),
    'cost': FormControl<double>(),
    'bookingStartDate': FormControl<DateTime>(),
    'bookingEndDate': FormControl<DateTime>()
  });

  var startDateController = TextEditingController();
  var endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new Booking'),
      ),
      body: ReactiveFormBuilder(
        form: () => form,
        builder: (context, form, child) {
          return SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReactiveTextField(
                  formControlName: 'name',
                  decoration: const InputDecoration(
                      label: Text.rich(TextSpan(children: <InlineSpan>[
                    WidgetSpan(child: Text('Name'))
                  ]))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReactiveDropdownField(
                    items: createDropDowns(),
                    formControlName: 'roomType',
                    decoration: const InputDecoration(
                        label: Text.rich(TextSpan(children: <InlineSpan>[
                      WidgetSpan(child: Text('Room Type'))
                    ])))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReactiveTextField(
                    keyboardType: TextInputType.number,
                    formControlName: 'roomNumber',
                    decoration: const InputDecoration(
                        label: Text.rich(TextSpan(children: <InlineSpan>[
                      WidgetSpan(child: Text('Room Number'))
                    ])))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReactiveTextField(
                    keyboardType: TextInputType.number,
                    formControlName: 'cost',
                    decoration: const InputDecoration(
                        label: Text.rich(TextSpan(children: <InlineSpan>[
                      WidgetSpan(child: Text('Cost'))
                    ])))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReactiveDatePicker(
                  formControlName: 'bookingStartDate',
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  fieldHintText: "2022-01-01",
                  fieldLabelText: "Start Date",
                  builder: (BuildContext context,
                      ReactiveDatePickerDelegate<dynamic> picker,
                      Widget? child) {
                    picker.control.statusChanged.listen((event) {
                      setState(() => {
                            startDateController.text = picker.value != null
                                ? DateFormat('yyyy-MM-dd').format(picker.value!)
                                : ""
                          });
                    });
                    return Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              label: const Text.rich(TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(child: Text('Start Date'))
                                  ])),
                              suffixIcon: IconButton(
                                onPressed: (() => {picker.showPicker()}),
                                icon: const Icon(Icons.date_range),
                              )),
                          controller: startDateController,
                          onTap: () => {picker.showPicker()},
                          focusNode: AlwaysDisabledFocusNode(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReactiveDatePicker(
                  formControlName: 'bookingEndDate',
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  fieldHintText: "2022-01-01",
                  fieldLabelText: "End Date",
                  builder: (BuildContext context,
                      ReactiveDatePickerDelegate<dynamic> picker,
                      Widget? child) {
                    picker.control.statusChanged.listen((event) {
                      setState(() => {
                            endDateController.text = picker.value != null
                                ? DateFormat('yyyy-MM-dd').format(picker.value!)
                                : ""
                          });
                    });
                    return Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              label: const Text.rich(TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(child: Text('End Date'))
                                  ])),
                              suffixIcon: IconButton(
                                onPressed: (() => {picker.showPicker()}),
                                icon: const Icon(Icons.date_range),
                              )),
                          controller: endDateController,
                          onTap: () => {picker.showPicker()},
                          focusNode: AlwaysDisabledFocusNode(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ReactiveFormConsumer(
                builder: (buildContext, form, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: const Text(
                        'Create Booking',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        if (form.valid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Creating booking")));

                          BookingMobile.getClient()
                              .post(CreateBooking(
                                  bookingStartDate:
                                      form.control('bookingStartDate').value,
                                  bookingEndDate:
                                      form.control('bookingEndDate').value,
                                  cost: form.control('cost').value,
                                  name: form.control('name').value,
                                  roomNumber: form.control('roomNumber').value,
                                  roomType: form.control('roomType').value))
                              .then((value) => {Navigator.pop(context)})
                              .catchError((e) => {debugPrint(e.message)});
                        }
                      },
                    ),
                  );
                },
              )
            ],
          ));
        },
      ),
    );
  }

  List<DropdownMenuItem> createDropDowns() {
    // RoomType.values.map with DropdownMenuItem wouldn't convert from Set<List> with toList().
    List<DropdownMenuItem> result = [];
    for (var i = 0; i < RoomType.values.length; i++) {
      var name = RoomType.values[i].toString().split('.').last;
      result
          .add(DropdownMenuItem(value: RoomType.values[i], child: Text(name)));
    }
    return result;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
