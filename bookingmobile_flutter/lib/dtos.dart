/* Options:
Date: 2023-01-17 15:30:05
Version: 6.51
Tip: To override a DTO option, remove "//" prefix before updating
BaseUrl: https://localhost:5001

//GlobalNamespace: 
//AddServiceStackTypes: True
//AddResponseStatus: False
//AddImplicitVersion: 
//AddDescriptionAsComments: True
//IncludeTypes: 
//ExcludeTypes: 
//DefaultImports: package:servicestack/servicestack.dart
*/

import 'package:servicestack/servicestack.dart';

enum RoomType
{
    Single,
    Double,
    Queen,
    Twin,
    Suite,
}

/**
* Discount Coupons
*/
// @Icon(Svg="<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path fill='currentColor' d='M2 9.5V4a1 1 0 0 1 1-1h18a1 1 0 0 1 1 1v5.5a2.5 2.5 0 1 0 0 5V20a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1v-5.5a2.5 2.5 0 1 0 0-5zm2-1.532a4.5 4.5 0 0 1 0 8.064V19h16v-2.968a4.5 4.5 0 0 1 0-8.064V5H4v2.968zM9 9h6v2H9V9zm0 4h6v2H9v-2z' /></svg>")
class Coupon implements IConvertible
{
    String? id;
    String? description;
    int? discount;
    DateTime? expiryDate;

    Coupon({this.id,this.description,this.discount,this.expiryDate});
    Coupon.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        description = json['description'];
        discount = json['discount'];
        expiryDate = JsonConverters.fromJson(json['expiryDate'],'DateTime',context!);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'discount': discount,
        'expiryDate': JsonConverters.toJson(expiryDate,'DateTime',context!)
    };

    getTypeName() => "Coupon";
    TypeContext? context = _ctx;
}

/**
* Booking Details
*/
// @Icon(Svg="<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path fill='currentColor' d='M16 10H8c-.55 0-1 .45-1 1s.45 1 1 1h8c.55 0 1-.45 1-1s-.45-1-1-1zm3-7h-1V2c0-.55-.45-1-1-1s-1 .45-1 1v1H8V2c0-.55-.45-1-1-1s-1 .45-1 1v1H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-1 16H6c-.55 0-1-.45-1-1V8h14v10c0 .55-.45 1-1 1zm-5-5H8c-.55 0-1 .45-1 1s.45 1 1 1h5c.55 0 1-.45 1-1s-.45-1-1-1z'/></svg>")
class Booking extends AuditBase implements IConvertible
{
    int? id;
    String? name;
    RoomType? roomType;
    int? roomNumber;
    DateTime? bookingStartDate;
    DateTime? bookingEndDate;
    double? cost;
    // @References(typeof(Coupon))
    String? couponId;

    Coupon? discount;
    String? notes;
    bool? cancelled;

    Booking({this.id,this.name,this.roomType,this.roomNumber,this.bookingStartDate,this.bookingEndDate,this.cost,this.couponId,this.discount,this.notes,this.cancelled});
    Booking.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        super.fromMap(json);
        id = json['id'];
        name = json['name'];
        roomType = JsonConverters.fromJson(json['roomType'],'RoomType',context!);
        roomNumber = json['roomNumber'];
        bookingStartDate = JsonConverters.fromJson(json['bookingStartDate'],'DateTime',context!);
        bookingEndDate = JsonConverters.fromJson(json['bookingEndDate'],'DateTime',context!);
        cost = JsonConverters.toDouble(json['cost']);
        couponId = json['couponId'];
        discount = JsonConverters.fromJson(json['discount'],'Coupon',context!);
        notes = json['notes'];
        cancelled = json['cancelled'];
        return this;
    }

    Map<String, dynamic> toJson() => super.toJson()..addAll({
        'id': id,
        'name': name,
        'roomType': JsonConverters.toJson(roomType,'RoomType',context!),
        'roomNumber': roomNumber,
        'bookingStartDate': JsonConverters.toJson(bookingStartDate,'DateTime',context!),
        'bookingEndDate': JsonConverters.toJson(bookingEndDate,'DateTime',context!),
        'cost': cost,
        'couponId': couponId,
        'discount': JsonConverters.toJson(discount,'Coupon',context!),
        'notes': notes,
        'cancelled': cancelled
    });

    getTypeName() => "Booking";
    TypeContext? context = _ctx;
}

