# microtask

A lightweight macOS menubar task manager built with Swift and SwiftUI.

## Features

- **Menubar Integration**: Always accessible from your macOS menubar
- **Tabbed Organization**: Organize tasks into color-coded tabs (up to 8 colors)
- **Expandable Rows**: Quick entry with expandable detail views
- **Persistent Storage**: Tasks automatically save to UserDefaults
- **Clean Design**: Minimal, beautiful interface following macOS design principles

## Requirements

- macOS 12.0 (Monterey) or later
- Xcode 15.0 or later (for development)

## Installation

### From Source

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd microtask
   ```

2. Open the project in Xcode:
   ```bash
   open Microtask.xcodeproj
   ```

3. Build and run the project (⌘R)

## Usage

### Basic Operations

- **Open microtask**: Click the checklist icon in your menubar
- **Create a new tab**: Click the `+` button in the tab bar
- **Rename a tab**: Double-click on the tab name (max 5 characters)
- **Switch tabs**: Click on any tab (inactive tabs show abbreviated view)
- **Add a task**: Type in the input field at the bottom and press Enter
- **Expand a task**: Click on any task row to expand it
- **Edit a task**: Click to expand, then edit the text
- **Collapse a task**: Click on the expanded task again

### Tab Colors

Tabs are automatically assigned colors from a palette of 8 distinct colors:
- Soft Blue
- Coral Red
- Mint Green
- Warm Orange
- Lavender Purple
- Golden Yellow
- Sky Cyan
- Rose Pink

Inactive tabs show the first letter of the tab name on a colored background for easy visual identification.

## Architecture

### Project Structure

```
Microtask/
├── Models/
│   ├── TextRow.swift      # Text row data model
│   ├── Tab.swift           # Tab data model with colors
│   └── AppState.swift      # Main app state and persistence
├── Views/
│   ├── MainContentView.swift    # Main window layout
│   ├── TabBarView.swift         # Tab bar component
│   ├── TabItemView.swift        # Individual tab view
│   ├── TabContentView.swift     # Tab content area
│   └── TextRowView.swift        # Expandable text row
├── MenuBarController.swift      # Menubar integration
└── MicrotaskApp.swift          # App entry point
```

### Key Design Decisions

- **Single Expanded Row**: Only one row can be expanded at a time per tab to maintain focus
- **Auto-Save**: All changes are automatically saved to UserDefaults
- **Transient Popover**: Window closes when clicking outside or pressing ESC
- **No Dock Icon**: App runs as an accessory (.accessory activation policy)

## Testing

The project includes comprehensive unit tests covering:
- Tab creation and management
- Row operations (add, update, delete, expand/collapse)
- Data persistence
- Character limits and validation

Run tests with:
```bash
xcodebuild test -scheme Microtask -destination 'platform=macOS'
```

Or in Xcode: ⌘U

## Future Enhancements

- [ ] Drag and drop to reorder rows
- [ ] Drag tabs to reorder
- [ ] Custom color picker for tabs
- [ ] Keyboard shortcuts (⌘N for new tab, etc.)
- [ ] Search across all tabs
- [ ] Export functionality
- [ ] Markdown support
- [ ] Task completion checkboxes
- [ ] Due dates and reminders
- [ ] iCloud sync

## Design Philosophy

microtask follows these core principles:

1. **Less is More**: Remove anything that doesn't serve the core purpose
2. **Beauty in Details**: Pixel-perfect alignment, smooth animations, thoughtful micro-interactions
3. **Proportional Harmony**: Golden ratio and balanced proportions
4. **Timeless Aesthetic**: Avoid trendy patterns, focus on fundamentals
5. **Native Feel**: Respect macOS design language and conventions

## License

[Add your license here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Tim Isaev
