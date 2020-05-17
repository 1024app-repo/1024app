import 'package:communityfor1024/util/constants.dart';
import 'package:communityfor1024/util/sp_helper.dart';
import 'package:communityfor1024/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ImageQualityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ImageQualityPageState();
}

class ImageQualityPageState extends State<ImageQualityPage> {
  var modes = [
    {'name': '智能优化', 'meta': '远程智能压缩，加载较快'},
    {'name': '原始大图', 'meta': '高清原图，加载较慢'}
  ];

  @override
  Widget build(BuildContext context) {
    String imgQuality = SpHelper.isImageOptimizeEnabled() ? '智能优化' : '原始大图';

    return Scaffold(
      appBar: MyAppBar(title: '图片质量'),
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
                SpHelper.sp.setBool(SP_IMAGE_OPTIMIZE_MODE, index == 0);
                setState(() {
                  imgQuality = modes[index]['name'];
                });
              },
              child: Container(
                color: Theme.of(context).backgroundColor,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Text(modes[index]['name']),
                    const Spacer(),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          modes[index]['meta'],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: imgQuality == modes[index]['name'] ? 1 : 0,
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
          itemCount: modes.length,
        ),
      ),
    );
  }
}
