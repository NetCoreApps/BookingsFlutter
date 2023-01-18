import 'package:bookingmobile_flutter/booking_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicestack/servicestack.dart';

import 'dtos.dart';
import 'main.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StatefulWidget> createState() => BookingsPageState();
}

class BookingsPageState extends State<BookingsPage> {
  //State for this widget

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshBookings();
    });
  }



  Future<QueryResponse<Booking>> queryBookings() {
    return BookingMobile.getClient().get(QueryBookings());
  }

  // Future<Booking> updateBooking(Booking item) {
  //   return BookingMobile.getClient().put(UpdateBooking(
  //       id: item.id,
  //       bookingStartDate: );
  // }

  Future<void> refreshBookings() {
    return queryBookings().then((val) => {
          setState(() => {bookings = val.results ?? <Booking>[]})
        });
  }

  Future<void> deleteTodo(Booking item) {
    return BookingMobile.getClient().delete(DeleteBooking(id: item.id));
  }

  // Future<Todo> createTodo(String text) {
  //   return BookingMobile.getClient().post(CreateTodo(
  //       text: text
  //   ));
  // }

  List<Booking> bookings = <Booking>[];

  Widget createTable() {
    List<TableRow> rows = [];
    // Heading
    rows.add(const TableRow(
      children: [
        Text('Name', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Room Type', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Room Number', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Cost', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Start', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        //Text('End', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      ]
    ));
    for (int i = 0; i < bookings.length; i++) {
      rows.add(TableRow(children: <Widget>[
        // TableCell(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text(bookings[i].id.toString()),
        //   ),
        // ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(bookings[i].name.toString()),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(bookings[i].roomType.toString().split('.').last),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(bookings[i].roomNumber.toString()),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(bookings[i].cost.toString()),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(bookings[i].bookingStartDate == null
                ? ''
                : DateFormat('MMM dd')
                    .format(bookings[i].bookingStartDate!)),
          ),
        ),
        // TableCell(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text(bookings[i].bookingEndDate == null
        //         ? ''
        //         : DateFormat('yyyy-MM-dd').format(bookings[i].bookingEndDate!)),
        //   ),
        // ),
      ]));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:
          Table(children: rows, border: TableBorder.symmetric(inside: const BorderSide(width: 2, color: Colors.blue))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [createTable()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingForm()),
          ).then((value) => {
            refreshBookings()
          })
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