class HelloResponse implements IConvertible
{
    String? result;
    ResponseStatus? responseStatus;

    HelloResponse({this.result,this.responseStatus});
    HelloResponse.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        result = json['result'];
        responseStatus = JsonConverters.fromJson(json['responseStatus'],'ResponseStatus',context!);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'result': result,
        'responseStatus': JsonConverters.toJson(responseStatus,'ResponseStatus',context!)
    };

    getTypeName() => "HelloResponse";
    TypeContext? context = _ctx;
}

class Todo implements IConvertible
{
    int? id;
    String? text;
    bool? isFinished;

    Todo({this.id,this.text,this.isFinished});
    Todo.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        text = json['text'];
        isFinished = json['isFinished'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isFinished': isFinished
    };

    getTypeName() => "Todo";
    TypeContext? context = _ctx;
}

// @Route("/hello/{Name}")
class Hello implements IReturn<HelloResponse>, IConvertible
{
    String? name;

    Hello({this.name});
    Hello.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        name = json['name'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'name': name
    };

    createResponse() => HelloResponse();
    getResponseTypeName() => "HelloResponse";
    getTypeName() => "Hello";
    TypeContext? context = _ctx;
}

// @Route("/hellosecure/{Name}")
// @ValidateRequest(Validator="IsAuthenticated")
class HelloSecure implements IReturn<HelloResponse>, IConvertible
{
    String? name;

    HelloSecure({this.name});
    HelloSecure.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        name = json['name'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'name': name
    };

    createResponse() => HelloResponse();
    getResponseTypeName() => "HelloResponse";
    getTypeName() => "HelloSecure";
    TypeContext? context = _ctx;
}

// @Route("/todos", "GET")
class QueryTodos extends QueryData<Todo> implements IReturn<QueryResponse<Todo>>, IConvertible
{
    int? id;
    List<int>? ids;
    String? textContains;

    QueryTodos({this.id,this.ids,this.textContains});
    QueryTodos.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        super.fromMap(json);
        id = json['id'];
        ids = JsonConverters.fromJson(json['ids'],'List<int>',context!);
        textContains = json['textContains'];
        return this;
    }

    Map<String, dynamic> toJson() => super.toJson()..addAll({
        'id': id,
        'ids': JsonConverters.toJson(ids,'List<int>',context!),
        'textContains': textContains
    });

    createResponse() => QueryResponse<Todo>();
    getResponseTypeName() => "QueryResponse<Todo>";
    getTypeName() => "QueryTodos";
    TypeContext? context = _ctx;
}

// @Route("/todos", "POST")
class CreateTodo implements IReturn<Todo>, IPost, IConvertible
{
    // @Validate(Validator="NotEmpty")
    String? text;

    CreateTodo({this.text});
    CreateTodo.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        text = json['text'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'text': text
    };

    createResponse() => Todo();
    getResponseTypeName() => "Todo";
    getTypeName() => "CreateTodo";
    TypeContext? context = _ctx;
}

// @Route("/todos/{Id}", "PUT")
class UpdateTodo implements IReturn<Todo>, IPut, IConvertible
{
    int? id;
    // @Validate(Validator="NotEmpty")
    String? text;

    bool? isFinished;

    UpdateTodo({this.id,this.text,this.isFinished});
    UpdateTodo.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        text = json['text'];
        isFinished = json['isFinished'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isFinished': isFinished
    };

