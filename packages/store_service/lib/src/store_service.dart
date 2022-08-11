import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const String azureSearchBaseURL = 'https://pondropsearchstandard.search.windows.net/';
const Map<String, String> requestHeaders = {'Content-type': 'application/json', 'api-key': 't9qQq8k9bXhsR4VoCbJAIHYwkBrSTpE03KMKR3Kp6MAzSeAyv0pe'};

class StoreService {

  Future<StoreSearchResult> searchStore({
    required String keyword,
    required Position? geolocation,
    required int index,
  }) async {
     final response = await http
      .get(Uri.parse('${azureSearchBaseURL}indexes/azuresql-index-vwstores/docs?api-version=2021-04-30-Preview&search=*&\$top=20&\$skip=$index'), headers: requestHeaders);

      if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
      return StoreSearchResult.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load store');
  }
  }
}

class StoreSearchResult {
  String? odataContext;
  List<Value>? value;
  String? odataNextLink;

  StoreSearchResult({this.odataContext, this.value, this.odataNextLink});

  StoreSearchResult.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        value!.add(new Value.fromJson(v));
      });
    }
    odataNextLink = json['@odata.nextLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    data['@odata.nextLink'] = this.odataNextLink;
    return data;
  }
}

class Value {
  int? searchScore;
  String? id;
  int? storeNo;
  String? name;
  double? latitude;
  double? longitude;
  String? location;
  String? address;
  String? street;
  String? city;
  String? state;
  String? zipCode;
  String? phone;
  String? openHours;
  String? uRL;
  String? provider;
  String? updatedDate;
  String? country;
  String? status;
  String? directionURL;
  String? banner;
  String? stockTicker;
  Null? fax;
  Null? email;
  List<String>? locations;
  List<String>? keyphrases;

  Value(
      {this.searchScore,
      this.id,
      this.storeNo,
      this.name,
      this.latitude,
      this.longitude,
      this.location,
      this.address,
      this.street,
      this.city,
      this.state,
      this.zipCode,
      this.phone,
      this.openHours,
      this.uRL,
      this.provider,
      this.updatedDate,
      this.country,
      this.status,
      this.directionURL,
      this.banner,
      this.stockTicker,
      this.fax,
      this.email,
      this.locations,
      this.keyphrases});

  Value.fromJson(Map<String, dynamic> json) {
    searchScore = json['@search.score'];
    id = json['Id'];
    storeNo = json['StoreNo'];
    name = json['Name'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    location = json['Location'];
    address = json['Address'];
    street = json['Street'];
    city = json['City'];
    state = json['State'];
    zipCode = json['Zip_Code'];
    phone = json['Phone'];
    openHours = json['OpenHours'];
    uRL = json['URL'];
    provider = json['Provider'];
    updatedDate = json['UpdatedDate'];
    country = json['Country'];
    status = json['Status'];
    directionURL = json['DirectionURL'];
    banner = json['Banner'];
    stockTicker = json['StockTicker'];
    fax = json['Fax'];
    email = json['Email'];
    locations = json['locations'].cast<String>();
    keyphrases = json['keyphrases'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@search.score'] = this.searchScore;
    data['Id'] = this.id;
    data['StoreNo'] = this.storeNo;
    data['Name'] = this.name;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['Location'] = this.location;
    data['Address'] = this.address;
    data['Street'] = this.street;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Zip_Code'] = this.zipCode;
    data['Phone'] = this.phone;
    data['OpenHours'] = this.openHours;
    data['URL'] = this.uRL;
    data['Provider'] = this.provider;
    data['UpdatedDate'] = this.updatedDate;
    data['Country'] = this.country;
    data['Status'] = this.status;
    data['DirectionURL'] = this.directionURL;
    data['Banner'] = this.banner;
    data['StockTicker'] = this.stockTicker;
    data['Fax'] = this.fax;
    data['Email'] = this.email;
    data['locations'] = this.locations;
    data['keyphrases'] = this.keyphrases;
    return data;
  }
}