abstract class BaseViewCallback {
  onError(Object error);

  showProgress({bool contentVisible});

  hideProgress();

  showMessage(String message);
}
