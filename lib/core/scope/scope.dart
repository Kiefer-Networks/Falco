// SPDX-License-Identifier: GPL-3.0-or-later
/// Account, Project and Scope. A resource is addressed by
/// `Scope + type + id`; there is no implicit active project (BUG-007).
library;

import 'package:flutter/foundation.dart';

/// A Cloud project of an account. Its API token lives in the SecretStore.
@immutable
class Project {
  /// Creates a project.
  const new({required this.id, required this.name});

  /// Parses [toJson] output.
  factory fromJson(Map<String, Object?> json) =>
      Project(id: json['id']! as String, name: json['name']! as String);

  /// Local id, stable across renames.
  final String id;

  /// Name chosen by the user.
  final String name;

  /// JSON without secrets.
  Map<String, Object?> toJson() => {'id': id, 'name': name};

  @override
  bool operator ==(Object other) =>
      other is Project && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}

/// An account groups Cloud projects and an optional Robot access.
@immutable
class Account {
  /// Creates an account.
  const new({
    required this.id,
    required this.name,
    this.description = '',
    this.projects = const [],
    this.hasRobot = false,
  });

  /// Parses [toJson] output.
  factory fromJson(Map<String, Object?> json) => Account(
    id: json['id']! as String,
    name: json['name']! as String,
    description: json['description'] as String? ?? '',
    hasRobot: json['hasRobot'] as bool? ?? false,
    projects: [
      for (final p in json['projects']! as List)
        Project.fromJson((p! as Map).cast<String, Object?>()),
    ],
  );

  /// Local id.
  final String id;

  /// Name chosen by the user.
  final String name;

  /// Optional note chosen by the user (ONB-021).
  final String description;

  /// Cloud projects in display order.
  final List<Project> projects;

  /// Whether Robot credentials are stored for this account.
  final bool hasRobot;

  /// Copy with changed fields.
  Account copyWith({
    String? name,
    String? description,
    List<Project>? projects,
    bool? hasRobot,
  }) => Account(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    projects: projects ?? this.projects,
    hasRobot: hasRobot ?? this.hasRobot,
  );

  /// JSON without secrets.
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'hasRobot': hasRobot,
    'projects': [for (final p in projects) p.toJson()],
  };

  @override
  bool operator ==(Object other) =>
      other is Account &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.hasRobot == hasRobot &&
      listEquals(other.projects, projects);

  @override
  int get hashCode =>
      Object.hash(id, name, description, hasRobot, Object.hashAll(projects));
}

/// What a screen shows: one project, all projects, or Robot of an account.
@immutable
sealed class Scope {
  const new(this.accountId);

  /// The account the scope belongs to.
  final String accountId;
}

/// A single Cloud project.
final class ProjectScope extends Scope {
  /// Creates the scope.
  const new(super.accountId, this.projectId);

  /// The project.
  final String projectId;

  @override
  bool operator ==(Object other) =>
      other is ProjectScope &&
      other.accountId == accountId &&
      other.projectId == projectId;

  @override
  int get hashCode => Object.hash(accountId, projectId);
}

/// "All projects" of an account; each list row carries its project.
final class AllProjectsScope extends Scope {
  /// Creates the scope.
  const new(super.accountId);

  @override
  bool operator ==(Object other) =>
      other is AllProjectsScope && other.accountId == accountId;

  @override
  int get hashCode => Object.hash(AllProjectsScope, accountId);
}

/// The Robot webservice of an account.
final class RobotScope extends Scope {
  /// Creates the scope.
  const new(super.accountId);

  @override
  bool operator ==(Object other) =>
      other is RobotScope && other.accountId == accountId;

  @override
  int get hashCode => Object.hash(RobotScope, accountId);
}
