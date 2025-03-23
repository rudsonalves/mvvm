# mvvm

A new Flutter project.

# Changelog

## 2025/03/23 - version: 0.5.0+01

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