    createResponse() => Todo();
    getResponseTypeName() => "Todo";
    getTypeName() => "UpdateTodo";
    TypeContext? context = _ctx;
}

// @Route("/todos/{Id}", "DELETE")
class DeleteTodo implements IReturnVoid, IDelete, IConvertible
{
    int? id;

    DeleteTodo({this.id});
    DeleteTodo.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id
    };

    createResponse() {}
    getTypeName() => "DeleteTodo";
    TypeContext? context = _ctx;
}

// @Route("/todos", "DELETE")
class DeleteTodos implements IReturnVoid, IDelete, IConvertible
{
    List<int>? ids;

    DeleteTodos({this.ids});
    DeleteTodos.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        ids = JsonConverters.fromJson(json['ids'],'List<int>',context!);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'ids': JsonConverters.toJson(ids,'List<int>',context!)
    };

    createResponse() {}
    getTypeName() => "DeleteTodos";
    TypeContext? context = _ctx;
}

/**
* Find Bookings
*/
// @Route("/bookings", "GET")
// @Route("/bookings/{Id}", "GET")
class QueryBookings extends QueryDb<Booking> implements IReturn<QueryResponse<Booking>>, IConvertible
{
    int? id;

    QueryBookings({this.id});
    QueryBookings.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        super.fromMap(json);
        id = json['id'];
        return this;
    }

    Map<String, dynamic> toJson() => super.toJson()..addAll({
        'id': id
    });

    createResponse() => QueryResponse<Booking>();
    getResponseTypeName() => "QueryResponse<Booking>";
    getTypeName() => "QueryBookings";
    TypeContext? context = _ctx;
}

/**
* Find Coupons
*/
// @Route("/coupons", "GET")
class QueryCoupons extends QueryDb<Coupon> implements IReturn<QueryResponse<Coupon>>, IConvertible
{
    String? id;

    QueryCoupons({this.id});
    QueryCoupons.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        super.fromMap(json);
        id = json['id'];
        return this;
    }

    Map<String, dynamic> toJson() => super.toJson()..addAll({
        'id': id
    });

    createResponse() => QueryResponse<Coupon>();
    getResponseTypeName() => "QueryResponse<Coupon>";
    getTypeName() => "QueryCoupons";
    TypeContext? context = _ctx;
}

/**
* Create a new Booking
*/
// @Route("/bookings", "POST")
// @ValidateRequest(Validator="HasRole(`Employee`)")
class CreateBooking implements IReturn<IdResponse>, ICreateDb<Booking>, IConvertible
{
    /**
    * Name this Booking is for
    */
    // @Validate(Validator="NotEmpty")
    String? name;

    RoomType? roomType;
    // @Validate(Validator="GreaterThan(0)")
    int? roomNumber;

    // @Validate(Validator="GreaterThan(0)")
    double? cost;

    // @required()
    DateTime? bookingStartDate;

    DateTime? bookingEndDate;
    // @Input(Type="textarea")
    String? notes;

    String? couponId;

    CreateBooking({this.name,this.roomType,this.roomNumber,this.cost,this.bookingStartDate,this.bookingEndDate,this.notes,this.couponId});
    CreateBooking.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        name = json['name'];
        roomType = JsonConverters.fromJson(json['roomType'],'RoomType',context!);
        roomNumber = json['roomNumber'];
        cost = JsonConverters.toDouble(json['cost']);
        bookingStartDate = JsonConverters.fromJson(json['bookingStartDate'],'DateTime',context!);
        bookingEndDate = JsonConverters.fromJson(json['bookingEndDate'],'DateTime',context!);
        notes = json['notes'];
        couponId = json['couponId'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'name': name,
        'roomType': JsonConverters.toJson(roomType,'RoomType',context!),
        'roomNumber': roomNumber,
        'cost': cost,
        'bookingStartDate': JsonConverters.toJson(bookingStartDate,'DateTime',context!),
        'bookingEndDate': JsonConverters.toJson(bookingEndDate,'DateTime',context!),
        'notes': notes,
        'couponId': couponId
    };

