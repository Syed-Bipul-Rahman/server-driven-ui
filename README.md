# Server-Driven UI (SDUI) Flutter Demo

A comprehensive Flutter MVP app that demonstrates **Server-Driven UI (SDUI)** by dynamically rendering the entire user interface from JSON configuration loaded at runtime.

## 🚀 Features

### Core Capabilities
- **Dynamic UI Rendering**: Load and parse JSON configurations to build Flutter widgets
- **FutureBuilder Integration**: Asynchronous loading with proper loading/error states
- **Comprehensive Widget Support**: 15+ widget types with full styling support
- **Error Handling**: Robust error handling with fallback UI and detailed error messages
- **Extensible Architecture**: Easy registration of custom widgets
- **Cross-Platform**: Runs on Android and iOS

### Supported Widgets

| Widget Type | Description | Example Features |
|-------------|-------------|------------------|
| **Text** | Basic text display | fontSize, color, alignment, fontWeight |
| **RichText** | Multi-styled text spans | Individual styling per text segment |
| **Button** | Interactive buttons | Actions (log, snackbar), custom text |
| **Image** | Network/Asset images | Width, height, fit modes, error handling |
| **Icon** | Material icons | Size, color, 15+ predefined icons |
| **Column** | Vertical layout | MainAxis/CrossAxis alignment |
| **Row** | Horizontal layout | MainAxis/CrossAxis alignment, spacing |
| **Container** | Styled containers | Padding, margin, colors, border radius |
| **Center** | Centering wrapper | Centers child widgets |
| **SizedBox** | Spacing/sizing | Fixed width/height dimensions |
| **Card** | Material cards | Elevation, margin, padding |
| **ListView** | Scrollable lists | Shrink wrap, dynamic children |
| **TextField** | Text input | Labels, hints, onChange logging |
| **Checkbox** | Boolean input | Labels, state management |
| **Dropdown** | Selection input | Options list, state management |
| **Divider** | Visual separators | Height, thickness, color |

### Actions & Interactivity
- **Button Actions**: Log messages, show snackbars (extensible)
- **State Management**: Built-in state handling for interactive widgets
- **Event Logging**: Debug console logging for all interactions

## 📱 Screenshots

The app demonstrates all features in a single scrollable interface:
- Welcome header with styled text
- Interactive elements (buttons, forms)
- Layout examples (rows, containers)
- Icons and media display
- Feature showcase

## 🛠 Installation & Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Android/iOS development setup

### Quick Start

1. **Clone or create the project**:
   ```bash
   flutter create server_driven_ui
   cd server_driven_ui
   ```

2. **Add the JSON asset to `pubspec.yaml`**:
   ```yaml
   flutter:
     uses-material-design: true
     assets:
       - assets/ui_config.json
   ```

3. **Create the assets directory and add the JSON file**:
   ```bash
   mkdir assets
   # Copy the ui_config.json file to the assets folder
   ```

4. **Replace the default code with SDUI implementation** (files provided in this repository)

5. **Install dependencies**:
   ```bash
   flutter pub get
   ```

6. **Run the app**:
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── main.dart                    # App entry point with FutureBuilder
├── sdui_parser.dart            # Core parser and style helpers
└── widgets/
    └── widget_builders.dart    # All widget builder implementations

assets/
└── ui_config.json             # UI configuration with examples

pubspec.yaml                   # Project configuration with assets
README.md                      # This file
```

## 🎯 Architecture Overview

### Core Components

1. **SDUIParser**: Main parser class that converts JSON to Flutter widgets
   - Widget registration system for extensibility
   - Error handling with fallback widgets
   - Recursive parsing for nested structures

2. **Widget Builders**: Individual builder classes for each widget type
   - Clean separation of concerns
   - Consistent error handling
   - Easy to extend and modify

3. **StyleHelper**: Utility class for parsing common style properties
   - Color parsing (hex, named colors)
   - Text alignment and font properties
   - Layout alignment helpers
   - EdgeInsets parsing

### Key Design Principles

- **Modular**: Each widget builder is independent and reusable
- **Extensible**: Easy to add new widget types through registration
- **Robust**: Comprehensive error handling prevents app crashes
- **Loosely Coupled**: Components can be used in other projects
- **Best Practices**: Follows Flutter and Dart conventions

## 🔧 Customization

### Adding New Widgets

1. **Create a new widget builder**:
   ```dart
   class CustomWidgetBuilder {
     static Widget? build(Map<String, dynamic> config, SDUIParser parser) {
       // Your implementation here
       return YourCustomWidget();
     }
   }
   ```

2. **Register the new widget**:
   ```dart
   parser.registerWidget('customWidget', CustomWidgetBuilder.build);
   ```

3. **Use in JSON**:
   ```json
   {
     "type": "customWidget",
     "customProperty": "value"
   }
   ```

### Extending Actions

Add new button actions in `ButtonWidgetBuilder._handleButtonAction()`:

```dart
case 'customAction':
  // Your custom action implementation
  break;
```

### Styling Options

The JSON supports extensive styling options:

```json
{
  "type": "text",
  "text": "Styled text",
  "style": {
    "fontSize": 18,
    "color": "#FF5722",
    "fontWeight": "bold",
    "fontStyle": "italic"
  },
  "textAlign": "center"
}
```

## 🧪 Testing

### Running the App

```bash
# Development mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>
```

### Modifying the UI

1. Edit `assets/ui_config.json`
2. Hot restart the app (`R` in terminal or `Ctrl+Shift+F5` in VS Code)
3. Changes will be reflected immediately

### Error Testing

Try these scenarios to test error handling:
- Invalid JSON syntax in `ui_config.json`
- Unknown widget types
- Missing required properties
- Invalid color values

## 📚 JSON Configuration Reference

### Basic Structure

```json
{
  "type": "widgetType",
  "property": "value",
  "children": [...],
  "child": {...},
  "style": {...}
}
```

### Common Properties

- `type`: Widget type (required)
- `children`: Array of child widgets
- `child`: Single child widget
- `style`: Styling configuration
- `color`: Color (hex or name)
- `width`/`height`: Dimensions
- `padding`/`margin`: Spacing

### Example Configuration

```json
{
  "type": "column",
  "children": [
    {
      "type": "text",
      "text": "Hello, SDUI!",
      "style": {
        "fontSize": 24,
        "color": "blue",
        "fontWeight": "bold"
      }
    },
    {
      "type": "button",
      "text": "Click me",
      "action": {
        "type": "log",
        "message": "Button clicked!"
      }
    }
  ]
}
```

## 🚀 Production Considerations

### Performance
- JSON parsing is done once on load
- Widgets are built lazily
- Consider caching parsed configurations

### Network Loading
- Currently loads from local assets
- Can be extended to load from network APIs
- Add network error handling for production use

### State Management
- Interactive widgets use local state
- Consider external state management for complex apps
- State persistence may be needed

### Security
- Validate JSON structure before parsing
- Sanitize user inputs
- Consider schema validation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new widgets
4. Submit a pull request

## 📄 License

This project is open source and available under the MIT License.

## 🎯 Next Steps

- [ ] Add more widget types (AppBar, Scaffold, etc.)
- [ ] Implement network loading with caching
- [ ] Add schema validation
- [ ] Create visual JSON editor
- [ ] Add animation support
- [ ] Implement theme support
- [ ] Add unit tests

---

**Made with ❤️ using Flutter and Server-Driven UI principles**