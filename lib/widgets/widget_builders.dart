import 'package:flutter/material.dart';
import '../sdui_parser.dart';

/// Collection of widget builders for different UI components
/// Each builder converts JSON configuration to Flutter widgets

/// Text widget builder
class TextWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final String? text = config['text'];
    if (text == null) return null;

    final textStyle = StyleHelper.parseTextStyle(config['style']);
    final alignment = StyleHelper.parseTextAlign(config['textAlign']);

    return Text(
      text,
      style: textStyle,
      textAlign: alignment,
    );
  }
}

/// RichText widget builder with styled spans
class RichTextWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final List<dynamic>? spans = config['spans'];
    if (spans == null || spans.isEmpty) return null;

    final List<TextSpan> textSpans = [];
    
    for (final span in spans) {
      if (span is Map<String, dynamic>) {
        final String? text = span['text'];
        if (text != null) {
          final style = StyleHelper.parseTextStyle(span['style']);
          textSpans.add(TextSpan(text: text, style: style));
        }
      }
    }

    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: StyleHelper.parseTextAlign(config['textAlign']) ?? TextAlign.start,
    );
  }
}

/// Button widget builder (ElevatedButton)
class ButtonWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final String? text = config['text'];
    if (text == null) return null;

    return ElevatedButton(
      onPressed: () => _handleButtonAction(config['action']),
      child: Text(text),
    );
  }

  static void _handleButtonAction(dynamic action) {
    if (action is Map<String, dynamic>) {
      final String? type = action['type'];
      switch (type) {
        case 'log':
          debugPrint('Button pressed: ${action['message'] ?? 'No message'}');
          break;
        case 'snackbar':
          // Note: In a real app, you'd need context for this
          debugPrint('Snackbar: ${action['message'] ?? 'Button pressed'}');
          break;
        default:
          debugPrint('Unknown action type: $type');
      }
    } else {
      debugPrint('Button pressed with no action');
    }
  }
}

/// Image widget builder (supports network and asset images)
class ImageWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final String? url = config['url'];
    final String? asset = config['asset'];
    final double? width = (config['width'] as num?)?.toDouble();
    final double? height = (config['height'] as num?)?.toDouble();

    if (url != null) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: _parseBoxFit(config['fit']),
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width ?? 100,
            height: height ?? 100,
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    } else if (asset != null) {
      return Image.asset(
        asset,
        width: width,
        height: height,
        fit: _parseBoxFit(config['fit']),
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width ?? 100,
            height: height ?? 100,
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    }

    return null;
  }

  static BoxFit? _parseBoxFit(String? fit) {
    if (fit == null) return null;
    switch (fit.toLowerCase()) {
      case 'fill': return BoxFit.fill;
      case 'contain': return BoxFit.contain;
      case 'cover': return BoxFit.cover;
      case 'fitwidth': return BoxFit.fitWidth;
      case 'fitheight': return BoxFit.fitHeight;
      case 'none': return BoxFit.none;
      case 'scaledown': return BoxFit.scaleDown;
      default: return null;
    }
  }
}

/// Icon widget builder
class IconWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final String? iconName = config['icon'];
    if (iconName == null) return null;

    final IconData? iconData = _getIconData(iconName);
    if (iconData == null) return null;

    return Icon(
      iconData,
      size: (config['size'] as num?)?.toDouble(),
      color: StyleHelper.parseColor(config['color']),
    );
  }

  static IconData? _getIconData(String iconName) {
    // Simple icon mapping - in a real app you might want a more comprehensive mapping
    switch (iconName.toLowerCase()) {
      case 'star': return Icons.star;
      case 'favorite': return Icons.favorite;
      case 'home': return Icons.home;
      case 'person': return Icons.person;
      case 'settings': return Icons.settings;
      case 'search': return Icons.search;
      case 'add': return Icons.add;
      case 'remove': return Icons.remove;
      case 'edit': return Icons.edit;
      case 'delete': return Icons.delete;
      case 'check': return Icons.check;
      case 'close': return Icons.close;
      case 'menu': return Icons.menu;
      case 'arrow_back': return Icons.arrow_back;
      case 'arrow_forward': return Icons.arrow_forward;
      default: return Icons.help_outline; // fallback icon
    }
  }
}

