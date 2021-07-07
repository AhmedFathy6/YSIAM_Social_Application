import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:social_app/models/comment_post_model.dart';
import 'package:social_app/models/like_post_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notifactions/notify.dart' as notifyPage;
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/feeds/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/firebase/manage_firestore.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import '../network/local/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

//#region Variables
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  double openDrawer = 0;
  DioHelper dio = DioHelper();
  UserModel currentUser = UserModel.emptyObject();
  File? imageProfile;
  File? imageCover;
  String lang = CacheHelper.getData(key: 'lang') == null
      ? 'en'
      : CacheHelper.getData(key: 'lang');
  bool isDark = CacheHelper.getData(key: 'isDark') == null
      ? false
      : CacheHelper.getData(key: 'isDark');

  List<File> postImages = [];
  List<PostModel> currentUserPosts = [];
  List<PostModel> userPosts = [];
  List<PostModel> allPosts = [];
  List<UserModel> users = [];
  List<MessageModel> messages = [];
  List<Map<Widget, String>> screens = [
    {FeedsScreen(): 'News Feed'},
    {ChatsScreen(): 'Chats'},
    {NewPostScreen(): 'New Post'},
    {UsersScreen(): 'Friends'},
    {SettingsScreen(): 'Settings'},
  ];

//#end region

  //#region Home
  void changeBottomNav(int index) {
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavParState());
      if (index == 4) getUserPostsData(userId!, true);
      if (index == 1 || index == 3) getUsersData();
    }
  }

  void changeOpenDrawer(double index) {
    openDrawer = index;
    emit(ChangeBottomNavParState());
  }

  void changeTheme(bool value) {
    isDark = value;
    CacheHelper.saveData(key: 'isDark', value: isDark).then(
      (value) => emit(ChangeThemeState()),
    );
  }

  void changeLanguage(String value, BuildContext context) {
    lang = value;
    CacheHelper.saveData(key: 'lang', value: lang).then(
      (value) {
        Get.updateLocale(Locale(lang));
        emit(ChangeLanguageState());
      },
    );
  }

  //#end region Home

