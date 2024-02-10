import 'dart:io';
import "dart:convert";
import 'request_handler.dart';
import '../html/root_page.dart';
import '../html/partial_html.dart';
import 'response.dart';
import 'auth.dart';

void defaultHandleNotFound(HttpRequest request){
  SsrResponse.createResponse(request)
    .setStatus(404)
    .setContentTypeHtmlHeader()
    .write("<h1> page not found </h1>")
    .close();
}

void server(int port, List<RequestHandler> handlers) async {
  HttpServer server = await HttpServer.bind("localhost", port);
  await server.forEach((HttpRequest request) {
      bool isHandled = false;
      for (final h in handlers) {
        if(h.isResponsible(request)){
          isHandled = true;
          authWrapper(request, h);
          request.response.close();
          break;
        }
      }
      if(!isHandled){
        defaultHandleNotFound(request);
      }
  });
}

void sendWWWAuthenticate(SsrResponse response){
  response.setStatus(401)
          .setWWWAuthenticateHeader("Basic realm=\"vtgmRealm\", charset=\"UTF-8\"")
          .close();
}

void authWrapper(HttpRequest request, RequestHandler handler){
  if(handler.minimumRole == AuthRole.none){
    handler.handle(request, SsrResponse.createResponse(request));
  }

  List<User> users = getUsers();

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
    handler.handle(request, SsrResponse.createResponse(request));
  } else {
    sendWWWAuthenticate(SsrResponse.createResponse(request));
  }
}

void okBodyResponse(SsrResponse response, String body, ContentType contentType){
  response.setStatus(200)
          .setContentTypeHtmlHeader()
          .setContentLengthHeader(body.length)
          .write(body);
}

void okHtmlResponse(SsrResponse response, RootPage body){
  okBodyResponse(response, body.renderPage(), ContentType.html);
}

void okPartialHtmlResponse(SsrResponse response, PartialHtml partialHtml){
  okBodyResponse(response, partialHtml.render(), ContentType.html);
}

