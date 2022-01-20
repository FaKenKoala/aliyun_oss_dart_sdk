import 'pub_bucket_image_request.dart';

class GetBucketImageResult extends PutBucketImageRequest {
  String? status;

  GetBucketImageResult([String? bucketName]) : super(bucketName ?? "");
}
