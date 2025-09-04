import 'package:flutter/material.dart';
import 'widgets/widget_builders.dart';

/// Type definition for widget builder functions
typedef WidgetBuilder = Widget? Function(Map<String, dynamic> config, SDUIParser parser);

/// Main parser class for Server-Driven UI
/// This class is responsible for parsing JSON configurations and converting them to Flutter widgets
class SDUIParser {
  // Registry of widget builders - allows for extensibility
  final Map<String, WidgetBuilder> _widgetBuilders = {};

  SDUIParser() {
    _registerDefaultWidgets();
  }

  /// Register all default widget builders
  void _registerDefaultWidgets() {
    // Basic widgets
    registerWidget('text', TextWidgetBuilder.build);
    registerWidget('richText', RichTextWidgetBuilder.build);
    registerWidget('button', ButtonWidgetBuilder.build);
    registerWidget('image', ImageWidgetBuilder.build);
    registerWidget('icon', IconWidgetBuilder.build);
    
    // Layout widgets
    registerWidget('column', ColumnWidgetBuilder.build);
    registerWidget('row', RowWidgetBuilder.build);
    registerWidget('container', ContainerWidgetBuilder.build);
    registerWidget('center', CenterWidgetBuilder.build);
    registerWidget('sizedBox', SizedBoxWidgetBuilder.build);
    registerWidget('card', CardWidgetBuilder.build);
    
    // Interactive widgets
    registerWidget('textField', TextFieldWidgetBuilder.build);
    registerWidget('checkbox', CheckboxWidgetBuilder.build);
    registerWidget('dropdown', DropdownWidgetBuilder.build);
    
    // List widgets
    registerWidget('listView', ListViewWidgetBuilder.build);
    
    // Other widgets
    registerWidget('divider', DividerWidgetBuilder.build);
  }

  /// Register a custom widget builder
  /// This allows for easy extensibility of the parser
  void registerWidget(String type, WidgetBuilder builder) {
    _widgetBuilders[type] = builder;
  }

  /// Parse a widget from JSON configuration
  Widget? parseWidget(Map<String, dynamic> config) {
    try {
      final String? type = config['type'];
      if (type == null) {
        debugPrint('Warning: Widget config missing type field');
        return _buildErrorWidget('Missing type field');
      }

      final builder = _widgetBuilders[type];
      if (builder == null) {
        debugPrint('Warning: Unknown widget type: $type');
        return _buildErrorWidget('Unknown widget type: $type');
      }

      return builder(config, this);
    } catch (e) {
      debugPrint('Error parsing widget: $e');
      return _buildErrorWidget('Parse error: $e');
    }
  }

  /// Parse a list of widgets from JSON array
  List<Widget> parseWidgets(List<dynamic> configs) {
    final widgets = <Widget>[];
    
    for (final config in configs) {
      if (config is Map<String, dynamic>) {
        final widget = parseWidget(config);
        if (widget != null) {
          widgets.add(widget);
        }
      }
    }
    
    return widgets;
  }

  /// Build an error widget for display when parsing fails
  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 16),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper class for parsing common style properties
class StyleHelper {
  /// Parse color from string (hex, name, or null)
  static Color? parseColor(dynamic colorValue) {
    if (colorValue == null) return null;
    
    if (colorValue is String) {
      // Handle hex colors
      if (colorValue.startsWith('#')) {
        try {
          return Color(int.parse(colorValue.substring(1), radix: 16) | 0xFF000000);
        } catch (e) {
          debugPrint('Invalid hex color: $colorValue');
          return null;
        }
      }
      
      // Handle named colors
      switch (colorValue.toLowerCase()) {
        case 'red': return Colors.red;
        case 'blue': return Colors.blue;
        case 'green': return Colors.green;
        case 'yellow': return Colors.yellow;
        case 'orange': return Colors.orange;
        case 'purple': return Colors.purple;
        case 'pink': return Colors.pink;
        case 'brown': return Colors.brown;
        case 'grey': case 'gray': return Colors.grey;
        case 'black': return Colors.black;
        case 'white': return Colors.white;
        case 'transparent': return Colors.transparent;
        default:
          debugPrint('Unknown color name: $colorValue');
          return null;
      }
    }
    
    return null;
  }

