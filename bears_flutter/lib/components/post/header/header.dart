import 'package:bears_flutter/components/misc/dot.dart';
import 'package:flutter/material.dart';
import 'package:time_formatter/time_formatter.dart';

import '../common.dart';

class PostHeader extends StatelessWidget {
  final String postId;
  final String name;
  final String group;
  final int created;
  final Audience audience;
  final bool sponsored;
  final String image;
  final String creatorId;

  PostHeader({
    @required this.postId,
    @required this.name,
    @required this.group,
    @required this.created,
    @required this.audience,
    @required this.sponsored,
    @required this.image,
    @required this.creatorId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ProfileIcon(image: image),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 12, bottom: 10, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  HeaderText(name: name, group: group, ),
                  HeaderDetails(sponsored: sponsored, audience: audience, created: created, group: group,)
                  // Header post details needs bottom margin of about 15=17
                ],
              ),
            ),
          ),
          MoreIcon(postId: postId, name: name, group: group,)
        ],
      ),
    );
  }
}

class HeaderDetails extends StatelessWidget {
  
  final bool sponsored;
  final Audience audience;
  final int created;
  final String group;

  HeaderDetails({
    @required this.sponsored,
    @required this.audience,
    @required this.created,
    @required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(bottom: 12),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.start,
        children: _children()
      ),
    );
  }

  List<Widget> _children() {
    List<Widget> children = [];
    if (sponsored) children.add(_sponsoredText);
    else children.addAll(stringToListOfText(formatTime(created), TextStyle(color: Colors.grey[600])));
  
    children.add(dot(color: Colors.grey[600]));
    children.add(_audiences[audience]);
    return children;
  }

  static Map<Audience, Widget> _audiences = {
    Audience.public: Icon(Icons.public, size: 14, color: Colors.grey[600],),
    Audience.private: Icon(Icons.lock, size: 14, color: Colors.grey[600],),
    Audience.friends: Icon(Icons.group, size: 14, color: Colors.grey[600],),
    Audience.group: Icon(Icons.group_work, size: 14, color: Colors.grey[600],),
  };
  
  static Text _sponsoredText = Text('Sponsored', style: TextStyle(color: Colors.grey[600]),);
}

List<String> hours = [
  '12','1','2','3','4','5','6','7','8','9','10','11','12','1','2','3','4','5','6','7','8','9','10','11',
];

List<String> shortMonths = [
  null,
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

List<String> days = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

List<String> shortDays = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun"
];

class MoreIcon extends StatelessWidget {

  final String postId;
  final String name;
  final String group;

  MoreIcon({
    @required this.postId,
    @required this.name,
    @required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 6, left: 10, right: 12),
      child: GestureDetector(
        onTap: () => _showPostOptions(context: context, postId: postId, name: name, group: group),
        child: Icon(Icons.more_horiz, color: Colors.grey[600],),
      )
    );
  }

  static void _showPostOptions({BuildContext context, String postId, String name, String group}) {
    Scaffold.of(context).showBottomSheet((BuildContext context) =>
      PostOptionsBottomSheet(postId: postId, name: name, group: group));
  }
}

class PostOptionsBottomSheet extends StatefulWidget {

  final String postId;
  final String name;
  final String group;

  PostOptionsBottomSheet({
    @required this.postId,
    @required this.name,
    @required this.group,
  });

  @override
  State<StatefulWidget> createState() => _PostOptionsBottomSheetState();
}

class _PostOptionsBottomSheetState extends State<PostOptionsBottomSheet> {
  
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class HeaderText extends StatelessWidget {

  final String name;
  final String group;

  static final headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  HeaderText({
    @required this.name,
    @required this.group,
  });

  List<Widget> _children() {
    List<Widget> children = [
      ..._headerName(name)
    ];
    if (group != null) children.addAll(_groupWidgets(group));

    print(children);
    return children;  
  }

  static List<Widget> _headerName(String name) => stringToListOfText(name, headerStyle);

  static List<Widget> _groupWidgets(String group) {
    List<Widget> groupWidgets = [
      //leftSpacer(8),
      rightCaret,
      //rightSpacer(8),
      ..._groupName(group)
    ];

    return groupWidgets;
  }

  static List<Widget> _groupName(String group) => stringToListOfText(group, headerStyle);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.5),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: _children(),
      ),
    );
  }
}

Widget rightCaret = Icon(Icons.arrow_right, size: 18, color: Colors.grey[600],);

List<Widget> stringToListOfText(String text, TextStyle style) {
  List<String> strings = text.split(' ');
  int count = -1;
  List<String> formatted = strings.map((String string) {
    if (count == strings.length - 2) return string;
    count ++;
    return strings[count] + ' ';
  }).toList();

  print(formatted);

  return formatted.map((String word) => Text(
    word,
    style: style
  )).toList();
}

class ProfileIcon extends StatelessWidget {

  final String image;
  final bool margin;

  ProfileIcon({
    @required this.image,
    this.margin = true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: margin ? EdgeInsets.only(top: 12, left: 12, right: 10, bottom: 15) : null,
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
            image
          )
        ),
      )
    );
  }
}

