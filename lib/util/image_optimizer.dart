/// https://images.weserv.nl/docs/
String getOptimizedImage(String imageURL) {
  if (imageURL.endsWith(".gif")) {
    return imageURL;
  }
  return "https://images.weserv.nl/?url=$imageURL&default=$imageURL&w=800&q=75&output=webp";
}
