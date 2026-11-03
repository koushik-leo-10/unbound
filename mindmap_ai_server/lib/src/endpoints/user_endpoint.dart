import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Handles user authentication, registration, session checks, and dashboard metrics.
class UserEndpoint extends Endpoint {
  /// Registers a new user account with hashed password stored in PostgreSQL.
  Future<AuthResponse> register(
    Session session,
    String name,
    String email,
    String password,
  ) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanName.length < 2) {
      throw AppException(message: 'Please provide a valid name (at least 2 characters).');
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(cleanEmail)) {
      throw AppException(message: 'Please enter a valid email address.');
    }
    if (cleanPassword.length < 6) {
      throw AppException(message: 'Password must be at least 6 characters long.');
    }

    // Check if email already exists
    final existing = await UserAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );
    if (existing != null) {
      throw AppException(message: 'An account with this email already exists. Please sign in.');
    }

    // Generate random salt and hash password
    final salt = _generateSalt();
    final passwordHash = _hashPassword(cleanPassword, salt);
    final now = DateTime.now();

    final user = await UserAccount.db.insertRow(
      session,
      UserAccount(
        name: cleanName,
        email: cleanEmail,
        passwordHash: passwordHash,
        salt: salt,
        createdAt: now,
        lastLoginAt: now,
      ),
    );

    // Generate lightweight session token
    final token = _hashPassword('${user.id}:$cleanEmail:$now', salt);

    return AuthResponse(
      success: true,
      message: 'Account created successfully!',
      token: token,
      user: user,
    );
  }

  /// Authenticates an existing user against database credentials.
  Future<AuthResponse> login(
    Session session,
    String email,
    String password,
  ) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      throw AppException(message: 'Email and password are required.');
    }

    final user = await UserAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );

    if (user == null) {
      throw AppException(message: 'Invalid email or password.');
    }

    final computedHash = _hashPassword(cleanPassword, user.salt);
    if (computedHash != user.passwordHash) {
      throw AppException(message: 'Invalid email or password.');
    }

    // Update last login timestamp
    user.lastLoginAt = DateTime.now();
    await UserAccount.db.updateRow(session, user);

    final token = _hashPassword('${user.id}:$cleanEmail:${user.lastLoginAt}', user.salt);

    return AuthResponse(
      success: true,
      message: 'Welcome back, ${user.name}!',
      token: token,
      user: user,
    );
  }

  /// Returns aggregated statistics for the interactive dashboard.
  Future<DashboardStats> getDashboardStats(Session session) async {
    final now = DateTime.now();
    final allNotes = await Note.db.find(session);
    final allTasks = await Task.db.find(session);

    final totalNotes = allNotes.length;
    final notesWithSummaries = allNotes.where((n) => n.summary != null && n.summary!.trim().isNotEmpty).length;
    final totalTasks = allTasks.length;
    final pendingTasks = allTasks.where((t) => t.status == TaskStatus.pending).length;
    final completedTasks = allTasks.where((t) => t.status == TaskStatus.completed).length;
    final overdueTasks = allTasks.where((t) => t.status == TaskStatus.pending && t.dueAt != null && t.dueAt!.isBefore(now)).length;

    return DashboardStats(
      totalNotes: totalNotes,
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      overdueTasks: overdueTasks,
      totalTasks: totalTasks,
      notesWithSummaries: notesWithSummaries,
    );
  }

  /// Retrieves user profile by ID.
  Future<UserAccount?> getProfile(Session session, int userId) async {
    return UserAccount.db.findById(session, userId);
  }

  static String _generateSalt([int length = 32]) {
    final rand = Random.secure();
    final values = List<int>.generate(length, (i) => rand.nextInt(256));
    return base64Url.encode(values);
  }

  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt:$password');
    return sha256.convert(bytes).toString();
  }
}
