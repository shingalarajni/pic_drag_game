import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class First extends StatefulWidget {
  List<Image> temp_list;
  List<Image> images;

  First(this.temp_list, this.images);

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  List<bool> t = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    t = List.filled(9, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Picture Drag Demo"),
      ),
      body: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemBuilder: (context, index) {
          return (t[index])
              ? Draggable(
                  data: index,
                  onDragStarted: () {
                    t = List.filled(9, false);
                    t[index] = true;
                    setState(() {});
                  },
                  onDragEnd: (details) {
                    t = List.filled(9, true);
                    setState(() {});
                  },
                  child: Container(
                    child: widget.images[index],
                  ),
                  feedback: Container(
                    child: widget.images[index],
                  ))
              : DragTarget(onAccept: (data) {
                int t=data as int;
                Image temp=widget.images[t];
                widget.images[t]=widget.images[index];
                widget.images[index]=temp;
                if(listEquals(widget.images, widget.temp_list))
                  {
                    print("Helo");
                  }
                setState(() {

                });
              },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      child: widget.images[index],
                    );
                  },
                );
        },
      ),
    );
  }
}
