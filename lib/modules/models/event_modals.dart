class EventModel {
  String cityName;
  String description;
  String eventDate;
  String eventId;
  String eventLocation;
  String eventTime;
  List<Interested> interested;
  String publisherId;
  List<SearchKeywords> searchKeywords;
  String streetName;
  String title;
  String volunteerNumber;

  EventModel(
      {this.cityName,
      this.description,
      this.eventDate,
      this.eventId,
      this.eventLocation,
      this.eventTime,
      this.interested,
      this.publisherId,
      this.searchKeywords,
      this.streetName,
      this.title,
      this.volunteerNumber});

  EventModel.fromJson(Map<String, dynamic> json) {
    cityName = json['city_name'];
    description = json['description'];
    eventDate = json['event_date'];
    eventId = json['event_id'];
    eventLocation = json['event_location'];
    eventTime = json['event_time'];
    if (json['interested'] != null) {
      interested = new List<Interested>();
      json['interested'].forEach((v) {
        interested.add(new Interested.fromJson(v));
      });
    }
    publisherId = json['publisher_id'];
    if (json['searchKeywords'] != null) {
      searchKeywords = new List<SearchKeywords>();
      json['searchKeywords'].forEach((v) {
        searchKeywords.add(new SearchKeywords.fromJson(v));
      });
    }
    streetName = json['street_name'];
    title = json['title'];
    volunteerNumber = json['volunteer_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_name'] = this.cityName;
    data['description'] = this.description;
    data['event_date'] = this.eventDate;
    data['event_id'] = this.eventId;
    data['event_location'] = this.eventLocation;
    data['event_time'] = this.eventTime;
    if (this.interested != null) {
      data['interested'] = this.interested.map((v) => v.toJson()).toList();
    }
    data['publisher_id'] = this.publisherId;
    if (this.searchKeywords != null) {
      data['searchKeywords'] =
          this.searchKeywords.map((v) => v.toJson()).toList();
    }
    data['street_name'] = this.streetName;
    data['title'] = this.title;
    data['volunteer_number'] = this.volunteerNumber;
    return data;
  }
}

class Interested {
  String s0;

  Interested({this.s0});

  Interested.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    return data;
  }
}

class SearchKeywords {
  String s0;
  String s1;

  SearchKeywords({this.s0, this.s1});

  SearchKeywords.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    s1 = json['1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    data['1'] = this.s1;
    return data;
  }
}
