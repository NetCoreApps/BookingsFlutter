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

bool isSmall = false;

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

  Future<void> deleteBooking(Booking item) {
    return BookingMobile.getClient().delete(DeleteBooking(id: item.id));
  }

  List<Booking> bookings = <Booking>[];
  final int smallSizeWidth = 768;

  Widget createTable() {
    var width = MediaQuery.of(context).size.width;

    isSmall = width < smallSizeWidth;
    List<TableRow> rows = [];
    // Heading
    rows.add(createTableHeading());
    for (int i = 0; i < bookings.length; i++) {
      var tableRow = TableRow(children: <Widget>[
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: const Icon(Icons.edit), onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingForm(booking: bookings[i],)),
              ).then((value) => {refreshBookings()})
            }),
          ),
        ),
        createTableDataCell(bookings[i].name.toString()),
        createTableDataCell(bookings[i].roomType.toString().split('.').last),
        createTableDataCell(bookings[i].roomNumber.toString()),
        createTableDataCell(bookings[i].cost.toString()),
      ]);
      if (!isSmall) {
        tableRow.children?.add(createTableDataCell(bookings[i].bookingStartDate == null
            ? ''
            : DateFormat('MMM dd').format(bookings[i].bookingStartDate!)));
        tableRow.children?.add(createTableDataCell(bookings[i].bookingEndDate == null
              ? ''
              : DateFormat('yyyy-MM-dd').format(bookings[i].bookingEndDate!)));
      }
      tableRow.children?.add(TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(icon: const Icon(Icons.delete), onPressed: () => {
            // Delete HTTP call + update data
            deleteBooking(bookings[i]).then((val) async => {
              await refreshBookings()
            })
          }),
        ),
      ));
      rows.add(tableRow);
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: NotificationListener(
        onNotification: (SizeChangedLayoutNotification notification) {
          var width = MediaQuery.of(context).size.width;
          isSmall = width < smallSizeWidth;
          return true;
        },
        child: Table(
            children: rows,
            border: TableBorder.symmetric(
                inside: const BorderSide(width: 1, color: Colors.grey))),
      ),
    );
  }

  TableCell createTableDataCell(String value) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
    );
  }

  TableRow createTableHeading() {
    var headings = <Widget>[];
    headings.add(
        const Text('Edit',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)));
    headings.add(const Text('Name',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold)));
    headings.add(Text((isSmall ? 'Type' : 'Room Type'),
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold)));
    headings.add(Text((isSmall ? 'No' : 'Room Number'),
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold)));
    headings.add(const Text('Cost',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold)));
    if (!isSmall) {
      headings.add(const Text('Start',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold)));
      headings.add(const Text('End',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold)));
    }
    headings.add(
        const Text('Delete',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)));
    return TableRow(children: headings);
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
        heroTag: 'createbooking',
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookingForm()),
          ).then((value) => {refreshBookings()})
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
