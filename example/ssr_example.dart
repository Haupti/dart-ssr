import 'package:ssr/html.dart';
import 'package:ssr/src/http/auth.dart';
import 'package:ssr/src/http/request.dart';
import 'package:ssr/src/http/request_handler.dart';
import 'package:ssr/src/http/response.dart';
import 'package:ssr/src/http/server.dart';

class MyComponent implements Component {
  String data;
  MyComponent(this.data);
  @override
  String render(){
    return data;
  }
}

RequestHandler handler() {
  return RequestHandler(method: RequestMethod.mPost, path: "/", handler: (SsrRequest request, SsrResponse response) async {
    okHtmlResponse(response, RootPage(title: "title", elems:[MyComponent(request.requestData ?? "")]));
  }).setMinimumRole(AuthRole.none);
}
RequestHandler gethandler() {
  return RequestHandler(method: RequestMethod.mGet, path: "/", handler: (SsrRequest request, SsrResponse response) async {
    okHtmlResponse(response, RootPage(title: "title", elems:[MyComponent("aaaaaaa")]));
  }).setMinimumRole(AuthRole.none);
}


void main() async {
  server(8080, [handler(), gethandler()]);
}
