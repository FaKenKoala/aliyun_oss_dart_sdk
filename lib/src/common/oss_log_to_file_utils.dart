import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';

import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'oss_log.dart';

class OSSLogToFileUtils {
  static void init(ClientConfiguration? cfg) {}
  //  static final String LOG_DIR_NAME = "OSSLog";
  //  static LogThreadPoolManager logService = LogThreadPoolManager.newInstance();
  // /// FileLogUtils instance
  //  static OSSLogToFileUtils? instance;
  // /// file for log
  //  static File? sLogFile;
  //  static Uri logUri;
  // /// time format
  //  static DateFormat sLogSDF = DateFormat("yyyy-MM-dd HH:mm:ss");
  // /// default 5M
  //  static int LOG_MAX_SIZE = 5 * 1024 * 1024; //5mb
  //  bool useSdCard = true;

  //  static void init(ClientConfiguration? cfg) {
  //     OSSLog.logDebug("init ...", write2local: false);
  //     if (cfg != null) {
  //         LOG_MAX_SIZE = cfg.maxLogSize;
  //     }
  //     if ( null == instance || null == sLogFile || !sLogFile!.existsSync()) {
  //         instance = getInstance();
  //         logService.addExecuteTask(Runnable() {
  //             @override
  //              void run() {
  //                 sLogFile = instance!.getLogFile();
  //                 if (sLogFile != null) {
  //                     OSSLog.logInfo("LogFilePath is: " + sLogFile!.path, false);
  //                     // 获取当前日志文件大小
  //                     int logFileSize = getLogFileSize(sLogFile);
  //                     // 若日志文件超出了预设大小，则重置日志文件
  //                     if (LOG_MAX_SIZE < logFileSize) {
  //                         OSSLog.logInfo("init reset log file", false);
  //                         instance!.resetLogFile();
  //                     }
  //                 }
  //             }
  //         });
  //     } else {
  //         OSSLog.logDebug("LogToFileUtils has been init ...", write2local: false);
  //     }
  // }

  //  static OSSLogToFileUtils getInstance() {
  //     instance ??= OSSLogToFileUtils();
  //     return instance!;
  // }

  //  static void reset() {
  //     instance = null;
  //     sLogFile = null;
  // }

  //  static int getLogFileSize(File? file) {
  //     int size = 0;
  //     if (file != null && file.existsSync()) {
  //         size = file.lengthSync();
  //     }
  //     return size;
  // }

  // /// log size
  // ///
  // /// @return
  //  static int getLocalLogFileSize() {
  //     return getLogFileSize(sLogFile);
  // }

  //  int readSDCardSpace() {
  //     int sdCardSize = 0;
  //     String state = Environment.getExternalStorageState();
  //     if (Environment.MEDIA_MOUNTED.equals(state)) {
  //         File sdcardDir = Environment.getExternalStorageDirectory();
  //         try {
  //             StatFs sf = StatFs(sdcardDir.getPath());
  //             int blockSize = sf.getBlockSize();
  //             int availCount = 0;
  //             if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2) {
  //                 availCount = sf.getAvailableBlocksint();
  //             } else {
  //                 availCount = sf.getAvailableBlocks();
  //             }
  //             sdCardSize = availCount * blockSize;
  //         } catch ( e) {
  //             sdCardSize = 0;
  //         }
  //     }
  //     OSSLog.logDebug("sd卡存储空间:$sdCardSize}kb", write2local: false);
  //     return sdCardSize;
  // }

  //  int readSystemSpace() {
  //     File root = Environment.getDataDirectory();
  //     int systemSpaceSize = 0;
  //     try {
  //         StatFs sf = StatFs(root.getPath());
  //         int blockSize = sf.getBlockSize();
  //         int availCount = 0;
  //         if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2) {
  //             availCount = sf.getAvailableBlocksint();
  //         } else {
  //             availCount = sf.getAvailableBlocks();
  //         }
  //         systemSpaceSize = availCount * blockSize ~/ 1024;
  //     } catch ( e) {
  //         systemSpaceSize = 0;
  //     }
  //     OSSLog.logDebug("内部存储空间:${systemSpaceSize}kb", write2local: false);
  //     return systemSpaceSize;
  // }

  //  void setUseSdCard(bool useSdCard) {
  //     this.useSdCard = useSdCard;
  // }

  // /// set log file
  //  void resetLogFile() {
  //     OSSLog.logDebug("Reset Log File ... ", write2local: false);

  //     // 创建log.csv，若存在则删除
  //     if (!sLogFile!.parent.existsSync()) {
  //         OSSLog.logDebug("Reset Log make File dir ... ", write2local: false);
  //         sLogFile!.parent.createSync();
  //     }
  //     File logFile = File(sLogFile!.parent.path + "/logs.csv");
  //     if (logFile.existsSync()) {
  //         logFile.delete();
  //     }
  //     // 新建日志文件
  //     createNewFile(logFile);
  // }

  //  void deleteLogFile() {
  //     // 创建log.csv，若存在则删除
  //     File logFile = File(sLogFile!.parent.path + "/logs.csv");
  //     if (logFile.existsSync()) {
  //         OSSLog.logDebug("delete Log File ... ", write2local: false);
  //         logFile.delete();
  //     }
  // }

  //  void deleteLogFileDir() {
  //     // 创建log.csv，若存在则删除
  //     deleteLogFile();
  //     File dir = File(Environment.getExternalStorageDirectory().getPath() + path.separator + LOG_DIR_NAME);
  //     if (dir.existsSync()) {
  //         OSSLog.logDebug("delete Log FileDir ... ", write2local: false);
  //         dir.delete();
  //     }
  // }