    createResponse() => IdResponse();
    getResponseTypeName() => "IdResponse";
    getTypeName() => "CreateBooking";
    TypeContext? context = _ctx;
}

/**
* Update an existing Booking
*/
// @Route("/booking/{Id}", "PATCH")
// @ValidateRequest(Validator="HasRole(`Employee`)")
class UpdateBooking implements IReturn<IdResponse>, IPatchDb<Booking>, IConvertible
{
    int? id;
    String? name;
    RoomType? roomType;
    // @Validate(Validator="GreaterThan(0)")
    int? roomNumber;

    // @Validate(Validator="GreaterThan(0)")
    double? cost;

    DateTime? bookingStartDate;
    DateTime? bookingEndDate;
    // @Input(Type="textarea")
    String? notes;

    String? couponId;
    bool? cancelled;

    UpdateBooking({this.id,this.name,this.roomType,this.roomNumber,this.cost,this.bookingStartDate,this.bookingEndDate,this.notes,this.couponId,this.cancelled});
    UpdateBooking.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        name = json['name'];
        roomType = JsonConverters.fromJson(json['roomType'],'RoomType',context!);
        roomNumber = json['roomNumber'];
        cost = JsonConverters.toDouble(json['cost']);
        bookingStartDate = JsonConverters.fromJson(json['bookingStartDate'],'DateTime',context!);
        bookingEndDate = JsonConverters.fromJson(json['bookingEndDate'],'DateTime',context!);
        notes = json['notes'];
        couponId = json['couponId'];
        cancelled = json['cancelled'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'roomType': JsonConverters.toJson(roomType,'RoomType',context!),
        'roomNumber': roomNumber,
        'cost': cost,
        'bookingStartDate': JsonConverters.toJson(bookingStartDate,'DateTime',context!),
        'bookingEndDate': JsonConverters.toJson(bookingEndDate,'DateTime',context!),
        'notes': notes,
        'couponId': couponId,
        'cancelled': cancelled
    };

    createResponse() => IdResponse();
    getResponseTypeName() => "IdResponse";
    getTypeName() => "UpdateBooking";
    TypeContext? context = _ctx;
}

/**
* Delete a Booking
*/
// @Route("/booking/{Id}", "DELETE")
// @ValidateRequest(Validator="HasRole(`Manager`)")
class DeleteBooking implements IReturnVoid, IDeleteDb<Booking>, IConvertible
{
    int? id;

    DeleteBooking({this.id});
    DeleteBooking.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id
    };

    createResponse() {}
    getTypeName() => "DeleteBooking";
    TypeContext? context = _ctx;
}

// @Route("/coupons", "POST")
// @ValidateRequest(Validator="HasRole(`Employee`)")
class CreateCoupon implements IReturn<IdResponse>, ICreateDb<Coupon>, IConvertible
{
    // @Validate(Validator="NotEmpty")
    String? description;

    // @Validate(Validator="GreaterThan(0)")
    int? discount;

    // @Validate(Validator="NotNull")
    DateTime? expiryDate;

    CreateCoupon({this.description,this.discount,this.expiryDate});
    CreateCoupon.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        description = json['description'];
        discount = json['discount'];
        expiryDate = JsonConverters.fromJson(json['expiryDate'],'DateTime',context!);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'description': description,
        'discount': discount,
        'expiryDate': JsonConverters.toJson(expiryDate,'DateTime',context!)
    };

    createResponse() => IdResponse();
    getResponseTypeName() => "IdResponse";
    getTypeName() => "CreateCoupon";
    TypeContext? context = _ctx;
}

// @Route("/coupons/{Id}", "PATCH")
// @ValidateRequest(Validator="HasRole(`Employee`)")
class UpdateCoupon implements IReturn<IdResponse>, IPatchDb<Coupon>, IConvertible
{
    String? id;
    // @Validate(Validator="NotEmpty")
    String? description;

