import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:vote/model/candidate.dart';

class RadialProgress extends StatelessWidget {
  final List<Candidate> candidateList;
  final List<Color> colorList;
  final int totalVotes;
  final double height, width;

  const RadialProgress({
    super.key,
    required this.candidateList,
    required this.totalVotes,
    required this.height,
    required this.width,
    required this.colorList,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return CustomPaint(
      painter: _RadialPainter(
          candidateList: candidateList,
          colorList: colorList,
          totalVotes: totalVotes),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: '$totalVotes', style: theme.textTheme.titleLarge),
                const TextSpan(text: "\n"),
                TextSpan(
                    text: totalVotes == 1 ? "VOTE" : "VOTES",
                    style: theme.textTheme.titleLarge)
              ])),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final List<Candidate> candidateList;
  final List<Color> colorList;
  final int totalVotes;

  _RadialPainter(
      {required this.candidateList,
      required this.colorList,
      required this.totalVotes});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint paintBlack = Paint()
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90), math.radians(-360), false, paintBlack);
    double startPoint = -90;
    for (int i = 0; i < candidateList.length; i++) {
      double candidateProgress = candidateList[i].numVotes / totalVotes;

      Paint paintCandidate = Paint()
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..color = colorList[i]
        ..strokeCap = StrokeCap.round;

      Paint paintblack = Paint()
        ..strokeWidth = 13
        ..style = PaintingStyle.stroke
        ..color = Colors.black
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
          Rect.fromCircle(center: center, radius: size.width / 2),
          math.radians(startPoint),
          math.radians(-360 * candidateProgress),
          false,
          paintblack);

      canvas.drawArc(
          Rect.fromCircle(center: center, radius: size.width / 2),
          math.radians(startPoint),
          math.radians(-360 * candidateProgress),
          false,
          paintCandidate);

      startPoint += (-360 * candidateProgress);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
