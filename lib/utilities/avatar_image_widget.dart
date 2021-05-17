import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    Key key,
    @required this.profileImageUrl,@required this.radius
  }) : super(key: key);

  final String profileImageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.black12)
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey,
          backgroundImage: profileImageUrl !=null?NetworkImage(profileImageUrl):NetworkImage("https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-male-avatar-maker.jpg"),
        ),
      ),
    );
  }
}