/// Column layout widget builder
class ColumnWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final List<dynamic>? children = config['children'];
    if (children == null) return null;

    return Column(
      mainAxisAlignment: StyleHelper.parseMainAxisAlignment(config['mainAxisAlignment']) 
          ?? MainAxisAlignment.start,
      crossAxisAlignment: StyleHelper.parseCrossAxisAlignment(config['crossAxisAlignment']) 
          ?? CrossAxisAlignment.center,
      children: parser.parseWidgets(children),
    );
  }
}

/// Row layout widget builder
class RowWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final List<dynamic>? children = config['children'];
    if (children == null) return null;

    return Row(
      mainAxisAlignment: StyleHelper.parseMainAxisAlignment(config['mainAxisAlignment']) 
          ?? MainAxisAlignment.start,
      crossAxisAlignment: StyleHelper.parseCrossAxisAlignment(config['crossAxisAlignment']) 
          ?? CrossAxisAlignment.center,
      children: parser.parseWidgets(children),
    );
  }
}

/// Container widget builder
class ContainerWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final Map<String, dynamic>? childConfig = config['child'];
    final Widget? child = childConfig != null ? parser.parseWidget(childConfig) : null;

    return Container(
      width: (config['width'] as num?)?.toDouble(),
      height: (config['height'] as num?)?.toDouble(),
      padding: StyleHelper.parseEdgeInsets(config['padding']),
      margin: StyleHelper.parseEdgeInsets(config['margin']),
      decoration: BoxDecoration(
        color: StyleHelper.parseColor(config['color']),
        borderRadius: _parseBorderRadius(config['borderRadius']),
      ),
      child: child,
    );
  }

  static BorderRadius? _parseBorderRadius(dynamic radius) {
    if (radius == null) return null;
    if (radius is num) {
      return BorderRadius.circular(radius.toDouble());
    }
    return null;
  }
}

/// Center widget builder
class CenterWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final Map<String, dynamic>? childConfig = config['child'];
    final Widget? child = childConfig != null ? parser.parseWidget(childConfig) : null;

    return Center(child: child);
  }
}

/// SizedBox widget builder
class SizedBoxWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final Map<String, dynamic>? childConfig = config['child'];
    final Widget? child = childConfig != null ? parser.parseWidget(childConfig) : null;

    return SizedBox(
      width: (config['width'] as num?)?.toDouble(),
      height: (config['height'] as num?)?.toDouble(),
      child: child,
    );
  }
}

/// Card widget builder
class CardWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final Map<String, dynamic>? childConfig = config['child'];
    final Widget? child = childConfig != null ? parser.parseWidget(childConfig) : null;

    return Card(
      elevation: (config['elevation'] as num?)?.toDouble() ?? 1.0,
      margin: StyleHelper.parseEdgeInsets(config['margin']),
      child: Padding(
        padding: StyleHelper.parseEdgeInsets(config['padding']) ?? const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

/// TextField widget builder
class TextFieldWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final String? label = config['label'];
    final String? hint = config['hint'];

    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        debugPrint('TextField changed: $value');
      },
    );
  }
}

/// Checkbox widget builder
class CheckboxWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final String? label = config['label'];
    final bool initialValue = config['value'] ?? false;

    return StatefulBuilder(
      builder: (context, setState) {
        bool isChecked = initialValue;
        return CheckboxListTile(
          title: label != null ? Text(label) : null,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
              debugPrint('Checkbox ${label ?? 'unnamed'} changed to: $isChecked');
            });
          },
        );
      },
    );
  }
}

/// Dropdown widget builder
class DropdownWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final List<dynamic>? options = config['options'];
    final String? label = config['label'];
    
    if (options == null || options.isEmpty) return null;

    final List<String> stringOptions = options.map((e) => e.toString()).toList();

    return StatefulBuilder(
      builder: (context, setState) {
        String? selectedValue = stringOptions.first;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
            ],
            DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              items: stringOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                  debugPrint('Dropdown ${label ?? 'unnamed'} changed to: $selectedValue');
                });
              },
            ),
          ],
        );
      },
    );
  }
}

/// ListView widget builder
class ListViewWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    final List<dynamic>? children = config['children'];
    if (children == null) return null;

    return ListView(
      shrinkWrap: config['shrinkWrap'] ?? false,
      children: parser.parseWidgets(children),
    );
  }
}

/// Divider widget builder
class DividerWidgetBuilder {
  static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
    return Divider(
      height: (config['height'] as num?)?.toDouble(),
      thickness: (config['thickness'] as num?)?.toDouble(),
      color: StyleHelper.parseColor(config['color']),
    );
  }
}