abstract class BaseUseCase<Q, T> {
  Future<T> execute({Q? request});
}
