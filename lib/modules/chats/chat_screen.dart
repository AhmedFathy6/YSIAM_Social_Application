import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/build_user.dart';
import 'package:social_app/shared/component.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<DateTime> dates = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.endOfFrame.then(
      (_) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Builder(
      builder: (context) {
        AppCubit.get(context).getMessages(receiverId: widget.user.userId);
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is GetMessagesSuccessState) scrollDown();
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              appBar: Component.defaultAppBar(
                context: context,
                beforeGoBack: () => cubit.messages.clear(),
                title: BuildUser.buildUser(
                  context: context,
                  user: widget.user,
                  screen: UserProfileScreen(
                    user: widget.user,
                  ),
                  isList: false,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (cubit.messages[index].senderId == userId)
                              return senderMessage(
                                  cubit.messages[index], context);

                            return receiverMessage(
                                cubit.messages[index], context);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15.0,
                          ),
                          itemCount: cubit.messages.length,
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Component.defaultTextFormField(
                        controller: messageController,
                        labelText: 'message',
                        prefixIcon: null,
                        isExpanded: true,
                        type: TextInputType.multiline,
                        suffixIcon: IconBroken.Send,
                        labelStyle: Theme.of(context).textTheme.caption,
                        suffixPressed: () {
                          if (formKey.currentState!.validate())
                            cubit.sendMessage(
                              message: MessageModel(
                                senderId: userId!,
                                receiverId: widget.user.userId,
                                text: messageController.text,
                              ),
                              receiverUser: widget.user,
                            );
                          messageController.text = "";
                        },
                        suffixIconColor: primaryColor,
                        validator: (value) {
                          if (value!.trim().isEmpty) return 'Must add message';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget receiverMessage(MessageModel message, BuildContext context) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(20),
              topEnd: Radius.circular(20),
              bottomEnd: Radius.circular(20),
              bottomStart: Radius.circular(0),
            ),
            color: AppCubit.get(context).isDark
                ? Colors.grey[700]
                : Colors.grey[300],
          ),
          child: Column(
            children: [
              Text(message.text),
              SizedBox(
                height: 5.0,
              ),
              Align(
                widthFactor: 1,
                alignment: AlignmentDirectional.bottomStart,
                child: Text(
                  '${DateFormat.yMMMd().format(message.creationDate)} ${DateFormat.jm().format(message.creationDate)}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ],
          ),
        ),
      );

  Widget senderMessage(MessageModel message, BuildContext context) => Align(
        alignment: AlignmentDirectional.topEnd,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(20),
              topEnd: Radius.circular(20),
              bottomEnd: Radius.circular(0),
              bottomStart: Radius.circular(20),
            ),
            color: primaryColor.withOpacity(0.1),
          ),
          child: Column(
            children: [
              Text(message.text),
              SizedBox(
                height: 5.0,
              ),
              Align(
                widthFactor: 1,
                alignment: AlignmentDirectional.bottomEnd,
                child: Text(
                  '${DateFormat.yMMMd().format(message.creationDate)} ${DateFormat.jm().format(message.creationDate)}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ],
          ),
        ),
      );

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.ease,
      duration: Duration(milliseconds: 500),
    );
  }
}