  //  File getLogFile() {
  //     late File file ;
  //     File? logFile ;
  //     bool canStorage = false;
  //     // 判断是否有SD卡或者外部存储器
  //     try {
  //         if (useSdCard && Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) && Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
  //             // 有SD卡则使用SD - PS:没SD卡但是有外部存储器，会使用外部存储器
  //             // SD\OSSLog\logs.csv
  //             canStorage = readSDCardSpace() > LOG_MAX_SIZE / 1024;
  //             file = File(Environment.getExternalStorageDirectory().getPath() + path.separator + LOG_DIR_NAME);
  //         } else {
  //             // 没有SD卡或者外部存储器，使用内部存储器
  //             // \data\data\包名\files\OSSLog\logs.csv
  //             canStorage = readSystemSpace() > LOG_MAX_SIZE / 1024;
  //             file = File(sContext.getFilesDir().getPath() + File.separator + LOG_DIR_NAME);
  //         }
  //     } catch ( e) {
  //         canStorage = false;
  //     }
  //     // 若目录不存在则创建目录
  //     if (canStorage) {
  //         if (!file.existsSync()) {
  //             file.createSync();
  //         }
  //         logFile = File(file.parent.path + "/logs.csv");
  //         if (!logFile.existsSync()) {
  //             createNewFile(logFile);
  //         }
  //     }
  //     return logFile;
  // }

  //  Uri getLogUri() {
  //     Uri uri = null;
  //     ContentResolver contentResolver = sContext.getContentResolver();

  //     uri = queryLogUri();
  //     if (uri == null) {
  //         ContentValues values = ContentValues();
  //         values[MediaStore.Files.FileColumns.DISPLAY_NAME] = "logs.csv";
  //         values[MediaStore.Files.FileColumns.MIME_TYPE] = "file/csv";
  //         values[MediaStore.Files.FileColumns.TITLE] = "logs.csv";
  //         values[MediaStore.Files.FileColumns.RELATIVE_PATH] = "Documents/" + LOG_DIR_NAME;

  //         uri = contentResolver.insert(MediaStore.Files.getContentUri("external"), values);

  //         try {
  //             contentResolver.openFileDescriptor(uri, "w");
  //         } catch ( e) {
  //             return null;
  //         }
  //     }

  //     return uri;
  // }

  //  Uri queryLogUri() {
  //     Uri uri = null;

  //     ContentResolver contentResolver = sContext.getContentResolver();
  //     Uri external = MediaStore.Files.getContentUri("external");
  //     String selection =MediaStore.Files.FileColumns.RELATIVE_PATH+" like ? AND "
  //             + MediaStore.Files.FileColumns.DISPLAY_NAME + "=?";
  //     List<String> args = List<String>{"Documents/" + LOG_DIR_NAME + "%", "logs.csv"};
  //     List<String> projection = List<String>{MediaStore.Files.FileColumns._ID};
  //     Cursor cursor = contentResolver.query(external, projection, selection, args, null);

  //     if (cursor != null && cursor.moveToFirst()) {
  //         uri = ContentUris.withAppendedId(external, cursor.getint(0));
  //         cursor.close();
  //     }
  //     return uri;
  // }

  //  void createNewFile(File logFile) {
  //     try {
  //         logFile.createNewFile();
  //     } catch ( e) {
  //         OSSLog.logError("Create log file failure !!! " + e.toString(), write2local: false);
  //     }
  // }

  //  String getFunctionInfo(StackTraceElement[] ste) {
  //     String msg = null;
  //     if (ste == null) {
  //         msg = "[" + sLogSDF.format(java.util.Date()) + "]";
  //     }
  //     return msg;
  // }

  //   void write(Object str) {
  //     if (OSSLog.isEnableLog()) {
  //         // 判断是否初始化或者初始化是否成功
  //         if (null == sContext || null == instance || null == sLogFile) {
  //             return;
  //         }
  //         if (!sLogFile.exists()) {
  //             resetLogFile();
  //         }
  //         WriteCall writeCall = WriteCall(str);
  //         logService.addExecuteTask(writeCall);
  //     }
  // }

  //  static class WriteCall implements Runnable {

  //      Object mStr;

  //      WriteCall(Object mStr) {
  //         this.mStr = mStr;
  //     }

  //     @override
  //      void run() {
  //         if (sLogFile != null) {
  //             int logFileSize = getInstance().getLogFileSize(sLogFile);
  //             // 若日志文件超出了预设大小，则重置日志文件
  //             if (logFileSize > LOG_MAX_SIZE) {
  //                 getInstance().resetLogFile();
  //             }
  //             //输出流操作 输出日志信息至本地存储空间内
  //             PrintWriter pw;
  //             try {
  //                 pw = PrintWriter(new FileWriter(sLogFile, true), true);
  //                 if (pw != null) {
  //                     if (mStr instanceof Throwable) {
  //                         //写入异常信息
  //                         printEx(pw);
  //                     } else {
  //                         //写入普通log
  //                         pw.println(getInstance().getFunctionInfo(null) + " - " + mStr.toString());
  //                     }
  //                     pw.println("------>end of log");
  //                     pw.println();
  //                     pw.close();
  //                 }
  //             } catch (OSSIOException e) {
  //                 e.printStackTrace();
  //             }
  //         }
  //     }

  //      PrintWriter printEx(PrintWriter pw) {
  //         pw.println("crash_time：" + sLogSDF.format(Date()));
  //         ((Throwable) mStr).printStackTrace(pw);
  //         return pw;
  //     }
  // }
}
