// import 'package:demoecommerceproduct/models/user.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';

// class UserService {
//   static UserService? _instance;
//   static Isar? _isar;

//   UserService._();

//   static UserService get instance {
//     _instance ??= UserService._();
//     return _instance!;
//   }

//   // Future<Isar> get isar async {
//   //   if (_isar != null) return _isar!;

//   //   final dir = await getApplicationDocumentsDirectory();
//   //   _isar = await Isar.open(
//   //     [UserSchema],
//   //     directory: dir.path,
//   //     name: 'user_db',
//   //   );

//   //   return _isar!;
//   // }

//   // Save user data (replaces existing user if any)
//   Future<void> saveUser(User user) async {
//     final db = await isar;
    
//     await db.writeTxn(() async {
//       // Clear existing user data first (since we only want one user at a time)
//       await db.users.clear();
//       // Save the new user
//       await db.users.put(user);
//     });
//   }

//   // Get current user
//   Future<User?> getCurrentUser() async {
//     final db = await isar;
//     return await db.users.where().findFirst();
//   }

//   // Check if user is logged in and token is not expired
//   Future<bool> isUserLoggedIn() async {
//     final user = await getCurrentUser();
//     if (user == null) return false;
    
//     // Check if token is still valid
//     return DateTime.now().isBefore(user.expiresAt);
//   }

//   // Get user token if valid
//   Future<String?> getValidToken() async {
//     final user = await getCurrentUser();
//     if (user == null) return null;
    
//     // Check if token is still valid
//     if (DateTime.now().isBefore(user.expiresAt)) {
//       return user.token;
//     }
    
//     return null;
//   }

//   // Clear user data (logout)
//   Future<void> clearUser() async {
//     final db = await isar;
    
//     await db.writeTxn(() async {
//       await db.users.clear();
//     });
//   }

//   // Update user information
//   Future<void> updateUser(User updatedUser) async {
//     final db = await isar;
    
//     await db.writeTxn(() async {
//       await db.users.put(updatedUser);
//     });
//   }

//   // Get user by userId
//   Future<User?> getUserById(String userId) async {
//     final db = await isar;
//     return await db.users
//         .filter()
//         .userIdEqualTo(userId)
//         .findFirst();
//   }

//   // Check if token is about to expire (within next hour)
//   Future<bool> isTokenNearExpiry() async {
//     final user = await getCurrentUser();
//     if (user == null) return true;
    
//     final oneHourFromNow = DateTime.now().add(const Duration(hours: 1));
//     return user.expiresAt.isBefore(oneHourFromNow);
//   }

//   // Get user as stream for real-time updates
//   Stream<User?> watchCurrentUser() async* {
//     final db = await isar;
//     yield* db.users
//         .where()
//         .watch(fireImmediately: true)
//         .map((users) => users.isEmpty ? null : users.first);
//   }
// }