# Contributing to EEE4482 e-Library

Thank you for your interest in contributing to the EEE4482 e-Library project!

## Student Information

This project is maintained by:
- **Name:** HE HUALIANG
- **Student ID:** 230263367
- **Course:** EEE 4482 - Server Installation and Programming

## Development Workflow

### Before Making Changes

1. **Ensure your development environment is set up**
   ```bash
   flutter doctor -v
   flutter pub get
   ```

2. **Run the analyzer to check for issues**
   ```bash
   flutter analyze
   ```

3. **Test the application runs correctly**
   ```bash
   flutter run -d chrome
   ```

### Making Changes

1. **Keep changes minimal and focused**
   - One feature or fix per commit
   - Follow existing code style and patterns

2. **Add appropriate comments**
   - Document complex logic
   - Explain non-obvious decisions
   - Use Dart doc comments for public APIs

3. **Test your changes**
   - Run the application and verify functionality
   - Test on target platforms when possible
   - Check for any analyzer warnings

4. **Update documentation**
   - Update README.md if adding features or changing setup
   - Increment version number in README for significant changes
   - Document any new dependencies or requirements

### Code Style Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Keep functions small and focused
- Use const constructors where possible
- Format code using `dart format`:
  ```bash
  dart format .
  ```

### Commit Messages

Use clear, descriptive commit messages:
```
Add book search functionality to booklist page

- Implemented search bar in navigation
- Added filtering logic for book titles
- Updated UI to show search results
```

## Testing Checklist

Before finalizing changes:

- [ ] Code runs without errors
- [ ] No analyzer warnings for your changes
- [ ] Tested on at least one platform (Web recommended)
- [ ] Documentation updated if needed
- [ ] Student information remains correct
- [ ] No unnecessary files added to git (check .gitignore)

## Platform-Specific Testing

### Web
```bash
flutter build web --release
# Test the built version
cd build/web
python3 -m http.server 8000
# Visit http://localhost:8000
```

### Linux
```bash
flutter build linux --release
./build/linux/x64/release/bundle/eee4482_flutter_app1
```

### macOS
```bash
flutter build macos --release
open build/macos/Build/Products/Release/eee4482_flutter_app1.app
```

### Windows
```bash
flutter build windows --release
.\build\windows\x64\runner\Release\eee4482_flutter_app1.exe
```

## Common Tasks

### Adding a New Page

1. Create the page file in `lib/pages/`
2. Import it in `lib/main.dart`
3. Add route in the `routes` map
4. Add navigation option if needed

### Adding a New Dependency

1. Add to `pubspec.yaml` under dependencies
2. Run `flutter pub get`
3. Import in your Dart files
4. Document the dependency purpose in README.md

### Updating Student Information

Update in the following locations:
- `lib/pages/home_page.dart` - `username` variable
- `lib/pages/booklist_page.dart` - borrower information
- `README.md` - student information section
- `pubspec.yaml` - description field

## Version Management

When making significant changes:

1. Update version in README.md (V1.0, V1.1, etc.)
2. Document changes in Version History section
3. Consider updating `pubspec.yaml` version if appropriate

## Getting Help

- Flutter Documentation: https://docs.flutter.dev/
- Dart Language: https://dart.dev/
- Course Materials: See `docs/` folder
- GitHub Issues: For project-specific questions

## Questions?

For questions specific to this EEE4482 project, please refer to:
- Course instructors and TAs
- Worksheet 7g documentation in `docs/`
- Project README.md

Thank you for contributing to the EEE4482 e-Library project!
