part of 'home_page.dart';

class HomeDrawerWidget extends StatefulWidget {
  @override
  _HomeDrawerWidgetState createState() => _HomeDrawerWidgetState();
}

class _HomeDrawerWidgetState extends State<HomeDrawerWidget> {
  UserModel userProfile;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(UserFetchEvent());
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.zero,
          child: BlocBuilder<UserBloc, UserState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is UserLoadingState) {
                return loadingWidget();
              } else if (state is UserSuccessState) {
                this.userProfile = state.userProfile;
                return buildUserProfile(state.userProfile);
              } else if (state is UserFailureState) {
                return errorWidget(state.message);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildUserProfile(userProfile) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          arrowColor: Colors.pink,
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              userProfile.name.first[0] + userProfile.name.last[0],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          accountName: Text(userProfile.name.fullName),
          accountEmail: Text(userProfile.email),
        ),
        ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.of(context).pushNamed('/home')),
        ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () => Navigator.of(context).pushNamed('/profile')),
        ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification'),
            onTap: () => Navigator.of(context).pushNamed('/notification')),
        ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.of(context).pushNamed('/settings')),
        Divider(),
        ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () =>
                BlocProvider.of<AuthBloc>(context).add(UnAuthorizeEvent())),
      ],
    );
  }
}
