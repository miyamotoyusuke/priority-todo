// Common imports for the app

// Flutter
export 'package:flutter/material.dart';

// Firebase
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'firebase_options.dart';

// Security
export 'package:flutter_dotenv/flutter_dotenv.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Riverpod
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
export 'model/todo.dart';
export 'model/goal.dart';

// Utils
export 'core/utils/priority_utils.dart';

// Theme
export 'ui_core/theme/app_theme.dart';

// Common widgets
export 'component/dialog/confirmation_dialog.dart';
export 'component/todo/todo_list.dart';
export 'component/todo/todo_item.dart';
export 'component/goal/goal_list.dart';
export 'component/goal/goal_item.dart';

// Providers
export 'provider/todo_provider.dart';
export 'provider/goal_provider.dart';
export 'view_model/home_view_model.dart';
