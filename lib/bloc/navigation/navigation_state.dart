import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NavigationState extends Equatable {
  NavigationState([List props = const []]): super(props);
}
class NavigationTarget extends NavigationState {
  final String target;

  NavigationTarget({@required this.target}) : super([target]);

  @override
  String toString() {
    return 'NavigationTarget';
  }
}