import 'dart:convert';

VehicleListModel vehicleListModelFromJson(String str) =>
    VehicleListModel.fromJson(json.decode(str));


class VehicleListModel {
  VehicleListModel({
    this.devices,
  });

  List<VehicleLisDevice> devices;

  factory VehicleListModel.fromJson(Map<String, dynamic> json) =>
      VehicleListModel(
        devices: json["devices"] == null ? null : List<VehicleLisDevice>.from(
            json["devices"].map((x) => VehicleLisDevice.fromJson(x))),
      );
}

class VehicleLisDevice {
  VehicleLisDevice({
    this.id,
    this.virtualacc,
    this.deviceName,
    this.deviceId,
    this.emailId,
    this.supAdmin,
    this.dealer,
    this.token,
    this.typeOfDevice,
    this.simNumber,
    this.user,
    this.driverName,
    this.contactNumber,
    this.speedAlert,
    this.deviceModel,
    this.expirationDate,
    this.vehicleType,
    this.speedLimit,
    this.distanceVariation,
    this.v,
    this.ac,
    this.currentFuel,
    this.currentFuelVoltage,
    this.distFromLastStop,
    this.fuelPercent,
    this.gpsTracking,
    this.gsmSignal,
    this.heading,
    this.ip,
    this.lastAcc,
    this.lastAccChangeOn,
    this.lastAccOn,
    this.lastDeviceTime,
    this.lastPingOn,
    this.lastSpeed,
    this.lastSpeedZeroAt,
    this.port,
    this.power,
    this.temp,
    this.satellites,
    this.secLastSpeed,
    this.currentToll,
    this.currentTollName,
    this.currentPoi,
    this.currentPoiName,
    this.sb3CurrentPoi,
    this.currentRoute,
    this.lastIdleAt,
    this.statusUpdatedAt,
    this.lastIgnChangeAt,
    this.todayIgnOn,
    this.tIdling,
    this.lastStoppedAt,
    this.todayIgnOff,
    this.timeAtLastStop,
    this.todayStopped,
    this.timezone,
    this.todayRunning,
    this.lastOverIdleAlertOn,
    this.tNoGps,
    this.tOfr,
    this.tRunning,
    this.tStopped,
    this.lastOverspeedTime,
    this.lastTheftAlertOn,
    this.mileage,
    this.kycStatus,
    this.autoPark,
    this.speedChart,
    this.doMap,
    this.dIMap,
    this.sos,
    this.ac_wire_setting,
    this.capacity,
    this.todayStartLocation,
    this.tripType,
    this.todayTrips,
    this.todayMaxspeed,
    this.todayRouteViolations,
    this.todayOverspeeds,
    this.overspeeding,
    this.sosTo,
    this.ignitionSource,
    this.deviceImage,
    this.accountSuspended,
    this.license,
    this.active,
    this.arm,
    this.ignitionLock,
    this.createdOn,
    this.engineStatus,
    this.currentTripStatus,
    this.imageDoc,
    this.fuelMeasurement,
    this.snaps,
    this.fuelUnit,
    this.maxStoppageAlerted,
    this.maxStoppageAlert,
    this.status,
    this.maxSpeed,
    this.tripCount,
    this.totalOdo,
    this.todayOdo,
    this.lastLoc,
    this.secLastLocation,
    this.lastLocation,
    this.iconType,
    this.shared,
    this.overIdleLimit,
    this.overStoppedLimit,
    this.towAlert,
    this.theftAlert,
    this.maintenance,
    this.hardWare,
    this.activated,
    this.alarm,
    this.batteryStatus,
    this.batteryPercent,
    this.door,
    this.analogInput,
    this.currency,
    this.digitalInput,
    this.vehicleGroup,
    this.groupName,
    this.lastOverStoppedAlertOn,
    this.simNumber2,
    this.renewAt,
    this.renewBy,
    this.towTime,
    this.theftTime,
    this.address,
    this.distance = 0.0
  });

