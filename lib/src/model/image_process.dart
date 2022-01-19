class ImageProcess {
  ImageProcess(
    this.compliedHost,
    this.sourceFileProtect,
    this.sourceFileProtectSuffix,
    this.styleDelimiters, [
    this.supportAtStyle,
  ]);

  // Img表示设置的样式分隔符，只有Img能用；Both表示oss也能用Img的样式分隔符
  String? compliedHost;
  // 是否开启原图保护
  bool? sourceFileProtect;
  // 原图保护的后缀，*表示所有
  String? sourceFileProtectSuffix;
  // 自定义样式分隔符
  String? styleDelimiters;
  // 图片服务的版本目前是2，只能读取不能设置
  int? version;
  // 用户是否能够通过OSS域名使用老版图片处理接口，@格式。默认Disabled
  bool? supportAtStyle;
}
