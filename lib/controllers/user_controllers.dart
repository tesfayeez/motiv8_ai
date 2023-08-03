import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:motiv8_ai/api/user_api.dart';
import 'package:motiv8_ai/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userControllerProvider =
    StateNotifierProvider<UserController, UserModel>((ref) {
  return UserController(userAPI: ref.watch(userApiProvider));
});

// final currentUserModelProvider = StreamProvider<UserModel?>((ref) {
//   final userApi = ref.watch(userApiProvider);
//   final currentUser = ref.watch(currentUserProvider);

//   if (currentUser != null) {
//     return userApi.getUser(currentUser.uid);
//   } else {
//     return Stream.value(null);
//   }
// });
final currentUserModelProvider =
    StreamProvider.family<UserModel?, User>((ref, user) {
  final userApi = ref.watch(userApiProvider);
  if (user != null) {
    return userApi.getUser(user.uid);
  } else {
    return Stream.value(null);
  }
});

class UserController extends StateNotifier<UserModel> {
  final UserAPI _userAPI;

  UserController({required UserAPI userAPI})
      : _userAPI = userAPI,
        super(UserModel
            .empty()); // You need to define an empty constructor for UserModel
  Future<void> saveUserIdToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final existingUserId = prefs.getString('userId');

    if (existingUserId == null) {
      prefs.setString('userId', userId);
    }
  }

  Future<String?> loadUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(
        'userId'); // Will return null if 'userId' is not in the preferences
  }

  Future<void> createUser(UserModel user) async {
    final result = await _userAPI.createUser(user);
    result.fold(
      (l) {
        print(l.stackTrace.toString());
        // Handle error here
      },
      (r) {
        state = r; // Update the state with the created user
        print("User created succesfully");
        saveUserIdToPrefs(user.id);
      },
    );
  }

  Future<void> deleteUser(String userId) async {
    final result = await _userAPI.deleteUser(userId);
    result.fold(
      (l) {
        print(l.stackTrace.toString());
        // Handle error here
      },
      (r) {
        state = UserModel.empty(); // Reset the state to an empty user
        print("User deleted succesfully");
      },
    );
  }

  Future<void> updateUserSettings(UserSettings updatedSettings) async {
    UserModel? updatedUser;

    if (state == UserModel.empty()) {
      print("its coming here at state == UserModel.empty()");
      final userId = await loadUserIdFromPrefs();
      if (userId != null && userId.isNotEmpty) {
        print("its coming here at userId != null && userId.isNotEmpty");
        final userResult = await getUser(userId);
        userResult.fold(
          (l) {
            print(l.toString());
            // Handle error here
          },
          (r) {
            updatedUser = r;
            print("User fetched successfully");
          },
        );
      } else {
        print("No user ID found in shared preferences");
        return;
      }
    } else {
      updatedUser = state;
    }

    if (updatedUser != null) {
      updatedUser = updatedUser!.copyWith(userSettings: updatedSettings);
      print(updatedUser.toString());

      final result = await _userAPI.updateUser(updatedUser!);
      result.fold(
        (l) {
          print(l.stackTrace.toString());
          // Handle error here
        },
        (r) {
          state =
              updatedUser!; // Update the state with the updated user settings
          print("User settings updated succesfully");
        },
      );
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    final result = await _userAPI.updateUser(updatedUser);
    result.fold(
      (l) {
        print(l.stackTrace.toString());
        // Handle error here
      },
      (r) {
        state = updatedUser; // Update the state with the updated user
        print("User updated succesfully");
      },
    );
  }

  Future<Either<Exception, UserModel>> getUser(String uid) async {
    try {
      final userStream = _userAPI.getUser(uid);
      final user = await userStream.first; // Get the first user from the stream
      state = user; // Update the state with the fetched user
      print(
          "motivationalQuoteEndTime ${user.userSettings?.motivationalQuoteEndTime}");
      print("User fetched successfully");
      return right(user); // Return the user as a Right value
    } catch (e) {
      print(e.toString());
      // Handle error here
      return left(Exception(e.toString())); // Return the error as a Left value
    }
  }
}
