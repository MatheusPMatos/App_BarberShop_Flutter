
sealed class Either<E extends Exception, S> {}  

class Failure<E extends Exception, S> extends Either<E, S>{
  final E exception;
  Failure(this.exception);
}

class Sucess<E extends Exception, S> extends Either<E, S>{
  final S value;
  Sucess(this.value);
}