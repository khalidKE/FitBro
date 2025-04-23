import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../consts/Collections.dart';
import '../../../UserModel/User_Model.dart';
import '../../../data/Local/SharedKeys.dart';
import '../../../data/Local/SharedPerfrence.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  // Sign-up form properties
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  late final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();

  // Sign-in form properties
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();

  UserModel? user;
  String currentUid = "";

  Future<void> signUpWithFire() async {
    emit(AuthLoading());
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signUpEmailController.text.trim(),
            password: signUpPasswordController.text.trim(),
          );
      await addUserToFireStore(userCredential);
      emit(AuthSuccess(userCredential.user!));
    } catch (error) {
      emit(AuthError(error.toString()));
      rethrow;
    }
  }

  Future<void> signInWithFire() async {
    emit(AuthLoading());
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: signInEmailController.text.trim(),
            password: signInPasswordController.text.trim(),
          );
      storeDataFirebase(userCredential);
      emit(AuthSuccess(userCredential.user!));
    } catch (error) {
      emit(AuthError(error.toString()));
      rethrow;
    }
  }

  Future<void> addUserToFireStore(UserCredential userCredential) async {
    final user = userCredential.user;
    if (user == null) {
      throw Exception("User is null. Unable to add to Firestore.");
    }
    final uid = user.uid;
    currentUid = uid;
    await FirebaseFirestore.instance.collection(Collections.users).doc(uid).set(
      {"Email": user.email ?? '', "uid": uid},
      SetOptions(merge: true),
    );
    storeDataFirebase(userCredential);
  }

  void storeDataFirebase(UserCredential value) {
    debugPrint("Using StoreDataFirebase");
    LocalData.setData(key: SharedKey.uid, value: value.user?.uid);
    LocalData.setData(key: SharedKey.email, value: value.user?.email);
    LocalData.setData(key: SharedKey.isLogin, value: true);
  }

  Future<void> getUserInfoFire() async {
    emit(GetUserInfoLoading());
    try {
      final uid = LocalData.getData(key: SharedKey.uid);
      if (uid == null) {
        emit(GetUserInfoError('No user ID found'));
        return;
      }
      final doc =
          await FirebaseFirestore.instance
              .collection(Collections.users)
              .doc(uid)
              .get();
      if (doc.exists) {
        user = UserModel(email: doc.get('Email'));
        emit(GetUserInfoSuccess());
      } else {
        emit(GetUserInfoError('User data not found'));
      }
    } catch (e) {
      emit(GetUserInfoError('Failed to fetch user info: $e'));
    }
  }

  Future<void> signOut() async {
    emit(SignOutLoading());
    try {
      await FirebaseAuth.instance.signOut();
      LocalData.clearData();
      emit(SignOutSuccess());
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  String mapFirebaseError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address';
    } else if (error.contains('user-not-found') ||
        error.contains('wrong-password')) {
      return 'Invalid email or password';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else {
      return 'An error occurred: $error';
    }
  }

  void clearControllers() {
    signUpEmailController.clear();
    signUpPasswordController.clear();
    signUpConfirmPasswordController.clear();
    signInEmailController.clear();
    signInPasswordController.clear();
  }

  @override
  Future<void> close() {
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    signInEmailController.dispose();
    signInPasswordController.dispose();
    return super.close();
  }
}
