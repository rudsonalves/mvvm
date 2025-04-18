# mvvm

A new Flutter project.

# Changelog

## 2025/04/17 - version: 0.5.04+12

### Add `CreateTodo` model and refactor repository and command structure

This commit introduces a new `CreateTodo` model to clearly differentiate between data used for creating a `Todo` and a fully initialized `Todo` entity. It also includes a complete refactor of `TodosRepository`, `TodoViewModel`, and UI logic to support this structure, ensuring better separation of concerns and improved readability.

### Modified Files

**lib/data/repositories/todos/todos_repository.dart**
- Modified the interface to extend `ChangeNotifier`.
- Changed the `add` method signature to accept a `CreateTodo`.

**lib/data/repositories/todos/todos_repository_dev.dart**
- Implemented `add(CreateTodo)` with UUID generation.
- Refactored the class to notify listeners and ensure data is added consistently.

**lib/data/repositories/todos/todos_repository_remote.dart**
- Same structural changes as `todos_repository_dev.dart`.
- Ensured all `Todo` instances have non-null IDs.
- Added `notifyListeners()` to update listeners on changes.

**lib/domain/models/todo.dart**
- Made `id` a required field.
- Removed nullability from all logic depending on `id`.

**lib/domain/user_cases/todo_update_user_case.dart**
- Renamed to `TodoUserCase`.
- Added `addTodo(CreateTodo)` method with logging and result handling.

**lib/routing/router.dart**
- Replaced `TodoUpdateUserCase` with `TodoUserCase`.

**lib/ui/core/widgets/edit_todo_dialog.dart**
- Split command logic for `update` and `add`.
- Adjusted UI and control logic to reflect current command.
- Included loading indicators and error dialogs specific to each command.

**lib/ui/features/todo/todo_screen.dart**
- Updated dialog call to use `add` instead of generic `command`.

**lib/ui/features/todo/todo_view_model.dart**
- Updated to use `TodoUserCase`.
- Changed internal logic to manage `CreateTodo` properly.
- Ensured that repository changes trigger view model reload.

**lib/ui/features/todo/widgets/list_tile_todo.dart**
- Removed null check on `todo.id`, which is now guaranteed to be non-null.

**lib/ui/features/todo_details/todo_details_screen.dart**
- Adjusted `EditTodoDialog` to pass `update` command.

**lib/ui/features/todo_details/todo_details_view_model.dart**
- Migrated to `TodoUserCase` and registered repository listener.

**test/data/services/api/api_client_test.dart**
- Adjusted test cases to provide `id` when creating a `Todo`.

**test/ui/todo/viewmodels/todo_viewmodel_test.dart**
- Updated to use `CreateTodo` instead of `Todo` for the creation process.

**pubspec.yaml**
- Added direct dependency: `uuid`.

**pubspec.lock**
- Resolved new dependencies: `uuid`, `fixnum`, `sprintf`.

**server/db.json**
- Updated `completedAt` timestamps and task description to reflect recent test data.

### New Files

**lib/domain/models/create_todo.dart**
- Introduced new model `CreateTodo`, containing only name and description, to cleanly separate input data from persisted entities.

### Conclusion

The refactoring introduces a clear distinction between creating and updating `Todo` entities, improves command handling, and ensures better data consistency. The system compiles successfully and all features remain functional.


## 2025/04/17 - version: 0.5.04+11

### Integrate Use Case Layer and Refactor Todo ViewModel & Dialog Logic

This commit introduces the `TodoUpdateUserCase` as an intermediary between the UI and the data layer, encapsulating the update logic for `Todo`. It refactors the `TodoViewModel`, `TodoDetailsViewModel`, and `EditTodoDialog` to use this new use case, improving separation of concerns. Additionally, component paths under the `todo` feature were reorganized into `widgets/` for consistency.

### Modified Files

- **`lib/routing/router.dart`**
  - Instantiated `TodoUpdateUserCase` and injected it into both `TodoViewModel` and `TodoDetailsViewModel`.

- **`lib/ui/core/widgets/edit_todo_dialog.dart`**
  - Refactored to accept `Command1<Todo, Todo>` as `command` instead of `todoAction`.
  - Added command listener (`_onSaveTodo`) to handle success or error feedback.
  - Improved visual feedback and user flow on dialog submission and command completion.