//#region User
  void getUserData() {
    if (userId != null) {
      imageProfile = null;
      imageCover = null;

      emit(LoadingState());
      ManageFireStore.get(collection: 'users', document: userId!).then(
        (value) {
          currentUser = UserModel.fromJson(value.data()!);
          currentUser.token = token!;
          emit(GetUserSuccessState());
        },
      ).onError(
        (error, stackTrace) {
          print(error);
          print(stackTrace);
          emit(GetUserErrorState(
            error: error.toString(),
          ));
        },
      );
    }
  }

  void getUsersData() {
    if (userId != null && users.isEmpty) {
      emit(LoadingGetUsersState());
      ManageFireStore.getListWithoutWhere(
        collection: 'users',
      ).then(
        (value) {
          users = UserModel.getList(value.docs);
          emit(GetUsersSuccessState());
        },
      ).onError(
        (error, stackTrace) {
          print(error);
          print(stackTrace);
          emit(GetUsersErrorState(
            error: error.toString(),
          ));
        },
      );
    }
  }

  void getProfileImage() async {
    Component.getImageAsBytes().then((value) {
      imageProfile = value.values.elementAt(0);
      emit(GetImageProfileSuccessState());
    }).onError((error, stackTrace) {
      print(error.toString());
      print(stackTrace.toString());
      emit(GetImageProfileErrorState(error: error.toString()));
    });
  }

  void getCoverImage() async {
    Component.getImageAsBytes().then((value) {
      imageCover = value.values.elementAt(0);
      emit(GetImageCoverSuccessState());
    }).onError((error, stackTrace) {
      print(error.toString());
      print(stackTrace.toString());
      emit(GetImageCoverErrorState(error: error.toString()));
    });
  }

  Future<void> uploadProfileImage(
      {required UserModel user, bool doNotUpdate = false}) async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(imageProfile!.path).pathSegments.last}')
        .putFile(imageProfile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        user.image = value;
        if (!doNotUpdate) updateData(user: user);
      });
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }

  void uploadCoverImage({required UserModel user, bool doNotUpdate = false}) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(imageCover!.path).pathSegments.last}')
        .putFile(imageCover!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        user.coverImage = value;
        if (!doNotUpdate) updateData(user: user);
      });
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }

  Future<void> uploadImages({required UserModel user}) async {
    if (imageProfile == null && imageCover == null) {
      updateData(user: user);
    }
    if (imageProfile != null && imageCover != null) {
      uploadProfileImage(user: user, doNotUpdate: true)
          .then((value) => uploadCoverImage(user: user, doNotUpdate: false));
    } else {
      if (imageProfile != null) {
        uploadProfileImage(user: user);
      }
      if (imageCover != null) {
        uploadCoverImage(user: user);
      }
    }
  }

  void updateUserData({required UserModel user}) {
    if (userId != null) {
      emit(LoadingUpdateState());
      uploadImages(user: user);
    }
  }

  void updateData({required UserModel user}) {
    user.token = token!;
    ManageFireStore.update(
      collection: 'users',
      document: userId!,
      data: user.toJson(),
    ).then(
      (value) {
        getUserData();
        emit(UpdateUserSuccessState());
      },
    ).onError(
      (error, stackTrace) {
        print(error);
        print(stackTrace);
        emit(UpdateUserErrorState(
          error: error.toString(),
        ));
      },
    );
  }

  void updateToken() {
    if (token != null)
      ManageFireStore.update(
        collection: 'users',
        document: userId!,
        data: {'token': token!},
      ).then(
        (value) {
          emit(UpdateUserTokenSuccessState());
        },
      ).onError(
        (error, stackTrace) {
          print(error);
          print(stackTrace);
          emit(UpdateUserTokenErrorState(error: error.toString()));
        },
      );
  }

  //#end region User

  //#region Post
  void addImages(File image) {
    postImages.add(image);
    emit(AddImagesState());
  }

  void clearImages() {
    postImages.clear();
    emit(ClearImagesState());
  }

  void removePostImage(File item) {
    postImages.remove(item);
    emit(RemoveImagesState());
  }

  Future<void> uploadPostImages({required PostModel post}) async {
    for (var i = postImages.length - 1; i >= 0; i--) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              'posts/${Uri.file(postImages.elementAt(i).path).pathSegments.last}')
          .putFile(postImages.elementAt(i))
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          post.postImages.add(value);

          if (postImages.last == postImages.elementAt(i)) {
            removePostImage(postImages.elementAt(i));
            createPost(post: post);
            getAllPostsData();
          } else {
            removePostImage(postImages.elementAt(i));
            updatePost(post: post);
            getAllPostsData();
          }
        });
      }).onError((error, stackTrace) {
        print(error);
        print(stackTrace);
      });
    }
    postImages.forEach((element) {});
  }

  Future<void> uploadPost({required PostModel post}) async {
    if (userId != null) {
      emit(LoadingCreatePostState());
      if (postImages.isNotEmpty) {
        uploadPostImages(post: post);
      } else {
        createPost(post: post);
      }
    }
  }

  void createPost({required PostModel post}) {
    ManageFireStore.set(
      collection: 'posts',
      document: post.id,
      data: post.toJson(),
    ).then(
      (value) {
        emit(CreatePostSuccessState());
        users.where((element) => element.userId != userId).forEach((element) {
          sendNotification(
              token: element.token,
              body: post.postText,
              title: 'new post from ${currentUser.name}');
        });
        getAllPostsData();
        getUserPostsData(userId!, true);
      },
    ).onError(
      (error, stackTrace) {
        print(error);
        print(stackTrace);
        emit(CreatePostErrorState(
          error: error.toString(),
        ));
      },
    );
  }

  void updatePost({required PostModel post}) {
    if (userId != null) {
      emit(LoadingCreatePostState());
      ManageFireStore.update(
        collection: 'posts',
        document: post.id,
        data: post.toJson(),
      ).then(
        (value) {
          emit(UpdatePostSuccessState());
        },
      ).onError(
        (error, stackTrace) {
          print(error);
          print(stackTrace);
          emit(UpdatePostErrorState(
            error: error.toString(),
          ));
        },
      );
    }
  }

  void getUserPostsData(String? userId, bool isCurrentUser) {
    if (userId != null) {
      emit(LoadingGetUserPostsState());
      ManageFireStore.getListWithWhere(
              collection: 'posts',
              document: userId,
              orderBy: 'creationDate',
              descending: true)
          .then(
        (value) {
          if (isCurrentUser) {
            currentUserPosts = PostModel.getList(value.docs);
            currentUserPosts.forEach(
              (element) {
                getLikes(
                    element: value.docs[currentUserPosts.indexOf(element)],
                    post: element);
                getComments(
                    element: value.docs[currentUserPosts.indexOf(element)],
                    post: element);
              },
            );
          } else {
            userPosts = PostModel.getList(value.docs);
            userPosts.forEach((element) {
              getLikes(
                  element: value.docs[userPosts.indexOf(element)],
                  post: element);
              getComments(
                  element: value.docs[userPosts.indexOf(element)],
                  post: element);
            });
          }
          emit(GetPostsSuccessState());
        },
      ).onError(
        (error, stackTrace) {
          print(error);
          print(stackTrace);
          emit(GetPostsErrorState(
            error: error.toString(),
          ));
        },
      );
    }
  }

  void deletePost(PostModel post) {
    if (userId != null) {
      emit(LoadingGetPostsState());
      ManageFireStore.delete(
        collection: 'posts',
        document: post.id,
      ).then(
        (value) {
          print(value);
          if (allPosts.contains(post)) allPosts.remove(post);
          if (userPosts.contains(post)) userPosts.remove(post);
          getUserPostsData(userId!, true);
          emit(DeletePostSuccessState());
          deleteImages(post: post, source: 'posts');
        },
      ).onError(
        (error, stackTrace) {
          print(error);
          print(stackTrace);
          emit(DeleteErrorState(
            error: error.toString(),
          ));
        },
      );
    }
  }

  void getAllPostsData() {
    if (userId != null) {
      emit(LoadingGetPostsState());
      ManageFireStore.getListWithoutWhere(
        collection: 'posts',
        descending: true,
        orderBy: 'creationDate',
      ).then(
        (value) {
          allPosts = PostModel.getList(value.docs);
          allPosts.forEach(
            (element) {
              getLikes(
                  element: value.docs[allPosts.indexOf(element)],
                  post: element);
              getComments(
                  element: value.docs[allPosts.indexOf(element)],
                  post: element);
            },
          );
          emit(GetPostsSuccessState());
        },
      ).onError(
        (error, stackTrace) {
          print(error);
          print(stackTrace);
          emit(GetPostsErrorState(
            error: error.toString(),
          ));
        },
      );
    }
  }

  void deleteImages({required PostModel post, required String source}) {
    post.postImages.forEach((element) {
      firebase_storage.FirebaseStorage.instance
          .refFromURL(element)
          .delete()
          .then((_) => print('Successfully deleted $element storage item'));
    });
  }

  //#end region Post

  //#region Likes
  void likePosts({required PostModel post}) {
    if (userId != null) {
      LikePostModel like;
      if (post.likes.where((element) => element.userId == userId!).isNotEmpty) {
        like = post.likes.where((element) => element.userId == userId!).first;
        like.like = !like.like;
        post.likes.remove(like);
      } else {
        like = LikePostModel(userId: userId!, like: true);
        post.likes.add(like);
      }

      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('likes')
          .doc(userId!)
          .set(like.toJson())
          .then((value) {
        emit(SetLikePostSuccessState());
      }).onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        emit(SetLikePostErrorState(error: error.toString()));
      });
    }
  }

  void getLikes({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required PostModel post,
  }) {
    element.reference.collection('likes').get().then((value) {
      value.docs.forEach((v) {
        post.likes.add(LikePostModel.fromJson(v.data()));
      });
      emit(GetLikesPostSuccessState());
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(GetLikesPostErrorState(error: error.toString()));
    });
  }

  //#end region Likes

  //#region Comment
  void commentPost({required PostModel post, required String commentText}) {
    if (userId != null) {
      CommentPostModel comment;
      comment = CommentPostModel(userId: userId!, comment: commentText);
      post.comments.add(comment);

      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('comments')
          .doc(comment.id)
          .set(comment.toJson())
          .then((value) {
        emit(SetCommentPostSuccessState());
        sendNotificationFromComments(post: post, body: commentText);
      }).onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        emit(SetCommentPostErrorState(error: error.toString()));
      });
    }
  }

  void getComments({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required PostModel post,
  }) {
    element.reference.collection('comments').get().then((value) {
      value.docs.forEach((v) {
        post.comments.add(CommentPostModel.fromJson(v.data()));
      });
      emit(GetCommentsPostSuccessState());
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(GetCommentsPostErrorState(error: error.toString()));
    });
  }

  void getCommentsToPost({
    required PostModel post,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('comments')
        .get()
        .then((value) {
      post.comments.clear();
      value.docs.forEach((v) {
        post.comments.add(CommentPostModel.fromJson(v.data()));
      });
      emit(GetCommentsPostSuccessState());
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(GetCommentsPostErrorState(error: error.toString()));
    });
  }

  void deleteComment(PostModel post, CommentPostModel comment) {
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('comments')
          .doc(comment.id)
          .delete()
          .then(
        (value) {
          post.comments.remove(comment);
          emit(DeleteCommentSuccessState());
        },
      ).onError(
        (error, stackTrace) {
          print(error);
          print(stackTrace);
          emit(DeleteCommentErrorState(
            error: error.toString(),
          ));
        },
      );
    }
  }

  void sendNotificationFromComments(
      {required String body, required PostModel post}) {
    sendNotification(
      token:
          users.where((element) => post.userId == element.userId).first.token,
      title: 'new comment from ${currentUser.name}',
      body: body,
      type: 'post',
    );

    post.comments.forEach(
      (element) {
        if (element.userId != userId)
          sendNotification(
            token: users
                .where((element) => post.comments
                    .where((e) => e.userId == element.userId)
                    .isNotEmpty)
                .first
                .token,
            title: 'new comment from ${currentUser.name}',
            body: body,
            type: 'post',
          );
      },
    );
  }

  //#end region Comments

  //#end region Messages
  void sendMessage(
      {required MessageModel message, required UserModel receiverUser}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId!)
        .collection('chats')
        .doc(message.receiverId)
        .collection('messages')
        .add(message.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
      sendNotificationFromMessenger(user: receiverUser, body: message.text);
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(SendMessageErrorState(error: error.toString()));
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(message.receiverId)
        .collection('chats')
        .doc(userId!)
        .collection('messages')
        .add(message.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(SendMessageErrorState(error: error.toString()));
    });
  }

  void getMessages({required receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId!)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .snapshots()
        .listen((event) {
      messages = MessageModel.getList(event.docs);
      sortMessages();
      emit(GetMessagesSuccessState());
    });
  }

  void sortMessages() {
    messages.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    emit(SortMessagesSuccessState());
  }

  void sendNotificationFromMessenger(
      {required UserModel user, required String body}) {
    sendNotification(
      token: user.token,
      title: 'new message from ${currentUser.name}',
      body: body,
    );
  }

//#end region Messages

//#start region Send Notification
  void sendNotification(
      {required String token,
      required String body,
      required String title,
      String type = 'user'}) {
    notifyPage.Notify notify = notifyPage.Notify(
      to: token,
      android: notifyPage.Android(),
      data: notifyPage.Data(
        type: type,
        user: currentUser,
      ),
      notification: notifyPage.Notification(
        title: title,
        body: body,
        image: currentUser.image,
      ),
    );
    notify.sendNotification();
  }
//#end region Send Notification
}
