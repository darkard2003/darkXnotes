typedef CloseDialog = bool Function();
typedef UpdateDialog = bool Function(String text);

class LoadingDialogController {
  CloseDialog close;
  UpdateDialog update;
  LoadingDialogController({required this.close,required this.update});
}
