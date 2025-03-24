part of template;

class TextFieldUrlOrUploadImage extends StatefulWidget {
  TextFieldUrlOrUploadImage({
    super.key,
    this.controller,
    this.hintText,
    this.title,
    this.validator,
    this.width,
    this.height,
    this.constraints,
    this.uploadImage,
    this.dio,
    this.baseUrl,
    this.showShadow = true,
  });
  TextEditingController? controller;
  String? hintText;
  String? title;
  String? Function(String?)? validator;
  double? width;
  double? height;
  BoxConstraints? constraints;
  Future<String?> Function(Uint8List s)? uploadImage;
  Dio? dio;
  String? baseUrl;
  final bool showShadow;
  @override
  State<TextFieldUrlOrUploadImage> createState() => _TextFieldUrlOrUploadImageState();
}

class _TextFieldUrlOrUploadImageState extends State<TextFieldUrlOrUploadImage> {
  // final AdvertUsecase _advertUsecase = Injector.instance();
  late TextEditingController controller;
  String urlImage = '';
  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.addListener(
          () {
            if (mounted) urlImage = controller.text.trim();
          },
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // controller.dispose();
    controller.removeListener(
      () {},
    );
    super.dispose();
  }

  void uploadImage(Uint8List s, String? fileName) async {
    // var response = await _advertUsecase.uploadImage(images: s);
    if (widget.uploadImage != null) {
      String? imagePath = await widget.uploadImage?.call(s);
      // print("link anh ${response.data?.toJson()}");
      if (imagePath != null) {
        setState(() {
          controller.text = imagePath;
          urlImage = imagePath;
        });
      }
    } else {
      var response = await AdvertUsecase(FeatRepoImpl(FeatService(
        widget.dio ?? Dio(),
        baseUrl: widget.baseUrl,
      ))).uploadImage(
        images: s,
        filename: fileName,
      );
      setState(() {
        controller.text = response.data?.filePath ?? '';
        urlImage = response.data?.filePath ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: widget.showShadow
            ? [
                AppBoxShadow.ksSmallShadow(),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DottedBorder(
            padding: EdgeInsets.all(8),
            color: const Color.fromARGB(255, 202, 215, 248),
            radius: Radius.circular(100),
            dashPattern: [5, 5],
            strokeCap: StrokeCap.round,
            child: urlImage.isNotEmpty
                ? Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ImagePreviewWidget(
                          imageUrl: urlImage,
                          constraints: widget.constraints,
                          width: widget.width,
                          height: widget.height,
                          // width: 100,
                          // height: 50,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              urlImage = '';
                              controller.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : UploadImageWidget(
                    getImageByte: (s, fileName) {
                      uploadImage(s, fileName);
                    },
                  ),
          ),
          const Gap(12),
          AppTextField(
            isRequired: false,
            controller: controller,
            hintText: widget.hintText,
            backgroundColor: Colors.white,
            borderColor: Colors.black12, showShadow: false,
            // title: widget.title,
            onChanged: (v) {
              setState(() {
                urlImage = v;
              });
            },
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
