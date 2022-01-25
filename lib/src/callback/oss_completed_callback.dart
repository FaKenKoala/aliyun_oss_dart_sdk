abstract class OSSCompletedCallback<T1 extends OSSRequest,
    T2 extends OSSResult> {
  void onSuccess(T1 request, T2 result);

  void onFailure(T1 request, ClientException clientException,
      ServiceException serviceException);
}
