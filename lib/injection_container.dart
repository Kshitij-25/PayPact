import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'data/datasources/auth_datasource.dart';
import 'data/datasources/expense_datasource.dart';
import 'data/datasources/friend_remote_datasource.dart';
import 'data/datasources/group_remote_datasource.dart';
import 'data/datasources/user_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'data/repositories/friend_repository_impl.dart';
import 'data/repositories/group_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/expense_repository.dart';
import 'domain/repositories/friend_repository.dart';
import 'domain/repositories/group_repository.dart';
import 'domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  await Firebase.initializeApp();
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => GoogleSignIn.instance);

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt(), getIt()));
  getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<FriendRemoteDataSource>(() => FriendRemoteDataSourceImpl(getIt(), getIt()));
  getIt.registerLazySingleton<GroupRemoteDataSource>(() => GroupRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<ExpenseRemoteDataSource>(() => ExpenseRemoteDataSourceImpl(getIt()));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));
  getIt.registerLazySingleton<FriendRepository>(() => FriendRepositoryImpl(getIt()));
  getIt.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(getIt()));
  getIt.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(getIt()));
}
