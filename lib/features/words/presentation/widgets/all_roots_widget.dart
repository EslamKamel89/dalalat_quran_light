import 'package:dalalat_quran_light/features/words/models/root_model/root_model.dart';
import 'package:dalalat_quran_light/features/words/presentation/widgets/root_card.dart';
import 'package:flutter/material.dart';

class AllRootsWidget extends StatefulWidget {
  const AllRootsWidget({super.key, required this.roots});
  final List<RootModel> roots;
  @override
  State<AllRootsWidget> createState() => _AllRootsWidgetState();
}

class _AllRootsWidgetState extends State<AllRootsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          children: List.generate(
            widget.roots.length,
            (index) => RootCard(rootModel: widget.roots[index]),
          ),
        );
      },
    );
  }
}
