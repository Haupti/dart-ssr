import 'package:ssr/html.dart';

class PartialHtml implements Component {

  List<Component> partialHtml;
  PartialHtml(this.partialHtml);

  @override
  String render(){
    return renderMany(partialHtml);
  }
}