class DeviceExpiringModel {
  String sId;
  String deviceName;
  String deviceID;

  DeviceExpiringModel({this.sId, this.deviceName, this.deviceID});

  DeviceExpiringModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    deviceName = json['Device_Name'];
    deviceID = json['Device_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['Device_Name'] = this.deviceName;
    data['Device_ID'] = this.deviceID;
    return data;
  }
}