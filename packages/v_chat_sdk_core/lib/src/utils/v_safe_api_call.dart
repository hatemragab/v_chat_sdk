Future<void> vSafeApiCall<T>({
  Function()? onLoading,
  bool showSnackError = true,
  required Function() request,
  required Function(T response) onSuccess,
  Function(String exception)? onError,
}) async {
  try {
    if (onLoading != null) {
      onLoading();
    }
    final res = await request();
    await onSuccess(res);
    return;
  } catch (err) {
    if (showSnackError) {
      print(err);
      //AppAlert.showErrorSnackBar(msg: err.toString());
    }
    if (onError != null) {
      onError(err.toString());
    }
    return;
  }
}