  String id;
  String ac_wire_setting;
  String deviceName;
  String deviceId;
  bool virtualacc;
  String emailId;
  String supAdmin;
  String dealer;
  String token;
  String typeOfDevice;
  String simNumber;
  User user;
  String driverName;
  String contactNumber;
  bool speedAlert;
  DeviceModel deviceModel;
  DateTime expirationDate;
  VehicleType vehicleType;
  dynamic speedLimit;
  String distanceVariation;
  int v;
  dynamic ac;
  dynamic currentFuel;
  dynamic currentFuelVoltage;
  double distFromLastStop;
  dynamic fuelPercent;
  String gpsTracking;
  String gsmSignal;
  String heading;
  String ip;
  String lastAcc;
  DateTime lastAccChangeOn;
  DateTime lastAccOn;
  DateTime lastDeviceTime;
  DateTime lastPingOn;
  String lastSpeed;
  DateTime lastSpeedZeroAt;
  String port;
  String power;
  String temp;
  String satellites;
  String secLastSpeed;
  dynamic currentToll;
  dynamic currentTollName;
  dynamic currentPoi;
  dynamic currentPoiName;
  dynamic sb3CurrentPoi;
  dynamic currentRoute;
  DateTime lastIdleAt;
  DateTime statusUpdatedAt;
  DateTime lastIgnChangeAt;
  int todayIgnOn;
  int tIdling;
  DateTime lastStoppedAt;
  int todayIgnOff;
  int timeAtLastStop;
  int todayStopped;
  String timezone;
  int todayRunning;
  DateTime lastOverIdleAlertOn;
  int tNoGps;
  int tOfr;
  int tRunning;
  int tStopped;
  DateTime lastOverspeedTime;
  DateTime lastTheftAlertOn;
  String simNumber2;
  var mileage;
  String kycStatus;
  bool autoPark;
  Map<String, int> speedChart;
  DoMap doMap;
  DIMap dIMap;
  bool sos;
  int capacity;
  TLocation todayStartLocation;
  int tripType;
  int todayTrips;
  int todayMaxspeed;
  int todayRouteViolations;
  int todayOverspeeds;
  bool overspeeding;
  List<dynamic> sosTo;
  String ignitionSource;
  List<dynamic> deviceImage;
  bool accountSuspended;
  String license;
  bool active;
  String arm;
  String ignitionLock = "";
  DateTime createdOn;
  bool engineStatus;
  String currentTripStatus;
  List<ImageDoc> imageDoc;
  String fuelMeasurement;
  List<dynamic> snaps;
  String fuelUnit;
  bool maxStoppageAlerted;
  bool maxStoppageAlert;
  String status;
  int maxSpeed;
  int tripCount;
  double totalOdo;
  double todayOdo;
  LastLoc lastLoc;
  TLocation secLastLocation;
  TLocation lastLocation;
  String iconType;
  List<dynamic> shared;
  int overIdleLimit;
  int overStoppedLimit;
  bool towAlert;
  bool theftAlert;
  bool maintenance;
  String hardWare;
  String activated;
  String alarm;
  String batteryStatus;
  String batteryPercent;
  String door;
  String analogInput;
  String currency;
  String digitalInput;
  VehicleGroup vehicleGroup;
  String groupName;
  DateTime lastOverStoppedAlertOn;
  DateTime renewAt;
  String renewBy;
  Time towTime;
  Time theftTime;
  String address;
  double distance;


