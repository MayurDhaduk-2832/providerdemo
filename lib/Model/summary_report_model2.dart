class DeviceReportModel {
  final String id;
  final DeviceObjModel devObj;
  final double totalOdo;
  final int todayRunning;
  final int tIdling;
  final int todayStopped;
  final String startAddress;
  final String endAddress;
  final List<dynamic> trip;
  final int todayTrips;
  final int todayRouteViolations;
  final int todayOverspeeds;
  final int todayOdo;
  final int tOfr;
  final LocationModel startLocation;
  final LocationModel endLocation;

  DeviceReportModel({
     this.id,
     this.devObj,
     this.totalOdo,
     this.todayRunning,
     this.tIdling,
     this.todayStopped,
     this.startAddress,
     this.endAddress,
     this.trip,
     this.todayTrips,
     this.todayRouteViolations,
     this.todayOverspeeds,
     this.todayOdo,
     this.tOfr,
     this.startLocation,
     this.endLocation,
  });

  factory DeviceReportModel.fromJson(Map<String, dynamic> json) {
    return DeviceReportModel(
      id: json['_id'],
      devObj: DeviceObjModel.fromJson(json['devObj']),
      totalOdo: json['total_odo'],
      todayRunning: json['today_running'],
      tIdling: json['t_idling'],
      todayStopped: json['today_stopped'],
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
      trip: json['trip'],
      todayTrips: json['today_trips'],
      todayRouteViolations: json['today_routeViolations'],
      todayOverspeeds: json['today_overspeeds'],
      todayOdo: json['today_odo'],
      tOfr: json['t_ofr'],
      startLocation: LocationModel.fromJson(json['start_location']),
      endLocation: LocationModel.fromJson(json['end_location']),
    );
  }
}

class DeviceObjModel {
  final String deviceName;
  final String deviceId;
  final String id;
  final String mileage;

  DeviceObjModel({
     this.deviceName,
     this.deviceId,
     this.id,
     this.mileage,
  });

  factory DeviceObjModel.fromJson(Map<String, dynamic> json) {
    return DeviceObjModel(
      deviceName: json['Device_Name'],
      deviceId: json['Device_ID'],
      id: json['_id'],
      mileage: json['Mileage'],
    );
  }
}

class LocationModel {
  final double lat;
  final double long;

  LocationModel({
     this.lat,
     this.long,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: json['lat'].toDouble(),
      long: json['long'].toDouble(),
    );
  }
}
