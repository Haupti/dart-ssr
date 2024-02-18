import 'dart:io';
import 'dart:typed_data';

class SsrResponse {
  final HttpResponse _response;
  bool _locked = false;
  int _statusCode = 200;
  final Map<String, String> _headers = {};

  SsrResponse(HttpResponse response): _response =response;

  static SsrResponse createResponse(HttpRequest request){
    return SsrResponse(request.response);
  }

  SsrResponse setStatus(int status) {
    _statusCode = status;
    return this;
  }

  SsrResponse setLocationHeader(String location){
    _headers[HttpHeaders.locationHeader] = location;
    return this;
  }

  SsrResponse setWWWAuthenticateHeader(String acceptedAuth) {
    _headers[HttpHeaders.wwwAuthenticateHeader] = acceptedAuth;
    return this;
  }

  SsrResponse setContentTypeHtmlHeader() {
    _headers[HttpHeaders.contentTypeHeader] = ContentType.html.value;
    return this;
  }

  SsrResponse setContentTypeHeader(ContentType contentType) {
    _headers[HttpHeaders.contentTypeHeader] = contentType.value;
    return this;
  }

  SsrResponse setHeader(String header, String value) {
    _headers[header] = value;
    return this;
  }

  SsrResponse setContentLengthHeader(int length) {
    _headers[HttpHeaders.contentLengthHeader] = "$length";
    return this;
  }

  void _set() {
    _response.statusCode = _statusCode;
    for(MapEntry<String ,String> e in _headers.entries){
      _response.headers.set(e.key, e.value);
    }
  }

  void write(String body) {
    if(_locked){
      print("ERROR: cannot write, response is locked");
    }
    _set();
    _response.write(body);
    _response.close();
    _locked = true;
  }

  void addStream(File file) {
    if(_locked){
      print("ERROR: cannot write, response is locked");
    }
    _set();
    _response.addStream(file.readAsBytes().asStream()).whenComplete((){
      _response.close();
    });
    _locked = true;
  }

  void close(){
    if(_locked){
      print("ERROR: cannot close, response is locked");
    }
    _set();
    _response.close();
    _locked = true;
  }
}
