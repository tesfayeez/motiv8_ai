
import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000000, size.height * 0.04545455);
    path_0.cubicTo(
        size.width * 0.5000000,
        size.height * 0.02035073,
        size.width * 0.5255364,
        size.height * -0.0002928218,
        size.width * 0.5566727,
        size.height * 0.002837073);
    path_0.cubicTo(
        size.width * 0.6089500,
        size.height * 0.008092418,
        size.width * 0.6596955,
        size.height * 0.02058164,
        size.width * 0.7066273,
        size.height * 0.03974291);
    path_0.cubicTo(
        size.width * 0.7345773,
        size.height * 0.05115455,
        size.width * 0.7411932,
        size.height * 0.07971145,
        size.width * 0.7235568,
        size.height * 0.1004744);
    path_0.cubicTo(
        size.width * 0.7059182,
        size.height * 0.1212373,
        size.width * 0.6707068,
        size.height * 0.1262333,
        size.width * 0.6421864,
        size.height * 0.1157629);
    path_0.cubicTo(
        size.width * 0.6149273,
        size.height * 0.1057556,
        size.width * 0.5861341,
        size.height * 0.09866891,
        size.width * 0.5565568,
        size.height * 0.09468818);
    path_0.cubicTo(
        size.width * 0.5256114,
        size.height * 0.09052327,
        size.width * 0.5000000,
        size.height * 0.07055836,
        size.width * 0.5000000,
        size.height * 0.04545455);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff1988FF).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.7338182, size.height * 0.1062445);
    path_1.cubicTo(
        size.width * 0.7522659,
        size.height * 0.08593691,
        size.width * 0.7880932,
        size.height * 0.08124745,
        size.width * 0.8109795,
        size.height * 0.09842236);
    path_1.cubicTo(
        size.width * 0.8494068,
        size.height * 0.1272604,
        size.width * 0.8812795,
        size.height * 0.1612298,
        size.width * 0.9051636,
        size.height * 0.1988018);
    path_1.cubicTo(
        size.width * 0.9193886,
        size.height * 0.2211782,
        size.width * 0.9037568,
        size.height * 0.2473909,
        size.width * 0.8742295,
        size.height * 0.2558927);
    path_1.cubicTo(
        size.width * 0.8447045,
        size.height * 0.2643927,
        size.width * 0.8125500,
        size.height * 0.2518745,
        size.width * 0.7971727,
        size.height * 0.2299909);
    path_1.cubicTo(
        size.width * 0.7824750,
        size.height * 0.2090764,
        size.width * 0.7643886,
        size.height * 0.1898018,
        size.width * 0.7433886,
        size.height * 0.1726707);
    path_1.cubicTo(
        size.width * 0.7214159,
        size.height * 0.1547480,
        size.width * 0.7153705,
        size.height * 0.1265522,
        size.width * 0.7338182,
        size.height * 0.1062445);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff1988FF).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.8776773, size.height * 0.2638873);
    path_2.cubicTo(
        size.width * 0.9074750,
        size.height * 0.2560164,
        size.width * 0.9399841,
        size.height * 0.2689436,
        size.width * 0.9460295,
        size.height * 0.2935782);
    path_2.cubicTo(
        size.width * 0.9561818,
        size.height * 0.3349400,
        size.width * 0.9572659,
        size.height * 0.3774055,
        size.width * 0.9492341,
        size.height * 0.4190636);
    path_2.cubicTo(
        size.width * 0.9444523,
        size.height * 0.4438745,
        size.width * 0.9126295,
        size.height * 0.4578545,
        size.width * 0.8824545,
        size.height * 0.4509636);
    path_2.cubicTo(
        size.width * 0.8522795,
        size.height * 0.4440745,
        size.width * 0.8353114,
        size.height * 0.4188927,
        size.width * 0.8387977,
        size.height * 0.3939436);
    path_2.cubicTo(
        size.width * 0.8421295,
        size.height * 0.3700982,
        size.width * 0.8415159,
        size.height * 0.3460018,
        size.width * 0.8369682,
        size.height * 0.3222855);
    path_2.cubicTo(
        size.width * 0.8322114,
        size.height * 0.2974709,
        size.width * 0.8478795,
        size.height * 0.2717564,
        size.width * 0.8776773,
        size.height * 0.2638873);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff1988FF).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.8789773, size.height * 0.4601800);
    path_3.cubicTo(
        size.width * 0.9088773,
        size.height * 0.4677982,
        size.width * 0.9257159,
        size.height * 0.4935273,
        size.width * 0.9125409,
        size.height * 0.5163109);
    path_3.cubicTo(
        size.width * 0.8904205,
        size.height * 0.5545673,
        size.width * 0.8601455,
        size.height * 0.5894618,
        size.width * 0.8230841,
        size.height * 0.6194218);
    path_3.cubicTo(
        size.width * 0.8010114,
        size.height * 0.6372655,
        size.width * 0.7649909,
        size.height * 0.6336436,
        size.width * 0.7456114,
        size.height * 0.6139000);
    path_3.cubicTo(
        size.width * 0.7262341,
        size.height * 0.5941545,
        size.width * 0.7309659,
        size.height * 0.5657982,
        size.width * 0.7520909,
        size.height * 0.5472345);
    path_3.cubicTo(
        size.width * 0.7722818,
        size.height * 0.5294909,
        size.width * 0.7894591,
        size.height * 0.5096927,
        size.width * 0.8031750,
        size.height * 0.4883545);
    path_3.cubicTo(
        size.width * 0.8175250,
        size.height * 0.4660291,
        size.width * 0.8490773,
        size.height * 0.4525636,
        size.width * 0.8789773,
        size.height * 0.4601800);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xff1988FF).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.7357500, size.height * 0.6198982);
    path_4.cubicTo(
        size.width * 0.7543500,
        size.height * 0.6401164,
        size.width * 0.7490773,
        size.height * 0.6688509,
        size.width * 0.7216841,
        size.height * 0.6810945);
    path_4.cubicTo(
        size.width * 0.6756864,
        size.height * 0.7016527,
        size.width * 0.6255614,
        size.height * 0.7156564,
        size.width * 0.5735659,
        size.height * 0.7224782);
    path_4.cubicTo(
        size.width * 0.5426000,
        size.height * 0.7265418,
        size.width * 0.5161136,
        size.height * 0.7066800,
        size.width * 0.5149341,
        size.height * 0.6815945);
    path_4.cubicTo(
        size.width * 0.5137568,
        size.height * 0.6565073,
        size.width * 0.5384114,
        size.height * 0.6357873,
        size.width * 0.5691409,
        size.height * 0.6306964);
    path_4.cubicTo(
        size.width * 0.5985091,
        size.height * 0.6258291,
        size.width * 0.6269500,
        size.height * 0.6178836,
        size.width * 0.6537205,
        size.height * 0.6070636);
    path_4.cubicTo(
        size.width * 0.6817295,
        size.height * 0.5957436,
        size.width * 0.7171500,
        size.height * 0.5996782,
        size.width * 0.7357500,
        size.height * 0.6198982);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xff1988FF).withOpacity(0.3);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.5000000, size.height * 0.6818182);
    path_5.cubicTo(
        size.width * 0.5000000,
        size.height * 0.7069218,
        size.width * 0.4744636,
        size.height * 0.7275655,
        size.width * 0.4433273,
        size.height * 0.7244364);
    path_5.cubicTo(
        size.width * 0.3910500,
        size.height * 0.7191800,
        size.width * 0.3403045,
        size.height * 0.7066909,
        size.width * 0.2933727,
        size.height * 0.6875291);
    path_5.cubicTo(
        size.width * 0.2654227,
        size.height * 0.6761182,
        size.width * 0.2588068,
        size.height * 0.6475618,
        size.width * 0.2764432,
        size.height * 0.6267982);
    path_5.cubicTo(
        size.width * 0.2940818,
        size.height * 0.6060364,
        size.width * 0.3292932,
        size.height * 0.6010400,
        size.width * 0.3578136,
        size.height * 0.6115091);
    path_5.cubicTo(
        size.width * 0.3850727,
        size.height * 0.6215164,
        size.width * 0.4138659,
        size.height * 0.6286036,
        size.width * 0.4434432,
        size.height * 0.6325855);
    path_5.cubicTo(
        size.width * 0.4743886,
        size.height * 0.6367491,
        size.width * 0.5000000,
        size.height * 0.6567145,
        size.width * 0.5000000,
        size.height * 0.6818182);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xff1988FF).withOpacity(0.3);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.2683068, size.height * 0.6222545);
    path_6.cubicTo(
        size.width * 0.2500273,
        size.height * 0.6426600,
        size.width * 0.2142386,
        size.height * 0.6475364,
        size.width * 0.1912111,
        size.height * 0.6304836);
    path_6.cubicTo(
        size.width * 0.1525464,
        size.height * 0.6018491,
        size.width * 0.1203941,
        size.height * 0.5680473,
        size.width * 0.09620159,
        size.height * 0.5306018);
    path_6.cubicTo(
        size.width * 0.08179341,
        size.height * 0.5083018,
        size.width * 0.09720977,
        size.height * 0.4820055,
        size.width * 0.1266650,
        size.height * 0.4733509);
    path_6.cubicTo(
        size.width * 0.1561205,
        size.height * 0.4646945,
        size.width * 0.1883773,
        size.height * 0.4770418,
        size.width * 0.2039343,
        size.height * 0.4988436);
    path_6.cubicTo(
        size.width * 0.2188036,
        size.height * 0.5196818,
        size.width * 0.2370477,
        size.height * 0.5388618,
        size.width * 0.2581886,
        size.height * 0.5558800);
    path_6.cubicTo(
        size.width * 0.2803091,
        size.height * 0.5736873,
        size.width * 0.2865864,
        size.height * 0.6018509,
        size.width * 0.2683068,
        size.height * 0.6222545);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xff1988FF).withOpacity(0.3);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.1225673, size.height * 0.4639764);
    path_7.cubicTo(
        size.width * 0.09278886,
        size.height * 0.4718927,
        size.width * 0.06024795,
        size.height * 0.4590164,
        size.width * 0.05414205,
        size.height * 0.4343927);
    path_7.cubicTo(
        size.width * 0.04388977,
        size.height * 0.3930473,
        size.width * 0.04270159,
        size.height * 0.3505818,
        size.width * 0.05063091,
        size.height * 0.3089109);
    path_7.cubicTo(
        size.width * 0.05535341,
        size.height * 0.2840927,
        size.width * 0.08714159,
        size.height * 0.2700636,
        size.width * 0.1173332,
        size.height * 0.2769073);
    path_7.cubicTo(
        size.width * 0.1475248,
        size.height * 0.2837491,
        size.width * 0.1645548,
        size.height * 0.3089055,
        size.width * 0.1611286,
        size.height * 0.3338582);
    path_7.cubicTo(
        size.width * 0.1578543,
        size.height * 0.3577091,
        size.width * 0.1585284,
        size.height * 0.3818055,
        size.width * 0.1631336,
        size.height * 0.4055145);
    path_7.cubicTo(
        size.width * 0.1679520,
        size.height * 0.4303200,
        size.width * 0.1523459,
        size.height * 0.4560600,
        size.width * 0.1225673,
        size.height * 0.4639764);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xff1988FF).withOpacity(0.3);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.1207236, size.height * 0.2678491);
    path_8.cubicTo(
        size.width * 0.09079955,
        size.height * 0.2602909,
        size.width * 0.07388000,
        size.height * 0.2345945,
        size.width * 0.08698409,
        size.height * 0.2117836);
    path_8.cubicTo(
        size.width * 0.1089866,
        size.height * 0.1734842,
        size.width * 0.1391511,
        size.height * 0.1385304,
        size.width * 0.1761198,
        size.height * 0.1084960);
    path_8.cubicTo(
        size.width * 0.1981368,
        size.height * 0.09060855,
        size.width * 0.2341682,
        size.height * 0.09415764,
        size.width * 0.2536091,
        size.height * 0.1138642);
    path_8.cubicTo(
        size.width * 0.2730477,
        size.height * 0.1335705,
        size.width * 0.2684045,
        size.height * 0.1619360,
        size.width * 0.2473364,
        size.height * 0.1805418);
    path_8.cubicTo(
        size.width * 0.2272018,
        size.height * 0.1983255,
        size.width * 0.2100859,
        size.height * 0.2181582,
        size.width * 0.1964368,
        size.height * 0.2395236);
    path_8.cubicTo(
        size.width * 0.1821564,
        size.height * 0.2618782,
        size.width * 0.1506477,
        size.height * 0.2754055,
        size.width * 0.1207236,
        size.height * 0.2678491);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xff1988FF).withOpacity(0.3);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.2640045, size.height * 0.1075193);
    path_9.cubicTo(
        size.width * 0.2453864,
        size.height * 0.08731236,
        size.width * 0.2506295,
        size.height * 0.05857345,
        size.width * 0.2780136,
        size.height * 0.04631345);
    path_9.cubicTo(
        size.width * 0.3239932,
        size.height * 0.02572800,
        size.width * 0.3741023,
        size.height * 0.01169264,
        size.width * 0.4260909,
        size.height * 0.004838891);
    path_9.cubicTo(
        size.width * 0.4570545,
        size.height * 0.0007570327,
        size.width * 0.4835614,
        size.height * 0.02060273,
        size.width * 0.4847636,
        size.height * 0.04568818);
    path_9.cubicTo(
        size.width * 0.4859659,
        size.height * 0.07077364,
        size.width * 0.4613273,
        size.height * 0.09150873,
        size.width * 0.4306045,
        size.height * 0.09661891);
    path_9.cubicTo(
        size.width * 0.4012409,
        size.height * 0.1015033,
        size.width * 0.3728068,
        size.height * 0.1094673,
        size.width * 0.3460455,
        size.height * 0.1203029);
    path_9.cubicTo(
        size.width * 0.3180477,
        size.height * 0.1316396,
        size.width * 0.2826250,
        size.height * 0.1277264,
        size.width * 0.2640045,
        size.height * 0.1075193);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xff1988FF).withOpacity(0.3);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.1234091, size.height * 0.8558182);
    path_10.cubicTo(
        size.width * 0.1234091,
        size.height * 0.8663636,
        size.width * 0.1188636,
        size.height * 0.8751509,
        size.width * 0.1097727,
        size.height * 0.8821818);
    path_10.cubicTo(
        size.width * 0.1008334,
        size.height * 0.8890909,
        size.width * 0.08712114,
        size.height * 0.8925455,
        size.width * 0.06863636,
        size.height * 0.8925455);
    path_10.lineTo(size.width * 0.03818182, size.height * 0.8925455);
    path_10.lineTo(size.width * 0.03818182, size.height * 0.9454545);
    path_10.lineTo(size.width * 0.01750000, size.height * 0.9454545);
    path_10.lineTo(size.width * 0.01750000, size.height * 0.8187273);
    path_10.lineTo(size.width * 0.06863636, size.height * 0.8187273);
    path_10.cubicTo(
        size.width * 0.08651523,
        size.height * 0.8187273,
        size.width * 0.1000757,
        size.height * 0.8221818,
        size.width * 0.1093182,
        size.height * 0.8290909);
    path_10.cubicTo(
        size.width * 0.1187120,
        size.height * 0.8360000,
        size.width * 0.1234091,
        size.height * 0.8449091,
        size.width * 0.1234091,
        size.height * 0.8558182);
    path_10.close();
    path_10.moveTo(size.width * 0.06863636, size.height * 0.8789091);
    path_10.cubicTo(
        size.width * 0.08015159,
        size.height * 0.8789091,
        size.width * 0.08863636,
        size.height * 0.8769091,
        size.width * 0.09409091,
        size.height * 0.8729091);
    path_10.cubicTo(
        size.width * 0.09954545,
        size.height * 0.8689091,
        size.width * 0.1022727,
        size.height * 0.8632127,
        size.width * 0.1022727,
        size.height * 0.8558182);
    path_10.cubicTo(
        size.width * 0.1022727,
        size.height * 0.8401818,
        size.width * 0.09106068,
        size.height * 0.8323636,
        size.width * 0.06863636,
        size.height * 0.8323636);
    path_10.lineTo(size.width * 0.03818182, size.height * 0.8323636);
    path_10.lineTo(size.width * 0.03818182, size.height * 0.8789091);
    path_10.lineTo(size.width * 0.06863636, size.height * 0.8789091);
    path_10.close();
    path_10.moveTo(size.width * 0.1697959, size.height * 0.8620000);
    path_10.cubicTo(
        size.width * 0.1734323,
        size.height * 0.8563036,
        size.width * 0.1785836,
        size.height * 0.8518782,
        size.width * 0.1852505,
        size.height * 0.8487273);
    path_10.cubicTo(
        size.width * 0.1920686,
        size.height * 0.8455764,
        size.width * 0.2003261,
        size.height * 0.8440000,
        size.width * 0.2100232,
        size.height * 0.8440000);
    path_10.lineTo(size.width * 0.2100232, size.height * 0.8610909);
    path_10.lineTo(size.width * 0.2045686, size.height * 0.8610909);
    path_10.cubicTo(
        size.width * 0.1813868,
        size.height * 0.8610909,
        size.width * 0.1697959,
        size.height * 0.8711509,
        size.width * 0.1697959,
        size.height * 0.8912727);
    path_10.lineTo(size.width * 0.1697959, size.height * 0.9454545);
    path_10.lineTo(size.width * 0.1491141, size.height * 0.9454545);
    path_10.lineTo(size.width * 0.1491141, size.height * 0.8458182);
    path_10.lineTo(size.width * 0.1697959, size.height * 0.8458182);
    path_10.lineTo(size.width * 0.1697959, size.height * 0.8620000);
    path_10.close();
    path_10.moveTo(size.width * 0.2882159, size.height * 0.9470909);
    path_10.cubicTo(
        size.width * 0.2765500,
        size.height * 0.9470909,
        size.width * 0.2659432,
        size.height * 0.9449691,
        size.width * 0.2563977,
        size.height * 0.9407273);
    path_10.cubicTo(
        size.width * 0.2470045,
        size.height * 0.9364855,
        size.width * 0.2395795,
        size.height * 0.9304855,
        size.width * 0.2341250,
        size.height * 0.9227273);
    path_10.cubicTo(
        size.width * 0.2288227,
        size.height * 0.9148491,
        size.width * 0.2261700,
        size.height * 0.9057582,
        size.width * 0.2261700,
        size.height * 0.8954545);
    path_10.cubicTo(
        size.width * 0.2261700,
        size.height * 0.8852727,
        size.width * 0.2288977,
        size.height * 0.8763036,
        size.width * 0.2343523,
        size.height * 0.8685455);
    path_10.cubicTo(
        size.width * 0.2399591,
        size.height * 0.8606673,
        size.width * 0.2475341,
        size.height * 0.8546673,
        size.width * 0.2570795,
        size.height * 0.8505455);
    path_10.cubicTo(
        size.width * 0.2666250,
        size.height * 0.8463036,
        size.width * 0.2773068,
        size.height * 0.8441818,
        size.width * 0.2891250,
        size.height * 0.8441818);
    path_10.cubicTo(
        size.width * 0.3009432,
        size.height * 0.8441818,
        size.width * 0.3116250,
        size.height * 0.8463036,
        size.width * 0.3211705,
        size.height * 0.8505455);
    path_10.cubicTo(
        size.width * 0.3307159,
        size.height * 0.8546673,
        size.width * 0.3382159,
        size.height * 0.8606055,
        size.width * 0.3436705,
        size.height * 0.8683636);
    path_10.cubicTo(
        size.width * 0.3492773,
        size.height * 0.8761218,
        size.width * 0.3520795,
        size.height * 0.8851509,
        size.width * 0.3520795,
        size.height * 0.8954545);
    path_10.cubicTo(
        size.width * 0.3520795,
        size.height * 0.9057582,
        size.width * 0.3492000,
        size.height * 0.9148491,
        size.width * 0.3434432,
        size.height * 0.9227273);
    path_10.cubicTo(
        size.width * 0.3378364,
        size.height * 0.9304855,
        size.width * 0.3301864,
        size.height * 0.9364855,
        size.width * 0.3204886,
        size.height * 0.9407273);
    path_10.cubicTo(
        size.width * 0.3107909,
        size.height * 0.9449691,
        size.width * 0.3000341,
        size.height * 0.9470909,
        size.width * 0.2882159,
        size.height * 0.9470909);
    path_10.close();
    path_10.moveTo(size.width * 0.2882159, size.height * 0.9325455);
    path_10.cubicTo(
        size.width * 0.2956409,
        size.height * 0.9325455,
        size.width * 0.3026091,
        size.height * 0.9311509,
        size.width * 0.3091250,
        size.height * 0.9283636);
    path_10.cubicTo(
        size.width * 0.3156409,
        size.height * 0.9255764,
        size.width * 0.3208682,
        size.height * 0.9213945,
        size.width * 0.3248068,
        size.height * 0.9158182);
    path_10.cubicTo(
        size.width * 0.3288977,
        size.height * 0.9102418,
        size.width * 0.3309432,
        size.height * 0.9034545,
        size.width * 0.3309432,
        size.height * 0.8954545);
    path_10.cubicTo(
        size.width * 0.3309432,
        size.height * 0.8874545,
        size.width * 0.3289727,
        size.height * 0.8806673,
        size.width * 0.3250341,
        size.height * 0.8750909);
    path_10.cubicTo(
        size.width * 0.3210955,
        size.height * 0.8695145,
        size.width * 0.3159432,
        size.height * 0.8653945,
        size.width * 0.3095795,
        size.height * 0.8627273);
    path_10.cubicTo(
        size.width * 0.3032159,
        size.height * 0.8599400,
        size.width * 0.2963227,
        size.height * 0.8585455,
        size.width * 0.2888977,
        size.height * 0.8585455);
    path_10.cubicTo(
        size.width * 0.2813227,
        size.height * 0.8585455,
        size.width * 0.2743523,
        size.height * 0.8599400,
        size.width * 0.2679886,
        size.height * 0.8627273);
    path_10.cubicTo(
        size.width * 0.2617773,
        size.height * 0.8653945,
        size.width * 0.2567773,
        size.height * 0.8695145,
        size.width * 0.2529886,
        size.height * 0.8750909);
    path_10.cubicTo(
        size.width * 0.2492000,
        size.height * 0.8806673,
        size.width * 0.2473068,
        size.height * 0.8874545,
        size.width * 0.2473068,
        size.height * 0.8954545);
    path_10.cubicTo(
        size.width * 0.2473068,
        size.height * 0.9035764,
        size.width * 0.2491250,
        size.height * 0.9104236,
        size.width * 0.2527614,
        size.height * 0.9160000);
    path_10.cubicTo(
        size.width * 0.2565500,
        size.height * 0.9215764,
        size.width * 0.2615500,
        size.height * 0.9257582,
        size.width * 0.2677614,
        size.height * 0.9285455);
    path_10.cubicTo(
        size.width * 0.2739727,
        size.height * 0.9312127,
        size.width * 0.2807909,
        size.height * 0.9325455,
        size.width * 0.2882159,
        size.height * 0.9325455);
    path_10.close();
    path_10.moveTo(size.width * 0.4306364, size.height * 0.8441818);
    path_10.cubicTo(
        size.width * 0.4413932,
        size.height * 0.8441818,
        size.width * 0.4507864,
        size.height * 0.8460600,
        size.width * 0.4588182,
        size.height * 0.8498182);
    path_10.cubicTo(
        size.width * 0.4670000,
        size.height * 0.8535764,
        size.width * 0.4730591,
        size.height * 0.8583036,
        size.width * 0.4770000,
        size.height * 0.8640000);
    path_10.lineTo(size.width * 0.4770000, size.height * 0.8458182);
    path_10.lineTo(size.width * 0.4979091, size.height * 0.8458182);
    path_10.lineTo(size.width * 0.4979091, size.height * 0.9476364);
    path_10.cubicTo(
        size.width * 0.4979091,
        size.height * 0.9567273,
        size.width * 0.4954841,
        size.height * 0.9647873,
        size.width * 0.4906364,
        size.height * 0.9718182);
    path_10.cubicTo(
        size.width * 0.4857864,
        size.height * 0.9789691,
        size.width * 0.4788182,
        size.height * 0.9845455,
        size.width * 0.4697273,
        size.height * 0.9885455);
    path_10.cubicTo(
        size.width * 0.4607864,
        size.height * 0.9925455,
        size.width * 0.4503318,
        size.height * 0.9945455,
        size.width * 0.4383636,
        size.height * 0.9945455);
    path_10.cubicTo(
        size.width * 0.4220000,
        size.height * 0.9945455,
        size.width * 0.4083636,
        size.height * 0.9914545,
        size.width * 0.3974545,
        size.height * 0.9852727);
    path_10.cubicTo(
        size.width * 0.3865455,
        size.height * 0.9790909,
        size.width * 0.3801045,
        size.height * 0.9706673,
        size.width * 0.3781364,
        size.height * 0.9600000);
    path_10.lineTo(size.width * 0.3985909, size.height * 0.9600000);
    path_10.cubicTo(
        size.width * 0.4008636,
        size.height * 0.9660600,
        size.width * 0.4055591,
        size.height * 0.9709091,
        size.width * 0.4126818,
        size.height * 0.9745455);
    path_10.cubicTo(
        size.width * 0.4198023,
        size.height * 0.9783036,
        size.width * 0.4283636,
        size.height * 0.9801818,
        size.width * 0.4383636,
        size.height * 0.9801818);
    path_10.cubicTo(
        size.width * 0.4497273,
        size.height * 0.9801818,
        size.width * 0.4589682,
        size.height * 0.9773327,
        size.width * 0.4660909,
        size.height * 0.9716364);
    path_10.cubicTo(
        size.width * 0.4733636,
        size.height * 0.9659400,
        size.width * 0.4770000,
        size.height * 0.9579400,
        size.width * 0.4770000,
        size.height * 0.9476364);
    path_10.lineTo(size.width * 0.4770000, size.height * 0.9267273);
    path_10.cubicTo(
        size.width * 0.4729091,
        size.height * 0.9325455,
        size.width * 0.4668477,
        size.height * 0.9373945,
        size.width * 0.4588182,
        size.height * 0.9412727);
    path_10.cubicTo(
        size.width * 0.4507864,
        size.height * 0.9451509,
        size.width * 0.4413932,
        size.height * 0.9470909,
        size.width * 0.4306364,
        size.height * 0.9470909);
    path_10.cubicTo(
        size.width * 0.4195750,
        size.height * 0.9470909,
        size.width * 0.4095000,
        size.height * 0.9449091,
        size.width * 0.4004091,
        size.height * 0.9405455);
    path_10.cubicTo(
        size.width * 0.3914682,
        size.height * 0.9361818,
        size.width * 0.3844227,
        size.height * 0.9300600,
        size.width * 0.3792727,
        size.height * 0.9221818);
    path_10.cubicTo(
        size.width * 0.3741205,
        size.height * 0.9143036,
        size.width * 0.3715455,
        size.height * 0.9053327,
        size.width * 0.3715455,
        size.height * 0.8952727);
    path_10.cubicTo(
        size.width * 0.3715455,
        size.height * 0.8850909,
        size.width * 0.3741205,
        size.height * 0.8761818,
        size.width * 0.3792727,
        size.height * 0.8685455);
    path_10.cubicTo(
        size.width * 0.3844227,
        size.height * 0.8607873,
        size.width * 0.3914682,
        size.height * 0.8547873,
        size.width * 0.4004091,
        size.height * 0.8505455);
    path_10.cubicTo(
        size.width * 0.4095000,
        size.height * 0.8463036,
        size.width * 0.4195750,
        size.height * 0.8441818,
        size.width * 0.4306364,
        size.height * 0.8441818);
    path_10.close();
    path_10.moveTo(size.width * 0.4770000, size.height * 0.8954545);
    path_10.cubicTo(
        size.width * 0.4770000,
        size.height * 0.8879400,
        size.width * 0.4751045,
        size.height * 0.8813945,
        size.width * 0.4713182,
        size.height * 0.8758182);
    path_10.cubicTo(
        size.width * 0.4675295,
        size.height * 0.8702418,
        size.width * 0.4623773,
        size.height * 0.8660000,
        size.width * 0.4558636,
        size.height * 0.8630909);
    path_10.cubicTo(
        size.width * 0.4495000,
        size.height * 0.8600600,
        size.width * 0.4424545,
        size.height * 0.8585455,
        size.width * 0.4347273,
        size.height * 0.8585455);
    path_10.cubicTo(
        size.width * 0.4270000,
        size.height * 0.8585455,
        size.width * 0.4199545,
        size.height * 0.8600000,
        size.width * 0.4135909,
        size.height * 0.8629091);
    path_10.cubicTo(
        size.width * 0.4072273,
        size.height * 0.8658182,
        size.width * 0.4021500,
        size.height * 0.8700600,
        size.width * 0.3983636,
        size.height * 0.8756364);
    path_10.cubicTo(
        size.width * 0.3945750,
        size.height * 0.8812127,
        size.width * 0.3926818,
        size.height * 0.8877582,
        size.width * 0.3926818,
        size.height * 0.8952727);
    path_10.cubicTo(
        size.width * 0.3926818,
        size.height * 0.9029091,
        size.width * 0.3945750,
        size.height * 0.9095764,
        size.width * 0.3983636,
        size.height * 0.9152727);
    path_10.cubicTo(
        size.width * 0.4021500,
        size.height * 0.9208491,
        size.width * 0.4072273,
        size.height * 0.9251509,
        size.width * 0.4135909,
        size.height * 0.9281818);
    path_10.cubicTo(
        size.width * 0.4199545,
        size.height * 0.9310909,
        size.width * 0.4270000,
        size.height * 0.9325455,
        size.width * 0.4347273,
        size.height * 0.9325455);
    path_10.cubicTo(
        size.width * 0.4424545,
        size.height * 0.9325455,
        size.width * 0.4495000,
        size.height * 0.9310909,
        size.width * 0.4558636,
        size.height * 0.9281818);
    path_10.cubicTo(
        size.width * 0.4623773,
        size.height * 0.9251509,
        size.width * 0.4675295,
        size.height * 0.9208491,
        size.width * 0.4713182,
        size.height * 0.9152727);
    path_10.cubicTo(
        size.width * 0.4751045,
        size.height * 0.9095764,
        size.width * 0.4770000,
        size.height * 0.9029691,
        size.width * 0.4770000,
        size.height * 0.8954545);
    path_10.close();
    path_10.moveTo(size.width * 0.5535409, size.height * 0.8620000);
    path_10.cubicTo(
        size.width * 0.5571773,
        size.height * 0.8563036,
        size.width * 0.5623273,
        size.height * 0.8518782,
        size.width * 0.5689955,
        size.height * 0.8487273);
    path_10.cubicTo(
        size.width * 0.5758136,
        size.height * 0.8455764,
        size.width * 0.5840705,
        size.height * 0.8440000,
        size.width * 0.5937682,
        size.height * 0.8440000);
    path_10.lineTo(size.width * 0.5937682, size.height * 0.8610909);
    path_10.lineTo(size.width * 0.5883136, size.height * 0.8610909);
    path_10.cubicTo(
        size.width * 0.5651318,
        size.height * 0.8610909,
        size.width * 0.5535409,
        size.height * 0.8711509,
        size.width * 0.5535409,
        size.height * 0.8912727);
    path_10.lineTo(size.width * 0.5535409, size.height * 0.9454545);
    path_10.lineTo(size.width * 0.5328591, size.height * 0.9454545);
    path_10.lineTo(size.width * 0.5328591, size.height * 0.8458182);
    path_10.lineTo(size.width * 0.5535409, size.height * 0.8458182);
    path_10.lineTo(size.width * 0.5535409, size.height * 0.8620000);
    path_10.close();
    path_10.moveTo(size.width * 0.7312795, size.height * 0.8918182);
    path_10.cubicTo(
        size.width * 0.7312795,
        size.height * 0.8949691,
        size.width * 0.7310523,
        size.height * 0.8983036,
        size.width * 0.7305977,
        size.height * 0.9018182);
    path_10.lineTo(size.width * 0.6310523, size.height * 0.9018182);
    path_10.cubicTo(
        size.width * 0.6318091,
        size.height * 0.9116364,
        size.width * 0.6359750,
        size.height * 0.9193327,
        size.width * 0.6435523,
        size.height * 0.9249091);
    path_10.cubicTo(
        size.width * 0.6512795,
        size.height * 0.9303636,
        size.width * 0.6605977,
        size.height * 0.9330909,
        size.width * 0.6715068,
        size.height * 0.9330909);
    path_10.cubicTo(
        size.width * 0.6804455,
        size.height * 0.9330909,
        size.width * 0.6878705,
        size.height * 0.9314545,
        size.width * 0.6937795,
        size.height * 0.9281818);
    path_10.cubicTo(
        size.width * 0.6998386,
        size.height * 0.9247873,
        size.width * 0.7040818,
        size.height * 0.9203036,
        size.width * 0.7065068,
        size.height * 0.9147273);
    path_10.lineTo(size.width * 0.7287795, size.height * 0.9147273);
    path_10.cubicTo(
        size.width * 0.7254455,
        size.height * 0.9243036,
        size.width * 0.7187795,
        size.height * 0.9321218,
        size.width * 0.7087795,
        size.height * 0.9381818);
    path_10.cubicTo(
        size.width * 0.6987795,
        size.height * 0.9441218,
        size.width * 0.6863545,
        size.height * 0.9470909,
        size.width * 0.6715068,
        size.height * 0.9470909);
    path_10.cubicTo(
        size.width * 0.6596886,
        size.height * 0.9470909,
        size.width * 0.6490818,
        size.height * 0.9449691,
        size.width * 0.6396886,
        size.height * 0.9407273);
    path_10.cubicTo(
        size.width * 0.6304455,
        size.height * 0.9364855,
        size.width * 0.6231727,
        size.height * 0.9304855,
        size.width * 0.6178705,
        size.height * 0.9227273);
    path_10.cubicTo(
        size.width * 0.6125659,
        size.height * 0.9148491,
        size.width * 0.6099159,
        size.height * 0.9057582,
        size.width * 0.6099159,
        size.height * 0.8954545);
    path_10.cubicTo(
        size.width * 0.6099159,
        size.height * 0.8851509,
        size.width * 0.6124909,
        size.height * 0.8761218,
        size.width * 0.6176432,
        size.height * 0.8683636);
    path_10.cubicTo(
        size.width * 0.6227932,
        size.height * 0.8606055,
        size.width * 0.6299909,
        size.height * 0.8546673,
        size.width * 0.6392341,
        size.height * 0.8505455);
    path_10.cubicTo(
        size.width * 0.6486273,
        size.height * 0.8463036,
        size.width * 0.6593841,
        size.height * 0.8441818,
        size.width * 0.6715068,
        size.height * 0.8441818);
    path_10.cubicTo(
        size.width * 0.6833250,
        size.height * 0.8441818,
        size.width * 0.6937795,
        size.height * 0.8462418,
        size.width * 0.7028705,
        size.height * 0.8503636);
    path_10.cubicTo(
        size.width * 0.7119614,
        size.height * 0.8544855,
        size.width * 0.7189295,
        size.height * 0.8601818,
        size.width * 0.7237795,
        size.height * 0.8674545);
    path_10.cubicTo(
        size.width * 0.7287795,
        size.height * 0.8746055,
        size.width * 0.7312795,
        size.height * 0.8827273,
        size.width * 0.7312795,
        size.height * 0.8918182);
    path_10.close();
    path_10.moveTo(size.width * 0.7099159, size.height * 0.8883636);
    path_10.cubicTo(
        size.width * 0.7099159,
        size.height * 0.8820600,
        size.width * 0.7081727,
        size.height * 0.8766673,
        size.width * 0.7046886,
        size.height * 0.8721818);
    path_10.cubicTo(
        size.width * 0.7012023,
        size.height * 0.8675764,
        size.width * 0.6964295,
        size.height * 0.8641218,
        size.width * 0.6903705,
        size.height * 0.8618182);
    path_10.cubicTo(
        size.width * 0.6844614,
        size.height * 0.8593945,
        size.width * 0.6778705,
        size.height * 0.8581818,
        size.width * 0.6705977,
        size.height * 0.8581818);
    path_10.cubicTo(
        size.width * 0.6601432,
        size.height * 0.8581818,
        size.width * 0.6512023,
        size.height * 0.8608491,
        size.width * 0.6437795,
        size.height * 0.8661818);
    path_10.cubicTo(
        size.width * 0.6365068,
        size.height * 0.8715145,
        size.width * 0.6323386,
        size.height * 0.8789091,
        size.width * 0.6312795,
        size.height * 0.8883636);
    path_10.lineTo(size.width * 0.7099159, size.height * 0.8883636);
    path_10.close();
    path_10.moveTo(size.width * 0.8026682, size.height * 0.9470909);
    path_10.cubicTo(
        size.width * 0.7931227,
        size.height * 0.9470909,
        size.width * 0.7845636,
        size.height * 0.9458182,
        size.width * 0.7769864,
        size.height * 0.9432727);
    path_10.cubicTo(
        size.width * 0.7694114,
        size.height * 0.9406055,
        size.width * 0.7634273,
        size.height * 0.9369691,
        size.width * 0.7590318,
        size.height * 0.9323636);
    path_10.cubicTo(
        size.width * 0.7546386,
        size.height * 0.9276364,
        size.width * 0.7522136,
        size.height * 0.9222418,
        size.width * 0.7517591,
        size.height * 0.9161818);
    path_10.lineTo(size.width * 0.7731227, size.height * 0.9161818);
    path_10.cubicTo(
        size.width * 0.7737295,
        size.height * 0.9211509,
        size.width * 0.7766091,
        size.height * 0.9252127,
        size.width * 0.7817591,
        size.height * 0.9283636);
    path_10.cubicTo(
        size.width * 0.7870636,
        size.height * 0.9315145,
        size.width * 0.7939568,
        size.height * 0.9330909,
        size.width * 0.8024409,
        size.height * 0.9330909);
    path_10.cubicTo(
        size.width * 0.8103205,
        size.height * 0.9330909,
        size.width * 0.8165318,
        size.height * 0.9316964,
        size.width * 0.8210773,
        size.height * 0.9289091);
    path_10.cubicTo(
        size.width * 0.8256227,
        size.height * 0.9261218,
        size.width * 0.8278955,
        size.height * 0.9226055,
        size.width * 0.8278955,
        size.height * 0.9183636);
    path_10.cubicTo(
        size.width * 0.8278955,
        size.height * 0.9140000,
        size.width * 0.8254727,
        size.height * 0.9107873,
        size.width * 0.8206227,
        size.height * 0.9087273);
    path_10.cubicTo(
        size.width * 0.8157750,
        size.height * 0.9065455,
        size.width * 0.8082750,
        size.height * 0.9044236,
        size.width * 0.7981227,
        size.height * 0.9023636);
    path_10.cubicTo(
        size.width * 0.7888818,
        size.height * 0.9004236,
        size.width * 0.7813045,
        size.height * 0.8984855,
        size.width * 0.7753955,
        size.height * 0.8965455);
    path_10.cubicTo(
        size.width * 0.7696386,
        size.height * 0.8944855,
        size.width * 0.7646386,
        size.height * 0.8915145,
        size.width * 0.7603955,
        size.height * 0.8876364);
    path_10.cubicTo(
        size.width * 0.7563045,
        size.height * 0.8836364,
        size.width * 0.7542591,
        size.height * 0.8784236,
        size.width * 0.7542591,
        size.height * 0.8720000);
    path_10.cubicTo(
        size.width * 0.7542591,
        size.height * 0.8669091,
        size.width * 0.7561545,
        size.height * 0.8622418,
        size.width * 0.7599409,
        size.height * 0.8580000);
    path_10.cubicTo(
        size.width * 0.7637295,
        size.height * 0.8537582,
        size.width * 0.7691091,
        size.height * 0.8504236,
        size.width * 0.7760773,
        size.height * 0.8480000);
    path_10.cubicTo(
        size.width * 0.7830477,
        size.height * 0.8454545,
        size.width * 0.7910023,
        size.height * 0.8441818,
        size.width * 0.7999409,
        size.height * 0.8441818);
    path_10.cubicTo(
        size.width * 0.8137295,
        size.height * 0.8441818,
        size.width * 0.8248659,
        size.height * 0.8469691,
        size.width * 0.8333500,
        size.height * 0.8525455);
    path_10.cubicTo(
        size.width * 0.8418364,
        size.height * 0.8581218,
        size.width * 0.8463818,
        size.height * 0.8657582,
        size.width * 0.8469864,
        size.height * 0.8754545);
    path_10.lineTo(size.width * 0.8263045, size.height * 0.8754545);
    path_10.cubicTo(
        size.width * 0.8258500,
        size.height * 0.8702418,
        size.width * 0.8232000,
        size.height * 0.8660600,
        size.width * 0.8183500,
        size.height * 0.8629091);
    path_10.cubicTo(
        size.width * 0.8136545,
        size.height * 0.8597582,
        size.width * 0.8072909,
        size.height * 0.8581818,
        size.width * 0.7992591,
        size.height * 0.8581818);
    path_10.cubicTo(
        size.width * 0.7918364,
        size.height * 0.8581818,
        size.width * 0.7859273,
        size.height * 0.8594545,
        size.width * 0.7815318,
        size.height * 0.8620000);
    path_10.cubicTo(
        size.width * 0.7771386,
        size.height * 0.8645455,
        size.width * 0.7749409,
        size.height * 0.8678782,
        size.width * 0.7749409,
        size.height * 0.8720000);
    path_10.cubicTo(
        size.width * 0.7749409,
        size.height * 0.8752727,
        size.width * 0.7762295,
        size.height * 0.8780000,
        size.width * 0.7788045,
        size.height * 0.8801818);
    path_10.cubicTo(
        size.width * 0.7815318,
        size.height * 0.8822418,
        size.width * 0.7848659,
        size.height * 0.8839400,
        size.width * 0.7888045,
        size.height * 0.8852727);
    path_10.cubicTo(
        size.width * 0.7928955,
        size.height * 0.8864855,
        size.width * 0.7985023,
        size.height * 0.8878782,
        size.width * 0.8056227,
        size.height * 0.8894545);
    path_10.cubicTo(
        size.width * 0.8145636,
        size.height * 0.8913945,
        size.width * 0.8218364,
        size.height * 0.8933327,
        size.width * 0.8274409,
        size.height * 0.8952727);
    path_10.cubicTo(
        size.width * 0.8330477,
        size.height * 0.8970909,
        size.width * 0.8378205,
        size.height * 0.8998782,
        size.width * 0.8417591,
        size.height * 0.9036364);
    path_10.cubicTo(
        size.width * 0.8458500,
        size.height * 0.9073945,
        size.width * 0.8479727,
        size.height * 0.9123036,
        size.width * 0.8481227,
        size.height * 0.9183636);
    path_10.cubicTo(
        size.width * 0.8481227,
        size.height * 0.9238182,
        size.width * 0.8462295,
        size.height * 0.9287273,
        size.width * 0.8424409,
        size.height * 0.9330909);
    path_10.cubicTo(
        size.width * 0.8386545,
        size.height * 0.9374545,
        size.width * 0.8332750,
        size.height * 0.9409091,
        size.width * 0.8263045,
        size.height * 0.9434545);
    path_10.cubicTo(
        size.width * 0.8194864,
        size.height * 0.9458782,
        size.width * 0.8116091,
        size.height * 0.9470909,
        size.width * 0.8026682,
        size.height * 0.9470909);
    path_10.close();
    path_10.moveTo(size.width * 0.9214091, size.height * 0.9470909);
    path_10.cubicTo(
        size.width * 0.9118636,
        size.height * 0.9470909,
        size.width * 0.9033045,
        size.height * 0.9458182,
        size.width * 0.8957273,
        size.height * 0.9432727);
    path_10.cubicTo(
        size.width * 0.8881523,
        size.height * 0.9406055,
        size.width * 0.8821682,
        size.height * 0.9369691,
        size.width * 0.8777727,
        size.height * 0.9323636);
    path_10.cubicTo(
        size.width * 0.8733795,
        size.height * 0.9276364,
        size.width * 0.8709545,
        size.height * 0.9222418,
        size.width * 0.8705000,
        size.height * 0.9161818);
    path_10.lineTo(size.width * 0.8918636, size.height * 0.9161818);
    path_10.cubicTo(
        size.width * 0.8924705,
        size.height * 0.9211509,
        size.width * 0.8953500,
        size.height * 0.9252127,
        size.width * 0.9005000,
        size.height * 0.9283636);
    path_10.cubicTo(
        size.width * 0.9058045,
        size.height * 0.9315145,
        size.width * 0.9126977,
        size.height * 0.9330909,
        size.width * 0.9211818,
        size.height * 0.9330909);
    path_10.cubicTo(
        size.width * 0.9290614,
        size.height * 0.9330909,
        size.width * 0.9352727,
        size.height * 0.9316964,
        size.width * 0.9398182,
        size.height * 0.9289091);
    path_10.cubicTo(
        size.width * 0.9443636,
        size.height * 0.9261218,
        size.width * 0.9466364,
        size.height * 0.9226055,
        size.width * 0.9466364,
        size.height * 0.9183636);
    path_10.cubicTo(
        size.width * 0.9466364,
        size.height * 0.9140000,
        size.width * 0.9442136,
        size.height * 0.9107873,
        size.width * 0.9393636,
        size.height * 0.9087273);
    path_10.cubicTo(
        size.width * 0.9345159,
        size.height * 0.9065455,
        size.width * 0.9270159,
        size.height * 0.9044236,
        size.width * 0.9168636,
        size.height * 0.9023636);
    path_10.cubicTo(
        size.width * 0.9076227,
        size.height * 0.9004236,
        size.width * 0.9000455,
        size.height * 0.8984855,
        size.width * 0.8941364,
        size.height * 0.8965455);
    path_10.cubicTo(
        size.width * 0.8883795,
        size.height * 0.8944855,
        size.width * 0.8833795,
        size.height * 0.8915145,
        size.width * 0.8791364,
        size.height * 0.8876364);
    path_10.cubicTo(
        size.width * 0.8750455,
        size.height * 0.8836364,
        size.width * 0.8730000,
        size.height * 0.8784236,
        size.width * 0.8730000,
        size.height * 0.8720000);
    path_10.cubicTo(
        size.width * 0.8730000,
        size.height * 0.8669091,
        size.width * 0.8748955,
        size.height * 0.8622418,
        size.width * 0.8786818,
        size.height * 0.8580000);
    path_10.cubicTo(
        size.width * 0.8824705,
        size.height * 0.8537582,
        size.width * 0.8878500,
        size.height * 0.8504236,
        size.width * 0.8948182,
        size.height * 0.8480000);
    path_10.cubicTo(
        size.width * 0.9017886,
        size.height * 0.8454545,
        size.width * 0.9097432,
        size.height * 0.8441818,
        size.width * 0.9186818,
        size.height * 0.8441818);
    path_10.cubicTo(
        size.width * 0.9324705,
        size.height * 0.8441818,
        size.width * 0.9436068,
        size.height * 0.8469691,
        size.width * 0.9520909,
        size.height * 0.8525455);
    path_10.cubicTo(
        size.width * 0.9605773,
        size.height * 0.8581218,
        size.width * 0.9651227,
        size.height * 0.8657582,
        size.width * 0.9657273,
        size.height * 0.8754545);
    path_10.lineTo(size.width * 0.9450455, size.height * 0.8754545);
    path_10.cubicTo(
        size.width * 0.9445909,
        size.height * 0.8702418,
        size.width * 0.9419409,
        size.height * 0.8660600,
        size.width * 0.9370909,
        size.height * 0.8629091);
    path_10.cubicTo(
        size.width * 0.9323955,
        size.height * 0.8597582,
        size.width * 0.9260318,
        size.height * 0.8581818,
        size.width * 0.9180000,
        size.height * 0.8581818);
    path_10.cubicTo(
        size.width * 0.9105773,
        size.height * 0.8581818,
        size.width * 0.9046682,
        size.height * 0.8594545,
        size.width * 0.9002727,
        size.height * 0.8620000);
    path_10.cubicTo(
        size.width * 0.8958795,
        size.height * 0.8645455,
        size.width * 0.8936818,
        size.height * 0.8678782,
        size.width * 0.8936818,
        size.height * 0.8720000);
    path_10.cubicTo(
        size.width * 0.8936818,
        size.height * 0.8752727,
        size.width * 0.8949705,
        size.height * 0.8780000,
        size.width * 0.8975455,
        size.height * 0.8801818);
    path_10.cubicTo(
        size.width * 0.9002727,
        size.height * 0.8822418,
        size.width * 0.9036068,
        size.height * 0.8839400,
        size.width * 0.9075455,
        size.height * 0.8852727);
    path_10.cubicTo(
        size.width * 0.9116364,
        size.height * 0.8864855,
        size.width * 0.9172432,
        size.height * 0.8878782,
        size.width * 0.9243636,
        size.height * 0.8894545);
    path_10.cubicTo(
        size.width * 0.9333045,
        size.height * 0.8913945,
        size.width * 0.9405773,
        size.height * 0.8933327,
        size.width * 0.9461818,
        size.height * 0.8952727);
    path_10.cubicTo(
        size.width * 0.9517886,
        size.height * 0.8970909,
        size.width * 0.9565614,
        size.height * 0.8998782,
        size.width * 0.9605000,
        size.height * 0.9036364);
    path_10.cubicTo(
        size.width * 0.9645909,
        size.height * 0.9073945,
        size.width * 0.9667136,
        size.height * 0.9123036,
        size.width * 0.9668636,
        size.height * 0.9183636);
    path_10.cubicTo(
        size.width * 0.9668636,
        size.height * 0.9238182,
        size.width * 0.9649705,
        size.height * 0.9287273,
        size.width * 0.9611818,
        size.height * 0.9330909);
    path_10.cubicTo(
        size.width * 0.9573955,
        size.height * 0.9374545,
        size.width * 0.9520159,
        size.height * 0.9409091,
        size.width * 0.9450455,
        size.height * 0.9434545);
    path_10.cubicTo(
        size.width * 0.9382273,
        size.height * 0.9458782,
        size.width * 0.9303500,
        size.height * 0.9470909,
        size.width * 0.9214091,
        size.height * 0.9470909);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xffD1D1D1).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
