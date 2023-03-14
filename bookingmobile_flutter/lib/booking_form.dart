import 'dart:async';

import 'package:bookingmobile_flutter/dtos.dart';
import 'package:bookingmobile_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:servicestack/client.dart';

class BookingForm extends StatefulWidget {
  const BookingForm({super.key, this.booking});

  final Booking? booking;

  @override
  State<StatefulWidget> createState() => BookingFormState(booking: booking);
}

class BookingFormState extends State<BookingForm> {
  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'roomType': FormControl<RoomType>(validators: [Validators.required]),
    'roomNumber': FormControl<int>(validators: [Validators.required]),
    'cost': FormControl<double>(validators: [Validators.required]),
    'bookingStartDate':
        FormControl<DateTime>(validators: [Validators.required]),
    'bookingEndDate': FormControl<DateTime>()
  });

  BookingFormState({this.booking});

  final IServiceClient client = BookingMobile.getClient();

  final Booking? booking;
  ResponseStatus? responseStatus;

  var startDateController = TextEditingController();
  var endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (booking != null) {
      form.control('name').value = booking?.name;
      form.control('roomType').value = booking?.roomType;
      form.control('roomNumber').value = booking?.roomNumber;
      form.control('cost').value = booking?.cost;
      form.control('bookingStartDate').value = booking?.bookingStartDate;
      form.control('bookingEndDate').value = booking?.bookingEndDate;
      if (booking?.bookingStartDate != null) {
        startDateController.text =
            DateFormat('yyyy-MM-dd').format(booking!.bookingStartDate!);
      }
      if (booking?.bookingEndDate != null) {
        endDateController.text =
            DateFormat('yyyy-MM-dd').format(booking!.bookingEndDate!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(booking == null ? 'Create new Booking' : 'Update Booking'),
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
                  validationMessages: {
                    'required': (error) => 'The name must not be empty'
                  },
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
                      child: Text(
                        (booking == null ? 'Create Booking' : 'Save Booking'),
                        style: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if (form.valid) {
                          createOrUpdateBooking()
                              .then((val) => {
                                    setState(() => {responseStatus = null}),
                                    Navigator.pop(context)
                                  })
                              .catchError((error) => {
                                    setState(() =>
                                        {responseStatus = error.responseStatus})
                                  });
                        }
                      },
                    ),
                  );
                },
              ),
              Text(
                  responseStatus != null
                      ? 'Error: ${responseStatus?.message}'
                      : '',
                  style: const TextStyle(fontSize: 20, color: Colors.red))
            ],
          ));
        },
      ),
    );
  }

  Future<IdResponse> createOrUpdateBooking() {
    if (booking == null) {
      return client.post(CreateBooking(
          bookingStartDate: form.control('bookingStartDate').value,
          bookingEndDate: form.control('bookingEndDate').value,
          cost: form.control('cost').value,
          name: form.control('name').value,
          roomNumber: form.control('roomNumber').value,
          roomType: form.control('roomType').value));
    } else {
      return client.put(UpdateBooking(
          id: booking?.id,
          bookingStartDate: form.control('bookingStartDate').value,
          bookingEndDate: form.control('bookingEndDate').value,
          cost: form.control('cost').value,
          name: form.control('name').value,
          roomNumber: form.control('roomNumber').value,
          roomType: form.control('roomType').value));
    }
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