    // @Validate(Validator="NotNull")
    // @Validate(Validator="GreaterThan(0)")
    int? discount;

    // @Validate(Validator="NotNull")
    DateTime? expiryDate;

    UpdateCoupon({this.id,this.description,this.discount,this.expiryDate});
    UpdateCoupon.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        description = json['description'];
        discount = json['discount'];
        expiryDate = JsonConverters.fromJson(json['expiryDate'],'DateTime',context!);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'discount': discount,
        'expiryDate': JsonConverters.toJson(expiryDate,'DateTime',context!)
    };

    createResponse() => IdResponse();
    getResponseTypeName() => "IdResponse";
    getTypeName() => "UpdateCoupon";
    TypeContext? context = _ctx;
}

/**
* Delete a Coupon
*/
// @Route("/coupons/{Id}", "DELETE")
// @ValidateRequest(Validator="HasRole(`Manager`)")
class DeleteCoupon implements IReturnVoid, IDeleteDb<Coupon>, IConvertible
{
    String? id;

    DeleteCoupon({this.id});
    DeleteCoupon.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id
    };

    createResponse() {}
    getTypeName() => "DeleteCoupon";
    TypeContext? context = _ctx;
}

TypeContext _ctx = TypeContext(library: 'localhost', types: <String, TypeInfo> {
    'RoomType': TypeInfo(TypeOf.Enum, enumValues:RoomType.values),
    'Coupon': TypeInfo(TypeOf.Class, create:() => Coupon()),
    'Booking': TypeInfo(TypeOf.Class, create:() => Booking()),
    'HelloResponse': TypeInfo(TypeOf.Class, create:() => HelloResponse()),
    'Todo': TypeInfo(TypeOf.Class, create:() => Todo()),
    'Hello': TypeInfo(TypeOf.Class, create:() => Hello()),
    'HelloSecure': TypeInfo(TypeOf.Class, create:() => HelloSecure()),
    'QueryResponse<Todo>': TypeInfo(TypeOf.Class, create:() => QueryResponse<Todo>()),
    'QueryTodos': TypeInfo(TypeOf.Class, create:() => QueryTodos()),
    'List<Todo>': TypeInfo(TypeOf.Class, create:() => <Todo>[]),
    'CreateTodo': TypeInfo(TypeOf.Class, create:() => CreateTodo()),
    'UpdateTodo': TypeInfo(TypeOf.Class, create:() => UpdateTodo()),
    'DeleteTodo': TypeInfo(TypeOf.Class, create:() => DeleteTodo()),
    'DeleteTodos': TypeInfo(TypeOf.Class, create:() => DeleteTodos()),
    'QueryResponse<Booking>': TypeInfo(TypeOf.Class, create:() => QueryResponse<Booking>()),
    'QueryBookings': TypeInfo(TypeOf.Class, create:() => QueryBookings()),
    'List<Booking>': TypeInfo(TypeOf.Class, create:() => <Booking>[]),
    'QueryResponse<Coupon>': TypeInfo(TypeOf.Class, create:() => QueryResponse<Coupon>()),
    'QueryCoupons': TypeInfo(TypeOf.Class, create:() => QueryCoupons()),
    'List<Coupon>': TypeInfo(TypeOf.Class, create:() => <Coupon>[]),
    'CreateBooking': TypeInfo(TypeOf.Class, create:() => CreateBooking()),
    'UpdateBooking': TypeInfo(TypeOf.Class, create:() => UpdateBooking()),
    'DeleteBooking': TypeInfo(TypeOf.Class, create:() => DeleteBooking()),
    'CreateCoupon': TypeInfo(TypeOf.Class, create:() => CreateCoupon()),
    'UpdateCoupon': TypeInfo(TypeOf.Class, create:() => UpdateCoupon()),
    'DeleteCoupon': TypeInfo(TypeOf.Class, create:() => DeleteCoupon()),
});