- **`lib/ui/features/todo/todo_screen.dart`**
  - Updated dialog usage to match the new `EditTodoDialog` API.
  - Updated import path for `todo_list_view.dart`.

- **`lib/ui/features/todo/todo_view_model.dart`**
  - Integrated `TodoUpdateUserCase`.
  - Removed internal `updateTodo` logic and delegated it to the use case.

- **`lib/ui/features/todo_details/todo_details_screen.dart`**
  - Updated to use the new `upgrade` command via `TodoUpdateUserCase`.
  - Fixed widget references for consistency.

- **`lib/ui/features/todo_details/todo_details_view_model.dart`**
  - Removed internal `_upgradeTodo` method.
  - Now uses `TodoUpdateUserCase.upgradeTodo` for the `upgrade` command.

- **`lib/ui/features/todo/components/*.dart` → `lib/ui/features/todo/widgets/*.dart`**
  - Renamed `list_tile_todo.dart` and `todo_list_view.dart` into the `widgets` folder for consistency.

- **`test/ui/todo/viewmodels/todo_viewmodel_test.dart`**
  - Injected `TodoUpdateUserCase` into `TodoViewModel` to reflect constructor change.

- **`server/db.json`**
  - Updated timestamps and description fields in mock data for consistency.

### New Files

- **`lib/domain/user_cases/todo_update_user_case.dart`**
  - Introduced a new class that encapsulates the `Todo` update logic.
  - Logs success and error scenarios and returns a `Result<Todo>`.

### Assets and Test Data

- **None**

### Conclusion

With the integration of a use case layer, this update enhances the maintainability and scalability of the application by clearly separating UI, business, and data concerns. The `EditTodoDialog` was made more reactive, and the `ViewModel`s were simplified to delegate domain logic appropriately.


## 2025/04/17 - version: 0.5.04+10

### Refactor `EditTodoDialog` for Code Clarity and Form Validation

This commit enhances the `EditTodoDialog` by improving code readability, encapsulating form validation logic, and enforcing naming conventions for private fields. The update introduces dedicated validator methods and better field naming for maintainability.

### Modified Files

- **`lib/ui/core/widgets/edit_todo_dialog.dart`**
  - Renamed `nameController` to `_nameController` and `descriptionConreoller` to `_descriptionConreoller` to follow Dart naming conventions for private members.
  - Moved validation logic for form fields to private helper methods (`_validateTitle`, `_validateDescription`).
  - Added `minLines` and `maxLines` to the description field to improve multi-line input UX.
  - Simplified form logic in `_addTodo()` using trimmed values from the renamed controllers.

### Conclusion

This refactor improves consistency, separates validation concerns, and ensures that `EditTodoDialog` remains maintainable as the codebase evolves.


## 2025/04/17 - version: 0.5.04+09

### Refactor Todo Dialog and Details Components for Improved Clarity

This commit improves the organization and semantics of the UI code by renaming and relocating core components. The `AddTodoDialog` was renamed to `EditTodoDialog` to better reflect its dual purpose (adding and editing todos), and several files under `components/` were moved to `widgets/` for consistency across the UI structure.

### Modified Files

- **`lib/ui/core/components/add_todo_dialog.dart` → `lib/ui/core/widgets/edit_todo_dialog.dart`**
  - Renamed the class from `AddTodoDialog` to `EditTodoDialog`.
  - Updated constructor and state class names accordingly.

- **`lib/ui/features/todo/todo_screen.dart`**
  - Updated import path and widget usage to reflect the new `EditTodoDialog` name and location.

- **`lib/ui/features/todo_details/todo_details_screen.dart`**
  - Updated import path for `EditTodoDialog` and `TodoDetailsCard` after renaming and relocation.
  - Adjusted dialog instantiation to use `EditTodoDialog`.

- **`lib/ui/features/todo_details/components/details_row.dart` → `lib/ui/features/todo_details/widgets/details_row.dart`**
  - Relocated without code changes to maintain naming and directory consistency.

- **`lib/ui/features/todo_details/components/todo_details_card.dart` → `lib/ui/features/todo_details/widgets/todo_details_card.dart`**
  - Relocated without code changes to follow consistent directory structure.

### Conclusion

These refinements align the file and class naming conventions with their responsibilities and improve the overall maintainability of the codebase. All dialogs and widgets now reside in appropriately named directories with clearer purposes.


## 2025/03/24 - version: 0.5.04+08

