import 'package:StackFinance/common/common.dart';
import 'package:StackFinance/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(seconds: 1),
        lowerBound: 0.9,
        upperBound: 1,
        vsync: this);
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtils _mediaQueryUtils = MediaQueryUtils(context);
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.color,
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              goToExplorePage(context, state);
            } else if (state is LoginFailure) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          listenWhen: (previous, current) => previous != current,
          child: Column(
            children: [
              Container(
                height: _mediaQueryUtils.height * 0.3,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => animate(),
                    child: Card(
                      color: Colors.white30,
                      clipBehavior: Clip.antiAlias,
                      shape: CircleBorder(),
                      elevation: 24,
                      shadowColor: Colors.purple,
                      child: ScaleTransition(
                        scale: _animation,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('asset/icons/app_icon.jpeg'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LoginButton(
                      mediaQueryUtils: _mediaQueryUtils,
                      imagePath: 'asset/icons/google.png',
                      labelText: 'Login with Google',
                      onPressedAction: () => BlocProvider.of<LoginBloc>(context)
                          .add(LoginInitiated(logInOption: LogInOption.Google)),
                    ),
                    /*  
                                  * If you need other options just uncomment this or add/modify accordingly..
                                  LoginButton(
                                    mediaQueryUtils: _mediaQueryUtils,
                                    imagePath: 'asset/icons/facebook.png',
                                    labelText: 'Login with Facebook',
                                    onPressedAction: () => print('google'),
                                  ),
                                  LoginButton(
                                    mediaQueryUtils: _mediaQueryUtils,
                                    imagePath: 'asset/icons/github.png',
                                    labelText: 'Login with Github',
                                    onPressedAction: () => print('google'),
                                  ), */
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void animate() {
    _animationController.forward(from: 0.9);
  }

  void goToExplorePage(BuildContext context, LoginSuccess state) {
    Navigator.pushNamedAndRemoveUntil(
        context, Routing.ExplorePageRoute, (_) => false,
        arguments: state.user);
  }
}
