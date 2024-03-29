import 'dart:io';
import "dart:convert";
import 'request_handler.dart';
import '../html/root_page.dart';
import '../html/component.dart';
import 'response.dart';
import 'auth.dart';
import 'request.dart';

void defaultHandleNotFound(HttpRequest request){
  SsrResponse.createResponse(request)
    .setStatus(404)
    .setContentTypeHtmlHeader()
    .write("<h1> page not found </h1>");
}

void server(int port, List<RequestHandler> handlers, File usersFile) async {
  HttpServer server = await HttpServer.bind("localhost", port);
  await for (HttpRequest request in server) {
      bool isHandled = false;
      for (final h in handlers) {
        if(h.isResponsible(request.method, request.uri.path)){
          isHandled = true;
          authWrapper(request, h, usersFile);
          break;
        }
      }
      if(!isHandled){
        defaultHandleNotFound(request);
      }
  };
}

void sendWWWAuthenticate(SsrResponse response){
  response.setStatus(401)
          .setWWWAuthenticateHeader("Basic realm=\"vtgmRealm\", charset=\"UTF-8\"")
          .close();
}

void authWrapper(HttpRequest request, RequestHandler handler, File usersFile) async {
  if(handler.minimumRole == AuthRole.none){
    SsrResponse reponse = SsrResponse.createResponse(request);
    SsrRequest ssrRequest = SsrRequest(await utf8.decodeStream(request), request.method, request.uri.path, request.uri.queryParameters);
    handler.handle(ssrRequest, reponse);
    return;
  }

  List<User> users = getUsers(usersFile);

  String? authHeader = request.headers.value(HttpHeaders.authorizationHeader);
  if(authHeader == null || !authHeader.contains(RegExp(r'Basic .*'))){
    sendWWWAuthenticate(SsrResponse.createResponse(request));
    return;
  }
  RegExp rgx = RegExp(r'(?<=Basic ).*');
  RegExpMatch? match = rgx.firstMatch(authHeader);
  if(match == null){
    sendWWWAuthenticate(SsrResponse.createResponse(request));
    return;
  }
  String? authToken = match[0];
  if(authToken == null){
      sendWWWAuthenticate(SsrResponse.createResponse(request));
      return;
  }

  String decodedAuth = utf8.decode(base64.decode(authToken));
  for (User user in users) {
    if(user.verifyBasicAuth(decodedAuth)){
      currentUser = user;
    }
  }
      
  if(users.any((User user) => user.verifyBasicAuth(decodedAuth) && user.isAuthorized(handler.minimumRole))){
    SsrRequest ssrRequest = SsrRequest(await utf8.decodeStream(request), request.method, request.uri.path, request.uri.queryParameters);
    handler.handle(ssrRequest, SsrResponse.createResponse(request));
  } else {
    sendWWWAuthenticate(SsrResponse.createResponse(request));
  }
}

void okBodyResponse(SsrResponse response, String body, ContentType contentType){
  response.setStatus(200)
          .setContentTypeHeader(contentType) 
          .setContentLengthHeader(body.length)
          .write(body);
}

void okResponse(SsrResponse response, {String? body, String? headerName, String? headerValue}){
  if(body != null && headerName != null && headerValue != null){
    response.setStatus(200)
          .setContentLengthHeader(body.length)
          .setHeader(headerName, headerValue)
          .write(body);
  } else if (body == null && headerName != null && headerValue != null) {
    response.setStatus(200)
          .setHeader(headerName, headerValue)
          .close();
  } else if ((headerName != null && headerValue == null) || (headerName == null && headerValue != null)) {
    throw Exception("either header name and header value must be set, or both must not be set");
  }
}

void okFileResponse(SsrResponse response, File file, ContentType? contentType){
  if(contentType != null){
    response.setStatus(200)
          .setContentTypeHeader(contentType)
          .addStream(file);
  } else {
    response.setStatus(200)
          .addStream(file);
  }
}

void okHtmlResponse(SsrResponse response, RootPage body){
  okBodyResponse(response, body.renderPage(), ContentType.html);
}

void okPartialHtmlResponse(SsrResponse response, Component component){
  okBodyResponse(response, component.render(), ContentType.html);
}


void clientErrorResponse(SsrResponse response){
  response.setStatus(400).close();
}

void clientErrorBodyResponse(SsrResponse response, String responseBody){
  response.setStatus(400).write(responseBody);
}
