import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustom extends StatelessWidget {
  const ShimmerCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: (Colors.grey[300])!,
      highlightColor: (Colors.grey[100])!,
      child: Container(
        margin: EdgeInsets.all(6),
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey,
      ),
    );
  }
}
