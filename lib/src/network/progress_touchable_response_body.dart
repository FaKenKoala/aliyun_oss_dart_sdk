
 import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/network/lib_network.dart';

class ProgressTouchableResponseBody<T extends OSSRequest> extends ResponseBody {

     final ResponseBody responseBody;
     OSSProgressCallback progressListener;
     BufferedSource bufferedSource;
    final  T request;

     ProgressTouchableResponseBody(this. responseBody, ExecutionContext context) :
        progressListener = context.progressCallback,
        request =  context.request as T;
    

    @override
     MediaType contentType() {
        return responseBody.contentType();
    }

    @override
     int contentLength() {
        return responseBody.contentLength();
    }

    @override
     BufferedSource source() {
        if (bufferedSource == null) {
            bufferedSource = Okio.buffer(source(responseBody.source()));
        }
        return bufferedSource;
    }

     Source source(Source source) {
        return ForwardingSource(source) {
             int totalBytesRead = 0L;

            @override
             int read(Buffer sink, int byteCount)  {
                int bytesRead = super.read(sink, byteCount);
                totalBytesRead += bytesRead != -1 ? bytesRead : 0;
                //callback
                if (progressListener != null && bytesRead != -1 && totalBytesRead != 0) {
                    progressListener.onProgress(request, totalBytesRead, responseBody.contentLength());
                }
                return bytesRead;
            }
        };
    }
}
