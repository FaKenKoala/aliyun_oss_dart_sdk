import 'object_metadata.dart';

/// Metadata for select object requests.
/// For example, {@link CSVObjectMetadata} contains total lines so that
/// users can do line-range query for select requests
class SelectObjectMetadata extends ObjectMetadata {
  CSVObjectMetadata? csvObjectMetadata;
  JsonObjectMetadata? jsonObjectMetadata;

  SelectObjectMetadata([ObjectMetadata? objectMetadata]) {
    if (objectMetadata != null) {
      setUserMetadata(objectMetadata.getUserMetadata());
      metadata.addAll(objectMetadata.getRawMetadata());
    }
  }
}

class SelectContentMetadataBase {
  int totalLines = 0;
  int splits = 0;
}

class CSVObjectMetadata extends SelectContentMetadataBase {}

class JsonObjectMetadata extends SelectContentMetadataBase {}
