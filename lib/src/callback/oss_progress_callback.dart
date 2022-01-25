abstract class OSSProgressCallback<T> {
  void onProgress(T request, int currentSize, int totalSize);
}
