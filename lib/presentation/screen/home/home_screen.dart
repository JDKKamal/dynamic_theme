import 'package:dynamic_theme/presentation/shared/resources.dart';
import 'package:dynamic_theme/presentation/shared/widgets/buttons.dart';
import 'package:dynamic_theme/presentation/shared/widgets/dialogs.dart';
import 'package:dynamic_theme/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../colorful_app.dart';
import 'home_actions.dart';
import 'home_bloc.dart';
import 'home_state.dart';

const List<_MenuPage> _menuPages = [
  _MenuPage(title: 'Calendar', description: 'Quickly preview and prepare your schedule', icon: Icons.event),
  _MenuPage(title: 'All Todos', description: 'Display all active Todos', icon: Icons.list),
  _MenuPage(title: 'Settings', description: 'Customize Deer to your liking', icon: Icons.settings),
];

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key key, this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Place variables here
  HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        _selectColorTheme();
        break;
      default:
        break;
    }
  }

  void _selectColorTheme() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => RoundedAlertDialog(
            actions: <Widget>[
              FlatRoundButton(
                text: 'Close',
                onTap: () => Navigator.pop(context),
              ),
            ],
            title: 'Select Color Theme',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ColorfulTheme.values
                  .skip(1)
                  .map((color) => InkWell(
                        borderRadius: BorderRadius.circular(24.0),
                        highlightColor: ColorfulApp.of(context).themeDataFromEnum(color).pale.withOpacity(0.4),
                        splashColor: ColorfulApp.of(context).themeDataFromEnum(color).medium.withOpacity(0.4),
                        onTap: () => ColorfulApp.of(context).updateColorTheme(color),
                        child: _buildColorDialogTile(
                          text: capitalize(enumToStringSingle(color)),
                          mainColor: ColorfulApp.of(context).themeDataFromEnum(color).pale,
                          borderColor: ColorfulApp.of(context).themeDataFromEnum(color).bleak,
                        ),
                      ))
                  .toList(),
            ),
          ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: ColorfulApp.of(context).colors.mediumGradient,
        ),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    // Build your root view here
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(flex: 2, child: const SizedBox()),
        _buildCarousel(),
        Expanded(child: const SizedBox()),
        _buildDescription(),
        Expanded(flex: 3, child: const SizedBox()),

      ],
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 320,
      child: Swiper(
        onIndexChanged: (id) => _bloc.actions.add(UpdatePageIndex(id)),
        itemCount: _menuPages.length,
        outer: true,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: SizedBox(
              width: 250,
              child: _buildCard(index),
            ),
          );
        },
        indicatorLayout: PageIndicatorLayout.SCALE,
        pagination: SwiperPagination(
          margin: const EdgeInsets.all(16),
          builder: DotSwiperPaginationBuilder(
            activeColor: ColorfulApp.of(context).colors.bleak,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () => _navigate(index),
            child: _buildCardContent(index),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 140,
          width: 140,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorfulApp.of(context).colors.bleak,
              width: 3.5,
            ),
            gradient: RadialGradient(
              radius: 0.75,
              colors: [
                AppColors.white1,
                ColorfulApp.of(context).colors.pale,
              ],
            ),
          ),
          child: Icon(
            _menuPages.elementAt(index).icon,
            size: 64,
            color: ColorfulApp.of(context).colors.bleak,
          ),
        ),
        Text(
          _menuPages.elementAt(index).title,
          textAlign: TextAlign.center,
          style: TextStyle().copyWith(color: ColorfulApp.of(context).colors.bleak, fontSize: 22.0),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return StreamBuilder(
      initialData: _bloc.initialState,
      stream: _bloc.state,
      builder: (context, snapshot) {
        return _buildDescriptionContent(snapshot.data);
      },
    );
  }

  Widget _buildDescriptionContent(HomeState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        _menuPages.elementAt(state.pageIndex).description,
        textAlign: TextAlign.center,
        style: TextStyle().copyWith(color: ColorfulApp.of(context).colors.bleak, fontSize: 16.0),
      ),
    );
  }



  Widget _buildColorDialogTile({String text, Color mainColor, Color borderColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(text),
          Expanded(child: const SizedBox(width: 8.0)),
          Container(
            width: 16.0,
            height: 16.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainColor,
              border: Border.all(color: borderColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuPage {
  final String title;
  final String description;
  final IconData icon;

  const _MenuPage({
    this.title,
    this.description,
    this.icon,
  });
}
