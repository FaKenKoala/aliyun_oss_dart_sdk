import 'generic_request.dart';

/// Options for deleting multiple objects in a specified bucket.
class DeleteObjectsRequest extends GenericRequest {
  static final int DELETE_OBJECTS_ONETIME_LIMIT = 1000;

  /* List of keys to delete */
  final List<String> _keys = [];

  /* Whether to enable quiet mode for response, default is false */
  bool quiet = false;

  /*
     * Optional parameter indicating the encoding method to be applied on the
     * response.
     */
  String? encodingType;

  DeleteObjectsRequest(String bucketName) : super(bucketName: bucketName);

  List<String> getKeys() {
    return _keys;
  }

  void setKeys(List<String>? keys) {
    if (keys?.isEmpty ?? true) {
      throw ArgumentError("Keys to delete must be specified");
    }

    if (keys!.length > DELETE_OBJECTS_ONETIME_LIMIT) {
      throw ArgumentError(
          "The count of keys to delete exceed max limit $DELETE_OBJECTS_ONETIME_LIMIT");
    }

    for (String? key in keys) {
      if (key?.isEmpty ?? false || !OSSUtils.validateObjectKey(key)) {
        throw ArgumentError("Illegal object key $key");
      }
    }

    _keys
      ..clear()
      ..addAll(keys);
  }

}
