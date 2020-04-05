import 'package:communityfor1024/api/model.dart';
import 'package:flutter/material.dart';

const BASE_URL = 'http://www.t66y.com';

var nodes = [
  Node(
    id: '7',
    name: "技术讨论区",
  ),
  Node(
    id: '8',
    name: "新时代的我们",
  ),
  Node(
    id: '16',
    name: "达盖儿的旗帜",
  ),
  Node(
    id: '20',
    name: "成人文学交流区",
  ),
];

final colourLevel = {
  '總版主 ( 4 )': Colors.amber[600],
  '論壇版主 ( 5 )': Colors.yellow[600],
  '禁止發言 ( 8 )': Colors.grey[600],
  '新手上路 ( 8 )': Colors.grey[600],
  '俠客 ( 9 )': Colors.blue[600],
  '騎士 ( 10 )': Colors.green[600],
  '聖騎士 ( 11 )': Colors.orange[600],
  '精靈王 ( 12 )': Colors.pink[600],
  '風雲使者 ( 13 )': Colors.red[600],
  '天使 ( 14 )': Colors.purple[600],
  '光明使者 ( 14 )': Colors.purple[600],
};