  /// Parse text alignment
  static TextAlign? parseTextAlign(String? alignment) {
    if (alignment == null) return null;
    
    switch (alignment.toLowerCase()) {
      case 'left': return TextAlign.left;
      case 'right': return TextAlign.right;
      case 'center': return TextAlign.center;
      case 'justify': return TextAlign.justify;
      case 'start': return TextAlign.start;
      case 'end': return TextAlign.end;
      default: return null;
    }
  }

  /// Parse main axis alignment
  static MainAxisAlignment? parseMainAxisAlignment(String? alignment) {
    if (alignment == null) return null;
    
    switch (alignment.toLowerCase()) {
      case 'start': return MainAxisAlignment.start;
      case 'end': return MainAxisAlignment.end;
      case 'center': return MainAxisAlignment.center;
      case 'spacebetween': return MainAxisAlignment.spaceBetween;
      case 'spacearound': return MainAxisAlignment.spaceAround;
      case 'spaceevenly': return MainAxisAlignment.spaceEvenly;
      default: return null;
    }
  }

  /// Parse cross axis alignment
  static CrossAxisAlignment? parseCrossAxisAlignment(String? alignment) {
    if (alignment == null) return null;
    
    switch (alignment.toLowerCase()) {
      case 'start': return CrossAxisAlignment.start;
      case 'end': return CrossAxisAlignment.end;
      case 'center': return CrossAxisAlignment.center;
      case 'stretch': return CrossAxisAlignment.stretch;
      case 'baseline': return CrossAxisAlignment.baseline;
      default: return null;
    }
  }

  /// Parse EdgeInsets from various formats
  static EdgeInsets? parseEdgeInsets(dynamic padding) {
    if (padding == null) return null;
    
    if (padding is num) {
      return EdgeInsets.all(padding.toDouble());
    }
    
    if (padding is Map<String, dynamic>) {
      final left = (padding['left'] as num?)?.toDouble() ?? 0.0;
      final top = (padding['top'] as num?)?.toDouble() ?? 0.0;
      final right = (padding['right'] as num?)?.toDouble() ?? 0.0;
      final bottom = (padding['bottom'] as num?)?.toDouble() ?? 0.0;
      
      return EdgeInsets.fromLTRB(left, top, right, bottom);
    }
    
    return null;
  }

  /// Parse TextStyle from configuration
  static TextStyle? parseTextStyle(Map<String, dynamic>? styleConfig) {
    if (styleConfig == null) return null;
    
    return TextStyle(
      fontSize: (styleConfig['fontSize'] as num?)?.toDouble(),
      color: parseColor(styleConfig['color']),
      fontWeight: _parseFontWeight(styleConfig['fontWeight']),
      fontStyle: _parseFontStyle(styleConfig['fontStyle']),
    );
  }

  /// Parse font weight
  static FontWeight? _parseFontWeight(dynamic weight) {
    if (weight == null) return null;
    
    if (weight is String) {
      switch (weight.toLowerCase()) {
        case 'bold': return FontWeight.bold;
        case 'normal': return FontWeight.normal;
        default: return null;
      }
    }
    
    if (weight is num) {
      switch (weight.toInt()) {
        case 100: return FontWeight.w100;
        case 200: return FontWeight.w200;
        case 300: return FontWeight.w300;
        case 400: return FontWeight.w400;
        case 500: return FontWeight.w500;
        case 600: return FontWeight.w600;
        case 700: return FontWeight.w700;
        case 800: return FontWeight.w800;
        case 900: return FontWeight.w900;
        default: return null;
      }
    }
    
    return null;
  }

  /// Parse font style
  static FontStyle? _parseFontStyle(String? style) {
    if (style == null) return null;
    
    switch (style.toLowerCase()) {
      case 'italic': return FontStyle.italic;
      case 'normal': return FontStyle.normal;
      default: return null;
    }
  }
}