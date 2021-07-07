abstract class AppStates {}

class InitialState extends AppStates {}

class ChangeBottomNavParState extends AppStates {}

class SocialNewPostState extends AppStates {}

class LoadingState extends AppStates {}

class LoadingGetPostsState extends AppStates {}

class LoadingGetUserPostsState extends AppStates {}

class LoadingGetUsersState extends AppStates {}

class LoadingUpdateState extends AppStates {}

class LoadingCreatePostState extends AppStates {}

class AddImagesState extends AppStates {}

class ClearImagesState extends AppStates {}

class RemoveImagesState extends AppStates {}

class ChangeThemeState extends AppStates {}

class ChangeLanguageState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {
  final String error;
  GetUserErrorState({required this.error});
}

class GetPostsSuccessState extends AppStates {}

class GetPostsErrorState extends AppStates {
  final String error;
  GetPostsErrorState({required this.error});
}

class DeletePostSuccessState extends AppStates {}

class DeleteErrorState extends AppStates {
  final String error;
  DeleteErrorState({required this.error});
}

class GetUsersSuccessState extends AppStates {}

class GetUsersErrorState extends AppStates {
  final String error;
  GetUsersErrorState({required this.error});
}

class GetImageProfileSuccessState extends AppStates {}

class GetImageProfileErrorState extends AppStates {
  final String error;
  GetImageProfileErrorState({required this.error});
}

class GetImageCoverSuccessState extends AppStates {}

class GetImageCoverErrorState extends AppStates {
  final String error;
  GetImageCoverErrorState({required this.error});
}

class UpdateUserSuccessState extends AppStates {}

class UpdateUserErrorState extends AppStates {
  final String error;
  UpdateUserErrorState({required this.error});
}

class UpdateUserTokenSuccessState extends AppStates {}

class UpdateUserTokenErrorState extends AppStates {
  final String error;
  UpdateUserTokenErrorState({required this.error});
}

class CreatePostSuccessState extends AppStates {}

class CreatePostErrorState extends AppStates {
  final String error;
  CreatePostErrorState({required this.error});
}

class UpdatePostSuccessState extends AppStates {}

class UpdatePostErrorState extends AppStates {
  final String error;
  UpdatePostErrorState({required this.error});
}

//Likes
class SetLikePostSuccessState extends AppStates {}

class SetLikePostErrorState extends AppStates {
  final String error;
  SetLikePostErrorState({required this.error});
}

class GetLikesPostSuccessState extends AppStates {}

class GetLikesPostErrorState extends AppStates {
  final String error;
  GetLikesPostErrorState({required this.error});
}

//Comments
class SetCommentPostSuccessState extends AppStates {}

class SetCommentPostErrorState extends AppStates {
  final String error;
  SetCommentPostErrorState({required this.error});
}

class GetCommentsPostSuccessState extends AppStates {}

class GetCommentsPostErrorState extends AppStates {
  final String error;
  GetCommentsPostErrorState({required this.error});
}

class DeleteCommentSuccessState extends AppStates {}

class DeleteCommentErrorState extends AppStates {
  final String error;
  DeleteCommentErrorState({required this.error});
}

//Chat
class SendMessageSuccessState extends AppStates {}

class SendMessageErrorState extends AppStates {
  final String error;
  SendMessageErrorState({required this.error});
}

class GetMessagesSuccessState extends AppStates {}

class SortMessagesSuccessState extends AppStates {}

class GetMessagesErrorState extends AppStates {
  final String error;
  GetMessagesErrorState({required this.error});
}
