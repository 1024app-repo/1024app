import 'package:communityfor1024/util/sp_helper.dart';

/// https://images.weserv.nl/docs/
String getOptimizedImage(String imageURL) {
  if (imageURL.endsWith(".gif") || !SpHelper.isImageOptimizeEnabled()) {
    return imageURL;
  }
  return "https://images.weserv.nl/?url=$imageURL&default=$imageURL&w=800&q=75&output=webp";
}
