import 'package:communityfor1024/blocs/theme/bloc.dart';
import 'package:communityfor1024/util/sp_helper.dart';
import 'package:communityfor1024/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {
  var _items = ['跟随系统', '浅色', '深色'];

  ThemeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ThemeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode mode = SpHelper.getThemeMode();
    String themeMode = mode == ThemeMode.system
        ? '跟随系统'
        : (mode == ThemeMode.light ? '浅色' : '深色');

    return Scaffold(
      appBar: MyAppBar(title: '外观模式'),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 0.1),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                if (index == 0) {
                  _bloc.add(SystemTheme());
                } else if (index == 1) {
                  _bloc.add(LightTheme());
                } else if (index == 2) {
                  _bloc.add(DarkTheme());
                }
              },
              child: Container(
                color: Theme.of(context).backgroundColor,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_items[index]),
                    ),
                    Opacity(
                      opacity: themeMode == _items[index] ? 1 : 0,
                      child: Icon(Icons.done),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, index) {
            return const Divider(
              height: 0,
              indent: 15,
            );
          },
          itemCount: _items.length,
        ),
      ),
    );
  }
}
