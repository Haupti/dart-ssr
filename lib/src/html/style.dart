
class Style {
  Map<String, String> property = {};
  Style({
    String? color,
    String? width,
    String? minWidth,
    String? maxWidth,
    String? height,
    String? minHeight,
    String? maxHeight,
    String? display,
    String? flexDirection,
    String? justifyContent,
    String? alignItems,
    String? alignContent,
    String? flexFlow,
    String? flexWrap,
    String? gap,
    String? textDecoration,
    String? backgroundColor,
    String? border,
    String? borderBottom,
    String? borderRadius,
    String? boxShadow,
    String? resize,
    String? lineHeight,
    String? verticalAlign,
    String? cursor,
    String? fontSize,
    String? padding,
    String? margin,
    String? textAlign,
    String? borderCollapse,
    String? position,
    String? zIndex,
    String? overflow,
    }){
    if(flexWrap != null){
      property["flex-wrap"] = flexWrap;
    }
    if(flexFlow != null){
      property["flex-flow"] = flexFlow;
    }
    if(alignContent != null){
      property["align-content"] = alignContent;
    }
    if(resize != null){
      property["resize"] = resize;
    }
    if(overflow != null){
      property["overflow"] = overflow;
    }
    if(zIndex != null){
      property["z-index"] = zIndex;
    }
    if(position != null){
      property["position"] = position;
    }
    if(borderCollapse != null){
      property["border-collapse"] = borderCollapse;
    }
    if(margin != null){
      property["margin"] = margin;
    }
    if(textAlign != null){
      property["text-align"] = textAlign;
    }
    if(padding != null){
      property["padding"] = padding;
    }
    if(maxHeight != null){
      property["max-height"] = maxHeight;
    }
    if(minHeight != null){
      property["min-height"] = minHeight;
    }
    if(maxWidth != null){
      property["max-width"] = maxWidth;
    }
    if(minWidth != null){
      property["min-width"] = minWidth;
    }
    if(fontSize != null){
      property["font-size"] = fontSize;
    }
    if(cursor != null){
      property["cursor"] = cursor;
    }
    if(color != null){
      property["color"] = color;
    }
    if(width != null){
      property["width"] = width;
    }
    if(height != null){
      property["height"] = height;
    }
    if(display != null){
      property["display"] = display;
    }
    if(flexDirection != null){
      property["flex-direction"] = flexDirection;
    }
    if(justifyContent != null){
      property["justify-content"] = justifyContent;
    }
    if(alignItems != null){
      property["align-items"] = alignItems;
    }
    if(gap != null){
      property["gap"] = gap;
    }
    if(textDecoration != null){
      property["text-decoration"] = textDecoration;
    }
    if(backgroundColor != null){
      property["background-color"] = backgroundColor;
    }
    if(border != null){
      property["border"] = border;
    }
    if(borderBottom != null){
      property["border-bottom"] = borderBottom;
    }
    if(borderRadius != null){
      property["border-radius"] = borderRadius;
    }
    if(boxShadow != null){
      property["box-shadow"] = boxShadow;
    }
    if(lineHeight != null){
      property["line-height"] = lineHeight;
    }
    if(verticalAlign != null){
      property["vertical-align"] = verticalAlign;
    }
  }
  String inline(){
    String inlineStyle = "";
    for(var key in property.keys) {
      inlineStyle = "$inlineStyle$key:${property[key]};";
    }
    return inlineStyle;
  }
  static String inlineProp(Style? style){
    if(style == null){
      return "";
    } else {
      return " style=\"${style.inline()}\"";
    }
  }
}