  factory VehicleLisDevice.fromJson(Map<String, dynamic> json) =>
      VehicleLisDevice(
          id: json["_id"] == null ? null : json["_id"],
          deviceName: json["Device_Name"] == null ? "" : json["Device_Name"],
          virtualacc: json["virtualacc"] == null ? false : json["virtualacc"],
          ac_wire_setting: json["ac_wire_setting"] == null
              ? ""
              : json["ac_wire_setting"],
          deviceId: json["Device_ID"] == null ? "" : json["Device_ID"],
          emailId: json["Email_ID"] == null ? "" : json["Email_ID"],
          supAdmin: json["supAdmin"] == null ? "" : json["supAdmin"],
          dealer: json["Dealer"] == null ? "" : json["Dealer"],
          temp: json["temp"] == null ? "" : json["temp"],
          token: json["token"] == null ? "" : json["token"],
          typeOfDevice: json["type_of_device"] == null
              ? null
              : json["type_of_device"],
          simNumber: json["sim_number"] == null ? null : json["sim_number"],
          user: json["user"] == null ? null : User.fromJson(json["user"]),
          driverName: json["driver_name"] == null ? null : json["driver_name"],
          contactNumber: json["contact_number"] == null
              ? null
              : json["contact_number"],
          speedAlert: json["SpeedAlert"] == null ? null : json["SpeedAlert"],
          deviceModel: json["device_model"] == null ? null : DeviceModel
              .fromJson(json["device_model"]),
          expirationDate: json["expiration_date"] == null ? null : DateTime
              .parse(json["expiration_date"]),
          vehicleType: json["vehicleType"] == null ? null : VehicleType
              .fromJson(json["vehicleType"]),
          speedLimit: json["SpeedLimit"] == null ? null : json["SpeedLimit"],
          distanceVariation: json["distanceVariation"] == null
              ? null
              : json["distanceVariation"],
          v: json["__v"] == null ? null : json["__v"],
          ac: json["ac"] == null ? null : json["ac"],
          currentFuel: json["currentFuel"] == null ? null : json["currentFuel"],
          currentFuelVoltage: json["currentFuelVoltage"] == null
              ? null
              : json["currentFuelVoltage"],
          distFromLastStop: json["distFromLastStop"] == null
              ? null
              : json["distFromLastStop"].toDouble(),
          fuelPercent: json["fuel_percent"] == null
              ? null
              : json["fuel_percent"],
          gpsTracking: json["gpsTracking"] == null ? null : json["gpsTracking"],
          gsmSignal: json["gsmSignal"] == null ? null : json["gsmSignal"],
          heading: json["heading"] == null ? null : json["heading"],
          ip: json["ip"] == null ? null : json["ip"],
          lastAcc: json["last_ACC"] == null ? null : json["last_ACC"],
          lastAccChangeOn: json["last_ACC_change_on"] == null ? null : DateTime
              .parse(json["last_ACC_change_on"]),
          lastAccOn: json["last_ACC_on"] == null ? null : DateTime.parse(
              json["last_ACC_on"]),
          lastDeviceTime: json["last_device_time"] == null ? null : DateTime
              .parse(json["last_device_time"]),
          lastPingOn: json["last_ping_on"] == null ? DateTime.now() : DateTime
              .parse(json["last_ping_on"]),
          lastSpeed: json["last_speed"] == null ? null : json["last_speed"],
          lastSpeedZeroAt: json["last_speed_zero_at"] == null ? null : DateTime
              .parse(json["last_speed_zero_at"]),
          port: json["port"] == null ? null : json["port"],
          power: json["power"] == null ? null : json["power"],
          satellites: json["satellites"] == null ? null : json["satellites"],
          secLastSpeed: json["sec_last_speed"] == null
              ? null
              : json["sec_last_speed"],
          currentToll: json["currentToll"],
          currentTollName: json["currentTollName"],
          currentPoi: json["currentPOI"],
          currentPoiName: json["currentPOIName"],
          sb3CurrentPoi: json["sb3CurrentPOI"],
          currentRoute: json["currentRoute"],
          lastIdleAt: json["last_idle_at"] == null ? null : DateTime.parse(
              json["last_idle_at"]),
          statusUpdatedAt: json["status_updated_at"] == null
              ? DateTime.now()
              : DateTime.parse(json["status_updated_at"]),
          lastIgnChangeAt: json["lastIgnChangeAt"] == null ? null : DateTime
              .parse(json["lastIgnChangeAt"]),
          todayIgnOn: json["today_ign_on"] == null
              ? null
              : json["today_ign_on"],
          tIdling: json["t_idling"] == null ? null : json["t_idling"],
          lastStoppedAt: json["lastStoppedAt"] == null ? null : DateTime.parse(
              json["lastStoppedAt"]),
          todayIgnOff: json["today_ign_off"] == null
              ? null
              : json["today_ign_off"],
          timeAtLastStop: json["timeAtLastStop"] == null
              ? null
              : json["timeAtLastStop"],
          todayStopped: json["today_stopped"] == null
              ? null
              : json["today_stopped"],
          timezone: json["timezone"] == null ? null : json["timezone"],
          todayRunning: json["today_running"] == null
              ? null
              : json["today_running"],
          lastOverIdleAlertOn: json["lastOverIdleAlertOn"] == null
              ? null
              : DateTime.parse(json["lastOverIdleAlertOn"]),
          tNoGps: json["t_noGps"] == null ? null : json["t_noGps"],
          tOfr: json["t_ofr"] == null ? null : json["t_ofr"],
          tRunning: json["t_running"] == null ? null : json["t_running"],
          tStopped: json["t_stopped"] == null ? null : json["t_stopped"],
          lastOverspeedTime: json["last_overspeed_time"] == null
              ? null
              : DateTime.parse(json["last_overspeed_time"]),
          lastTheftAlertOn: json["last_theft_alert_on"] == null
              ? null
              : DateTime.parse(json["last_theft_alert_on"]),
          mileage: json["Mileage"] == null ? null : json["Mileage"],
          kycStatus: json["kycStatus"] == null ? null : json["kycStatus"],
          autoPark: json["autoPark"] == null ? null : json["autoPark"],
          speedChart: json["speedChart"] == null ? null : Map.from(
              json["speedChart"]).map((k, v) => MapEntry<String, int>(k, v)),
          doMap: json["doMap"] == null ? null : DoMap.fromJson(json["doMap"]),
          dIMap: json["dIMap"] == null ? null : DIMap.fromJson(json["dIMap"]),
          sos: json["sos"] == null ? null : json["sos"],
          capacity: json["capacity"] == null ? null : json["capacity"],
          todayStartLocation: json["today_start_location"] == null
              ? null
              : TLocation.fromJson(json["today_start_location"]),
          tripType: json["tripType"] == null ? null : json["tripType"],
          todayTrips: json["today_trips"] == null ? null : json["today_trips"],
          todayMaxspeed: json["today_maxspeed"] == null
              ? null
              : json["today_maxspeed"],
          todayRouteViolations: json["today_routeViolations"] == null
              ? null
              : json["today_routeViolations"],
          todayOverspeeds: json["today_overspeeds"] == null
              ? null
              : json["today_overspeeds"],
          overspeeding: json["overspeeding"] == null
              ? null
              : json["overspeeding"],
          sosTo: json["sosTo"] == null ? null : List<dynamic>.from(
              json["sosTo"].map((x) => x)),
          ignitionSource: json["ignitionSource"] == null
              ? null
              : json["ignitionSource"],
          deviceImage: json["deviceImage"] == null ? null : List<dynamic>.from(
              json["deviceImage"].map((x) => x)),
          accountSuspended: json["accountSuspended"] == null
              ? null
              : json["accountSuspended"],
          license: json["License"] == null ? null : json["License"],
          active: json["active"] == null ? null : json["active"],
          arm: json["arm"] == null ? null : json["arm"],
          ignitionLock: json["ignitionLock"] == null
              ? ""
              : json["ignitionLock"],
          createdOn: json["created_on"] == null ? null : DateTime.parse(
              json["created_on"]),
          engineStatus: json["engine_status"] == null
              ? null
              : json["engine_status"],
          currentTripStatus: json["currentTripStatus"] == null
              ? null
              : json["currentTripStatus"],
          imageDoc: json["imageDoc"] == null ? null : List<ImageDoc>.from(
              json["imageDoc"].map((x) => ImageDoc.fromJson(x))),
          fuelMeasurement: json["fuelMeasurement"] == null
              ? null
              : json["fuelMeasurement"],
          snaps: json["snaps"] == null ? null : List<dynamic>.from(
              json["snaps"].map((x) => x)),
          fuelUnit: json["fuel_unit"] == null ? "" : json["fuel_unit"],
          maxStoppageAlerted: json["maxStoppageAlerted"] == null
              ? null
              : json["maxStoppageAlerted"],
          maxStoppageAlert: json["maxStoppageAlert"] == null
              ? null
              : json["maxStoppageAlert"],
          status: json["status"] == null ? null : json["status"],
          maxSpeed: json["maxSpeed"] == null ? null : json["maxSpeed"],
          tripCount: json["tripCount"] == null ? null : json["tripCount"],
          totalOdo: json["total_odo"] == null ? null : json["total_odo"]
              .toDouble(),
          todayOdo: json["today_odo"] == null ? 0.0 : json["today_odo"]
              .toDouble(),
          lastLoc: json["last_loc"] == null ? null : LastLoc.fromJson(
              json["last_loc"]),
          secLastLocation: json["sec_last_location"] == null ? null : TLocation
              .fromJson(json["sec_last_location"]),
          lastLocation: json["last_location"] == null ? null : TLocation
              .fromJson(json["last_location"]),
          iconType: json["iconType"] == null ? null : json["iconType"],
          shared: json["Shared"] == null ? null : List<dynamic>.from(
              json["Shared"].map((x) => x)),
          overIdleLimit: json["overIdleLimit"] == null
              ? null
              : json["overIdleLimit"],
          overStoppedLimit: json["overStoppedLimit"] == null
              ? null
              : json["overStoppedLimit"],
          towAlert: json["towAlert"] == null ? null : json["towAlert"],
          theftAlert: json["theftAlert"] == null ? null : json["theftAlert"],
          maintenance: json["maintenance"] == null ? null : json["maintenance"],
          hardWare: json["HardWare"] == null ? null : json["HardWare"],
          activated: json["activated"] == null ? null : json["activated"],
          alarm: json["alarm"] == null ? null : json["alarm"],
          batteryStatus: json["batteryStatus"] == null
              ? null
              : json["batteryStatus"],
          batteryPercent: json["battery_percent"] == null
              ? null
              : json["battery_percent"],
          door: json["door"] == null ? null : json["door"],
          analogInput: json["analogInput"] == null ? null : json["analogInput"],
          currency: json["currency"] == null ? null : json["currency"],
          digitalInput: json["digitalInput"] == null
              ? null
              : json["digitalInput"],
          vehicleGroup: json["vehicleGroup"] == null ? null : VehicleGroup
              .fromJson(json["vehicleGroup"]),
          groupName: json["groupName"] == null ? null : json["groupName"],
          simNumber2: json["sim_number2"] == null ? null : json["sim_number2"],
          lastOverStoppedAlertOn: json["lastOverStoppedAlertOn"] == null
              ? null
              : DateTime.parse(json["lastOverStoppedAlertOn"]),
          renewAt: json["renew_at"] == null ? null : DateTime.parse(
              json["renew_at"]),
          renewBy: json["renew_by"] == null ? null : json["renew_by"],
          towTime: json["towTime"] == null ? null : Time.fromJson(
              json["towTime"]),
          theftTime: json["theftTime"] == null ? null : Time.fromJson(
              json["theftTime"]),
          address: json["address"] == null ? null : json["address"],
          distance: null

      );

}

