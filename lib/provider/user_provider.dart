import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/user.dart';

class UserProvider extends StateNotifier<User?> {
  // constructor initializes the state with a User object
  // Purpose: To manage the state of the user in the application

  UserProvider()
      : super(User(
          id: '',
          fullName: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          password: '',
          token: '',
        ));

  // Getter method to extract the value from an Object

  User? get user => state;

  // method to set user state from Json
// Purpose: To update the user state with a new User object
  void setUser(Map<String, dynamic> userJson) {
    state = User.fromJson(userJson);
  }

  // method to clear the user state
  // Purpose: To reset the user state to null
  void signOut() {
    state = null;
  }

  // method to recreate the user state to update user state
  void recreateUserState({
    required String state,
    required String city,
    required String locality,
  }) {
    if (this.state != null) {
      this.state = User(
        id: this.state!.id,
        fullName: this.state!.fullName,
        email: this.state!.email,
        state: state,
        city: city,
        locality: locality,
        password: this.state!.password,
        token: this.state!.token,
      );
    }
  }
}

// make the data accessible within the app
final userProvider =
    StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
