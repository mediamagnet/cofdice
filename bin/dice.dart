import 'package:d20/d20.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addOption('dice', abbr: 'd', help: 'number of dice to roll');
  parser.addFlag('rote', defaultsTo: false, abbr: 'r', help: 'rote action');
  parser.addFlag('9again', defaultsTo: false, abbr: '9', help: '9again');
  parser.addFlag('8again', defaultsTo: false, abbr: '8', help: '8again');
  parser.addFlag('chance', defaultsTo: false, abbr: 'c', help: 'Chance Die');

  var res = parser.parse(arguments);

  // total rolled dice
  var totSuccess; // total number of successes from your roll
  final d20 = D20();
  var rolled; // dice rolls
  var explode;
  var total10Again = List.empty(growable: true);
  var total9Again = List.empty(growable: true);
  var ctx = res['dice'];
  var cont = int.parse(ctx);
  var totalDice = List.filled(cont, 0, growable: true);
  if (cont >= 51) {
    print('Please roll less than 50 dice');
  } else {
    totalDice =
        List.generate(cont, (_) => d20.rollWithStatistics('1d10').finalResult);
    var successes = {};
    var explosions = {};

    for (final dice in totalDice) {
      successes.update(dice.toString(), (value) => value + 1,
          ifAbsent: () => 1);
    }
    if (successes.containsKey('8') ||
        successes.containsKey('9') ||
        successes.containsKey('10')) {
      var nines = 0;
      var tens = 0;
      if (res['9again']) {
        nines = successes['9'] ?? 0;
        total9Again = nines > 0
            ? List.generate(
                nines, (_) => d20.rollWithStatistics('1d10').finalResult)
            : [0];
        for (var e in total9Again) {
          explosions.update(e.toString(), (x) => x + 1, ifAbsent: () => 1);
        }
      } else {
        nines = successes['9'];
      }
      tens = successes['10'] ?? 0;
      total10Again = tens > 0
          ? List.generate(
              tens, (_) => d20.rollWithStatistics('1d10').finalResult)
          : [0];
      print(total10Again);
      for (var e in total10Again) {
        explosions.update(e.toString(), (x) => x + 1, ifAbsent: () => 1);
      }
      totSuccess = (successes['8'] ?? 0) + nines + tens;
    }
    final eights = successes['8'] ?? 0;
    final nines = successes['9'] ?? 0;
    final tens = successes['10'] ?? 0;
    final eightsEx = explosions['8'] ?? 0;
    final ninesEx = explosions['9'] ?? 0;
    final tensEx = explosions['10'] ?? 0;

    print(total10Again);
    print("tens: $tens");

    totSuccess ??= 0; // Assign 0 if null
    print('$totalDice, Additional: $total10Again');
    print(
        '8s: ${eights + eightsEx} 9s: ${nines + ninesEx}, 10s ${tens + tensEx}');
  }
}
