import 'dart:io';

import 'package:ssr/src/http/auth.dart';
import 'package:ssr/src/http/request.dart';
import 'package:ssr/src/http/request_handler.dart';
import 'package:ssr/src/http/response.dart';
import 'package:ssr/src/http/server.dart';

RequestHandler handler() {
  return RequestHandler(method: RequestMethod.mPost, path: "/", handler: (SsrRequest request, SsrResponse response) async {
    okBodyResponse(response, request.requestData ?? "", ContentType.text);
  }).setMinimumRole(AuthRole.none);
}

void main() async {
  server(8080, [handler()]);
}
