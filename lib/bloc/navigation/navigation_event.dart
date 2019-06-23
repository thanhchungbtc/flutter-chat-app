import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NavigationEvent extends Equatable {
  NavigationEvent([List props = const []]) : super(props);
}

class ChangeScreen extends NavigationEvent {
  final String target;

  ChangeScreen({@required this.target}) : super([target]);

  @override
  String toString() {
    return 'ChangeScreen';
  }
}
