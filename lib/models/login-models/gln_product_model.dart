class GLNProductsModel {
  int? glnId;
  String? gcpGLNID;
  String? locationNameEn;
  String? locationNameAr;
  String? gLNBarcodeNumber;
  String? longitude;
  String? latitude;
  String? status;

  GLNProductsModel(
      {this.glnId,
      this.gcpGLNID,
      this.locationNameEn,
      this.locationNameAr,
      this.gLNBarcodeNumber,
      this.longitude,
      this.latitude,
      this.status});

  GLNProductsModel.fromJson(Map<String, dynamic> json) {
    glnId = json['gln_id'];
    gcpGLNID = json['gcpGLNID'];
    locationNameEn = json['locationNameEn'];
    locationNameAr = json['locationNameAr'];
    gLNBarcodeNumber = json['GLNBarcodeNumber'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gln_id'] = glnId;
    data['gcpGLNID'] = gcpGLNID;
    data['locationNameEn'] = locationNameEn;
    data['locationNameAr'] = locationNameAr;
    data['GLNBarcodeNumber'] = gLNBarcodeNumber;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    return data;
  }
}
