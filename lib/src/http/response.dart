import 'dart:io';

class SsrResponse {
  final HttpResponse _response;
  bool hasStatusSet = false;
  bool wasWritten = false;

  SsrResponse(HttpResponse response): _response =response;

  static SsrResponse createResponse(HttpRequest request){
    return SsrResponse(request.response);
  }

  SsrResponse setStatus(int status) {
    if(!hasStatusSet){
      try{
        _response.statusCode = status;
      } catch (e) {
        print("ERROR: setting status, headers already sent (?) $e");
      }
      hasStatusSet = true;
    }
    else {
      print("SsrResponse warning: setStatus ignored. has status ${_response.statusCode}, tried to set: $status.");
    }
    return this;
  }

  SsrResponse setLocationHeader(String location){
    return _writeHeaderOrWarn(HttpHeaders.locationHeader, location);
  }

  SsrResponse setWWWAuthenticateHeader(String acceptedAuth) {
    return _writeHeaderOrWarn(HttpHeaders.wwwAuthenticateHeader, acceptedAuth);
  }

  SsrResponse setContentTypeHtmlHeader() {
    return _writeHeaderOrWarn(HttpHeaders.contentTypeHeader, ContentType.html.value);
  }

  SsrResponse setContentLengthHeader(int length) {
    return _writeHeaderOrWarn(HttpHeaders.contentLengthHeader, length.toString());
  }

  SsrResponse write(String body) {
    _response.write(body);
    wasWritten = true;
    return this;
  }

  void close() {
    _response.close();
  }

  SsrResponse _writeHeaderOrWarn(String header, String value){
    if(!wasWritten){
      try{
        _response.headers.set(header, value);
      } catch (e) {
        print("ERROR: header already set (?) $e");
      }
    } else {
      print("SsrResponse warning: set...Header ignored. body was already written");
    }
    return this;
  }
}