class DIMap {
  DIMap({
    this.di3,
    this.di2,
    this.di1,
  });

  String di3;
  String di2;
  String di1;

  factory DIMap.fromJson(Map<String, dynamic> json) =>
      DIMap(
        di3: json["di3"] == null ? null : json["di3"],
        di2: json["di2"] == null ? null : json["di2"],
        di1: json["di1"] == null ? null : json["di1"],
      );

}

class DeviceModel {
  DeviceModel({
    this.id,
    this.deviceType,
  });

  String id;
  String deviceType;

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      DeviceModel(
        id: json["_id"] == null ? null : json["_id"],
        deviceType: json["device_type"] == null ? null : json["device_type"],
      );

}

class DoMap {
  DoMap({
    this.ignitionLock,
  });

  String ignitionLock;

  factory DoMap.fromJson(Map<String, dynamic> json) =>
      DoMap(
        ignitionLock: json["ignitionLock"] == null
            ? null
            : json["ignitionLock"],
      );

}

class ImageDoc {
  ImageDoc({
    this.docname,
    this.docdate,
    this.phone,
    this.image,
    this.doctype,
  });

  String docname;
  DateTime docdate;
  String phone;
  String image;
  String doctype;

  factory ImageDoc.fromJson(Map<String, dynamic> json) =>
      ImageDoc(
        docname: json["docname"] == null ? null : json["docname"],
        //  docdate: json["docdate"] == null ? null : DateTime.parse(json["docdate"]),
        phone: json["phone"] == null ? null : json["phone"],
        image: json["image"] == null ? null : json["image"],
        doctype: json["doctype"] == null ? null : json["doctype"],
      );

}

