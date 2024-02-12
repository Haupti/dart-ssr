import 'dart:math';
import 'package:ssr/html.dart';

import 'style.dart';

class _ComponentImpl implements Component{
  final String _htmlStr;
  _ComponentImpl(this._htmlStr);

  @override
  String render(){
    return _htmlStr;
  }
}

abstract interface class Component{
  String render();
  static Component fromHtmlString(String staticHtml){
    return _ComponentImpl(staticHtml);
  }
}


String renderMany(List<Component> components){
  String result = "";
  for(var c in components){
    result = "$result${c.render()}";
  }
  return result;
}

class H2 implements Component{
  Style? style;
  String text;
  H2({this.style, required this.text});

  @override
  String render(){
    return """
      <h2${Style.inlineProp(style)}> $text </h2>
    """;
  }
}

class H1 implements Component{
  Style? style;
  String text;
  H1({this.style, required this.text});

  @override
  String render(){
    return """
      <h1${Style.inlineProp(style)}> $text </h1>
    """;
  }
}

class Anchor implements Component{
  Style? style;
  String href;
  String text;
  Anchor({this.style, required this.href, required this.text});

  @override
  String render(){
    return """
      <a${Style.inlineProp(style)} href="$href"> $text </a>
    """;
  }
}

class Div implements Component{
  Style? style;
  List<Component> children;

  Div({required this.children, this.style });
  @override
  String render(){
    return """
      <div${Style.inlineProp(style)}>
        ${renderMany(children)}
      </div>
    """;
  }
}

String generateId() {
  var r = Random();
  return String.fromCharCodes(List.generate(8, (index) => r.nextInt(33) + 89));
}
class FormInput implements Component {
  Style? style;
  String labelText;
  String type;
  String name;
  String? value;
  bool required = true;
  bool checked;

  FormInput({
    required this.type,
    required this.name,
    required this.labelText,
    this.value,
    this.required = true,
    this.style,
    this.checked = false,
  });

  @override
  String render() {
    String id = generateId();
    String requiredFlag = required ? "required" : "";
    return """
      <div${Style.inlineProp(style)}>
        <label for="$id">$labelText</label>
        <input type="$type" name="$name" id="$id" $requiredFlag ${value == null ? "" : """value="$value" """} ${checked ? "checked" : ""}/>
      </div>
    """;
  }
}

class Form implements Component{
  List<FormInput> formInputs;
  String action;
  String submitButtonText;

  Form({required this.formInputs, required this.action, required this.submitButtonText});

  @override
  String render(){
    Style style = Style(
      backgroundColor: "white",
      boxShadow: "2px 2px #bcc5d4",
      fontSize: "16px",
      margin: "8px 0px",
      padding: "3px 6px",
      border: "2px solid #bcc5d4",
    );
    return """
      <form action="$action" method="post">
        ${renderMany(formInputs)}
        <input${Style.inlineProp(style)} type="submit" value="$submitButtonText"/>
      </form>
    """;
  }
}

class ListItem implements Component{
  Style? style;
  String text;
  ListItem({required this.text, this.style});

  @override
  String render() {
    return """
      <li${Style.inlineProp(style)}> $text </li>
    """;
  }
}

class UnorderedList implements Component {
  List<ListItem> items;
  UnorderedList(this.items);

  @override
  String render(){
    return """
    <ul>
      ${renderMany(items)}
    </ul>
    """;
  }
}


class Paragraph implements Component{
  String text;
  Style? style;

  Paragraph({required this.text, this.style});

  @override
  String render() {
    return """
      <p${Style.inlineProp(style)}> $text </p>
    """;
  }
}

class TableHeader implements Component {
  Style? style;
  List<Component> children;

  TableHeader({required this.children, this.style});

  @override
  String render(){
    return """
      <thead${Style.inlineProp(style)}>
        ${renderMany(children)}
      </thead>
    """;
  }
}

class TableData implements Component {
  Style? style;
  String text;

  TableData({required this.text, this.style});

  @override
  String render(){
    return """
      <td${Style.inlineProp(style)}>$text</td>
    """;
  }
}

class TableRow implements Component {
  Style? style;
  List<Component> tableData;

  TableRow({required this.tableData, this.style});

  @override
  String render(){
    return """
      <tr${Style.inlineProp(style)}>
        ${renderMany(tableData)}
      </tr>
    """;
  }
}

class Table implements Component {
  List<Component> rows;
  Style? style;

  Table({required this.rows, this.style});

  @override
  String render(){
    return """
      <table${Style.inlineProp(style)}>
        ${renderMany(rows)}
      </table>
    """;
  }
}
















