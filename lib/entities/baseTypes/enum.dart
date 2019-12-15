abstract class Enum<T> {
  final T value;

  Enum(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(other) => value == other.value;
}
