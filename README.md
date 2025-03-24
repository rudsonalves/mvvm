# mvvm

A new Flutter project.

# Changelog

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