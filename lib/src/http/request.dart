class SsrRequest {
  String? requestData;
  String method;
  String path;
  Map<String, String> queryParams;
  SsrRequest(this.requestData, this.method, this.path, this.queryParams);
}