This update introduces theme toggling support and performs a major UI restructuring for better scalability and modularity.

### Changes made:

1. **lib/main.dart**:
   - Converted `AppMaterial` from a `StatelessWidget` to a `StatefulWidget`.
   - Added a theme toggle mechanism via the new `AppThemeInherited` class.
   - Wrapped `MaterialApp.router` in `AppThemeInherited` to propagate brightness and toggle function.

2. **lib/ui/core/themes/app_theme_inherited.dart**:
   - Created new inherited widget `AppThemeInherited` to manage and expose theme brightness and toggle functionality throughout the widget tree.

3. **lib/ui/features/todo/todo_screen.dart**:
   - Added a theme toggle button in the `AppBar`, using `AppThemeInherited` for context-based theming.

4. **lib/ui/core/components/add_todo_dialog.dart**:
   - Adjusted dialog title text from "Adicione nova Tarefa" to "Adicionar Tarefa" for consistency.

5. **lib/routing/router.dart**:
   - Updated paths for `todo` and `todo_details` screens and view models to reflect new feature-based directory structure.

6. **lib/ui/features/todo/**:
   - Renamed and moved files previously under `ui/todo/` to `ui/features/todo/` for improved structure.
   - Includes `todo_screen.dart`, `todo_view_model.dart`, and related components like `list_tile_todo.dart` and `todo_list_view.dart`.

7. **lib/ui/features/todo_details/**:
   - Renamed and moved files from `ui/todo_details/` to `ui/features/todo_details/`, following the same modular approach.
   - Includes screen, view model, and supporting components like `todo_details_card.dart` and `details_row.dart`.

8. **server/db.json**:
   - Updated `completedAt` values in sample data to reflect the current state and timestamps.

9. **test/ui/todo/viewmodels/todo_viewmodel_test.dart**:
   - Adjusted import path for `TodoViewModel` to reflect its new location under `features/todo`.

### Conclusion:

This refactor improves the modularization and clarity of the UI structure by grouping feature-related files. Additionally, it introduces a scalable solution for runtime theme switching via `AppThemeInherited`, enhancing the user experience and maintainability of the application.


## 2025/03/24 - version: 0.5.03+07

This update improves error logging, refines UI components, and enhances user experience through visual and interaction improvements.

### Changes made:

1. **lib/data/services/api/api_client.dart**:
   - Updated error logs in `getTodos` method to include method context (`'getTodos: $err'`) for clearer debugging.

2. **lib/main.dart**:
   - Simplified `TextTheme` initialization by removing commented-out font options and streamlining the method call.

3. **lib/ui/todo_details/components/todo_details_card.dart**:
   - Replaced `Card` with `InkWell` wrapping a `Card` to make the entire card tappable, enhancing UX.
   - Removed the `IconButton` for editing in favor of a consistent tappable surface.
   - Preserved visual structure while improving interaction design.

4. **lib/ui/todo_details/todo_details_screen.dart**:
   - Enhanced the AppBar by centering the title and setting elevation to `5` for better visual hierarchy.

5. **server/db.json**:
   - Updated the `done` field of a sample todo to `true` and adjusted the corresponding `completedAt` timestamp to reflect the completion state accurately.

### Conclusion:

These refinements contribute to improved maintainability and a more intuitive user interface, with clearer logging and enhanced interactivity on the details screen.


## 2025/03/24 - version: 0.5.03+06

This commit introduces model improvements, UI enhancements, command refactoring, and better date handling across the application.

### Changes made:

1. **android/app/build.gradle.kts**:
   - Replaced `flutter.ndkVersion` with a fixed value `"27.0.12077973"` for explicit NDK version control.

2. **lib/data/repositories/todos/todos_repository_dev.dart**:
   - Added `const` keyword to `Result.ok(null)` for consistency with updated result handling practices.

3. **lib/data/services/api/api_client.dart**:
   - Applied `const` to `Result.ok(null)` to align with updated return patterns.

4. **lib/domain/models/todo.dart**:
   - Introduced new fields `createdAt` and `completedAt` in the `Todo` model to track timestamps.
   - Updated `toMap`, `fromMap`, and `copyWith` methods to support these new fields.

5. **lib/ui/todo/components/add_todo_dialog.dart → lib/ui/core/components/add_todo_dialog.dart**:
   - Moved and refactored `AddTodoDialog` to a core reusable location.
   - Added support for editing existing todos by initializing form fields and using `todo.copyWith`.
   - Replaced `todoView` with a generic `Command1` for better decoupling and testability.

6. **lib/ui/core/themes/theme.dart**:
   - Added comments detailing the color palette used across the UI for design consistency.

7. **lib/ui/todo/components/list_tile_todo.dart**:
   - Replaced inline `onChanged` logic with a dedicated `_toggleDone` method that also updates `completedAt`.
   - Improved readability and data integrity when toggling a task's completion.

8. **lib/ui/todo/components/todo_list_view.dart**:
   - Renamed `onDoneTodo` to `onUpdateTodo` for clearer semantic meaning.

9. **lib/ui/todo/todo_screen.dart**:
   - Updated import path for `AddTodoDialog` due to refactoring.
   - Updated references from `onDoneTodo` to `onUpdateTodo` for consistency with updated interface.

10. **lib/ui/todo_details/components/details_row.dart**:
    - Added a reusable `DetailsRow` widget for displaying labeled rows in the UI.

11. **lib/ui/todo_details/components/todo_details_card.dart**:
    - Introduced a new `TodoDetailsCard` widget to present detailed information of a todo with edit capabilities.

12. **lib/ui/todo_details/components/todo_edit.dart**:
    - Removed deprecated `TodoEdit` widget, replaced by the more robust `TodoDetailsCard`.

13. **lib/ui/todo_details/todo_details_screen.dart**:
    - Integrated `TodoDetailsCard` into the details screen.
    - Added `_editTodo` method to allow inline editing using the updated `AddTodoDialog`.

14. **server/db.json**:
    - Updated todos dataset to include `createdAt` and `completedAt` fields for sample records, enabling testing with realistic data.

15. **test/utils/commands/commands_test.dart**:
    - Applied `const` to `Result.ok` return value for consistency with the new `Result` semantics.

16. **test/utils/result/result_test.dart**:
    - Updated all test cases to use `const Result.ok` for accurate and consistent result instantiation.

### Conclusion:

These changes significantly enhance the maintainability, scalability, and user experience of the application by introducing timestamp tracking, modular UI components, and a more expressive and testable command structure.


## 2025/03/24 - version: 0.5.03+05

Introduced several refinements across the codebase, focusing on enhancing result handling, UI feedback, and internal structure consistency.

### Changes made:

1. **lib/data/repositories/todos/todos_repository_remote.dart**:
   - Replaced deprecated `onSuccess` and `onFailure` with `onOk` and `onError` in all result fold statements for consistency with the updated `Result` interface.

2. **lib/ui/todo/components/list_tile_todo.dart**:
   - Changed the `elevation` of the `Card` widget from `0` to `1` for visual enhancement.
   - Replaced `IconButton` for toggling `todo.done` status with a `Checkbox`, improving clarity and accessibility.

3. **lib/ui/todo/todo_screen.dart**:
   - Updated the AppBar title from `'Todo'` to `'Todos'` for proper pluralization.

4. **lib/ui/todo_details/todo_details_view_model.dart**:
   - Refactored `fold` method calls to use `onOk` and `onError` callbacks instead of `onSuccess` and `onFailure`.

5. **lib/utils/result/result.dart**:
   - Replaced the entire `Result` implementation with a cleaner, more structured version using sealed classes and improved documentation.
   - Removed legacy `ResultExtension`s and old `fold` implementation.
   - Added documentation and clarified usage through DartDoc comments.
   - Updated `isOk` and `isError` getters to replace `isSuccess` and `isFailure`.
   - Introduced a standard `fold` method inside the `Result` class.

6. **test/data/services/api/api_client_test.dart**:
   - Removed use of deprecated `.ok()` extension method in favor of direct result handling.
   - Replaced `isSuccess` check with `isOk` in result assertions to align with new `Result` semantics.

7. **test/utils/result/result_test.dart**:
   - Updated tests to reflect the removal of the `.ok()` and `.error()` extension methods.
   - Replaced them with `Result.ok(...)` and `Result.error(...)` constructors respectively.

### Conclusion:

These changes unify the usage of the `Result` class across the codebase by modernizing its API, improving naming consistency, enhancing UI feedback, and updating related unit tests accordingly.


## 2025/03/24 - version: 0.5.02+04

This update introduces a complete theming system with dynamic light and dark modes, along with minor structural and visual improvements throughout the app.

### Changes made:

1. **assets/images/theme_dark.png**:
   - Added a new dark theme image asset for potential theme preview or UI usage.

2. **assets/images/theme_light.png**:
   - Added a new light theme image asset for potential theme preview or UI usage.

3. **lib/main.dart**:
   - Integrated dynamic theme switching based on platform brightness.
   - Applied custom text themes using `createTextTheme`.
   - Initialized the `MaterialTheme` class to manage theme variants.

4. **lib/routing/router.dart**:
   - Updated imports for `TodoViewModel` and `TodoDetailsViewModel` to reflect their new file locations.

5. **lib/ui/core/themes/text_theme.dart**:
   - Created utility to generate `TextTheme` using `google_fonts` for consistent typography customization.

6. **lib/ui/core/themes/theme.dart**:
   - Implemented a fully custom theming system with support for light, dark, medium contrast, and high contrast color schemes.
   - Defined the `MaterialTheme` class and theme generation methods using `ColorScheme` and `ThemeData`.

7. **lib/ui/todo/components/add_todo_dialog.dart**:
   - Updated import path for `TodoViewModel` due to file relocation.

8. **lib/ui/todo/components/list_tile_todo.dart**:
   - Applied custom theming for the background of each Todo card using `Theme.of(context).colorScheme`.
   - Replaced static color with themed green for completed todos.

9. **lib/ui/todo/todo_screen.dart**:
   - Added padding to the screen body for better layout structure.
   - Updated import path for `TodoViewModel`.

10. **lib/ui/todo/view_models/todo_view_model.dart → lib/ui/todo/todo_view_model.dart**:
    - Renamed file for consistency and better organization.

11. **lib/ui/todo_details/todo_details_screen.dart**:
    - Updated import path for `TodoDetailsViewModel`.

12. **lib/ui/todo_details/view_models/todo_details_view_model.dart → lib/ui/todo_details/todo_details_view_model.dart**:
    - Renamed file to align with organizational structure and naming conventions.

13. **pubspec.lock**:
    - Added several new dependencies, including `google_fonts`, `crypto`, `ffi`, `path_provider`, and related packages.
    - Updated `flutter` SDK version constraint to `>=3.27.0`.

14. **pubspec.yaml**:
    - Added `google_fonts` package as a direct dependency for custom text theming.

15. **test/ui/todo/viewmodels/todo_viewmodel_test.dart**:
    - Updated import path for `TodoViewModel` to match the new file location.

### Conclusion:

This update establishes a robust and extensible theming infrastructure, enabling support for multiple visual styles and improved UI consistency. It also improves code organization and prepares the application for future customization and accessibility enhancements.


## 2025/03/24 - version: 0.5.02+03

This update refines the Todo list UI and improves the layout of the Todo details screen to enhance the user experience and visual consistency.

### Changes made:

1. **lib/ui/todo/components/list_tile_todo.dart**:
   - Replaced the `Checkbox` widget with an `IconButton` to toggle the `done` status of a Todo using a more intuitive icon representation.
   - Applied conditional coloring (green accent) to the icon when the Todo is marked as done.
   - Commented out the previous `Checkbox` implementation for potential future reference.

2. **lib/ui/todo_details/todo_details_screen.dart**:
   - Wrapped the body content with a `Padding` widget to apply consistent spacing around the details view.
   - Adjusted indentation and structure of `ListenableBuilder` for improved readability and maintainability.

3. **server/db.json**:
   - Updated the `done` field values for mock Todo entries to reflect different states (toggled `true` and `false` values) for testing and UI validation purposes.

### Conclusion:

These improvements provide a more polished and user-friendly interface by replacing the checkbox with a dynamic icon for toggling task completion and ensuring consistent layout padding in the Todo details screen.


## 2025/03/24 - version: 0.5.01+02


This update introduces significant improvements to the Todo feature, including model enhancements, repository changes, UI adjustments, and extended ViewModel logic to support a more complete Todo experience.

### Changes made:

1. **lib/data/repositories/todos/todos_repository.dart**:
   - Added `todosMap` and `todos` getters to expose internal state.
   - Changed the `add` method to accept a `Todo` object instead of a string.

2. **lib/data/repositories/todos/todos_repository_dev.dart**:
   - Implemented `todosMap` getter to return an empty map.
   - Implemented `todos` getter to return internal `_todos` list.
   - Updated `add` method to use `Todo` object instead of a name string, assigning a new ID and copying the todo.

3. **lib/data/repositories/todos/todos_repository_remote.dart**:
   - Imported `dart:developer` for logging.
   - Implemented `todosMap` and updated `todos` to use `_todosMap`.
   - Refactored `add`, `delete`, `getAll`, `get`, and `update` methods to use `result.fold` for success and failure handling, adding logs for errors.

4. **lib/data/services/api/api_client.dart**:
   - Set `Content-Type` header explicitly with charset UTF-8 for `POST` and `PUT` requests.
   - Ensured JSON body is sent correctly when posting or updating a `Todo`.

5. **lib/domain/models/todo.dart**:
   - Added `description` and `done` fields to `Todo` model.
   - Updated `toMap`, `fromMap`, `copyWith`, and constructors to handle the new fields.

6. **lib/ui/todo/components/add_todo_dialog.dart**:
   - Added `descriptionController` for capturing task descriptions.
   - Included a new `TextFormField` for description input with validation.
   - Updated todo creation to include both `name` and `description`.

7. **lib/ui/todo/components/list_tile_todo.dart**:
   - Added support for `done` checkbox to mark task completion.
   - Displayed `description` below the title if available.
   - Included `onDoneTodo` callback for updating task status.

8. **lib/ui/todo/components/todo_list_view.dart**:
   - Added `onDoneTodo` callback and passed it to `ListTileTodo`.

9. **lib/ui/todo/todo_screen.dart**:
   - Defined `OnDoneTodo` typedef.
   - Added `_onDoneTodo` method to handle task completion updates.
   - Passed `onDoneTodo` to `ListViewTodos`.

10. **lib/ui/todo/view_models/todo_view_model.dart**:
    - Updated `addTodo` to use `Command1<Todo, Todo>`.
    - Added `updateTodo` command for updating task state.
    - Simplified `_addTodo`, `_deleteTodo`, and `_load` methods to rely on repository logic and notify listeners.
    - Exposed repository's `todosMap` and `todos`.

11. **server/db.json**:
    - Updated mock data to include `description` and `done` fields.

12. **test/data/services/api/api_client_test.dart**:
    - Updated all test cases to use `Todo` with `description`.

13. **test/ui/todo/viewmodels/todo_viewmodel_test.dart**:
    - Updated test cases to use the new `Todo` constructor with `description`.

### Conclusion:

These changes enhance the flexibility and completeness of the Todo feature by supporting task descriptions, completion tracking, and a more robust ViewModel-repository architecture. The system is now better equipped to handle full-featured Todo entries across the UI, backend, and tests.


## 2025/03/23 - version: 0.5.00+01

This commit introduces several structural and functional improvements to the application, focusing on modularity, code reuse, and enhanced readability.

### Changes made:

1. **Makefile**:
   - Added `diff`, `push`, and `push_branch` targets to streamline Git workflows.
   - The `diff` rule adds and stages changes, saves a diff to `~/diff`, and prints the line count.

2. **analysis_options.yaml**:
   - Enabled the lint rule `prefer_const_literals_to_create_immutables` to enforce better performance and immutability.

3. **lib/routing/router.dart**:
   - Refactored the router configuration to reuse a single instance of `TodosRepository`.
   - Simplified the `TodoDetailsViewModel` creation and initialization, improving efficiency and separation of concerns.

4. **lib/ui/todo_details/components/todo_edit.dart**:
   - Created a new reusable component `TodoEdit` to display `Todo` items consistently with better styling.

5. **lib/ui/todo_details/todo_details_screen.dart**:
   - Removed `id` from the widget constructor, relying on the view model for state.
   - Integrated the new `TodoEdit` component to display todo details, improving modularity.

6. **lib/ui/todo_details/view_models/todo_details_view_model.dart**:
   - Refactored `TodoDetailsViewModel` to remove dependency on constructor-passed `id`.
   - Switched from `Command0` to `Command1<Todo, String>` for the `load` command, making it more reusable.
   - Improved state encapsulation by introducing a private `_todo` field and public getter.

7. **server/db.json**:
   - Removed outdated or redundant sample data entries to clean up the development database.

### Conclusion:

These changes significantly improve code maintainability and structure by adopting best practices in widget modularization, view model design, and command pattern usage. The `TodoDetailsViewModel` is now more flexible, and the routing setup avoids unnecessary redundancy by reusing repository instances.