class LastLoc {
  LastLoc({
    this.coordinates,
    this.type,
  });

  List<double> coordinates;
  String type;

  factory LastLoc.fromJson(Map<String, dynamic> json) =>
      LastLoc(
        coordinates: json["coordinates"] == null ? null : List<double>.from(
            json["coordinates"].map((x) => x.toDouble())),
        type: json["type"] == null ? null : json["type"],
      );

}

class TLocation {
  TLocation({
    this.lat,
    this.long,
  });

  double lat;
  double long;

  factory TLocation.fromJson(Map<String, dynamic> json) =>
      TLocation(
        lat: json["lat"] == null ? 0.0 : json["lat"].toDouble(),
        long: json["long"] == null ? 0.0 : json["long"].toDouble(),
      );

}

class Time {
  Time({
    this.start,
    this.end,
  });

  DateTime start;
  DateTime end;

  factory Time.fromJson(Map<String, dynamic> json) =>
      Time(
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
      );

}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
  });

  String id;
  String firstName;
  String lastName;

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        id: json["_id"] == null ? null : json["_id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
      );

}

class VehicleGroup {
  VehicleGroup({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory VehicleGroup.fromJson(Map<String, dynamic> json) =>
      VehicleGroup(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
      );

}

class VehicleType {
  VehicleType({
    this.id,
    this.brand,
    this.model,
    this.iconType,
  });

  String id;
  String brand;
  String model;
  String iconType;

  factory VehicleType.fromJson(Map<String, dynamic> json) =>
      VehicleType(
        id: json["_id"] == null ? null : json["_id"],
        brand: json["brand"] == null ? null : json["brand"],
        model: json["model"] == null ? null : json["model"],
        iconType: json["iconType"] == null ? null : json["iconType"],
      );

}
