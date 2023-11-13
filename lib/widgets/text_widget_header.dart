import 'package:flutter/material.dart';

//en esta clase creamos un text header
// para poder reutilizarlo en otras clases
class TextWidgetHeader extends SliverPersistentHeaderDelegate {
  //pasamos un parametro title para el nombre del texto
  //ya que el titlo del header va a variar segun la clase del header
  String? title;
  TextWidgetHeader({
   this.title});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent,) {
    return InkWell(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber

            ],
            begin:  FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        height: 80.0,
        width: MediaQuery.of(context).size.height,

        child:  InkWell(
         child: Text(
            title!,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Signatra",
              fontSize: 30,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),

      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>true;
}
