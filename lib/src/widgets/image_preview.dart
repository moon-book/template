part of template;

class ImagePreviewWidget extends StatelessWidget {
  final String imageUrl;
  double? width;
  double? height;
  BoxFit? fit;
  BoxBorder? border;
  BoxConstraints? constraints;
  ImagePreviewWidget({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.constraints,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return Container();
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showImagePreviewDialog(context),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: border,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  constraints: constraints ?? BoxConstraints(maxWidth: width ?? double.infinity),
                  child: CachedNetworkImage(
                    width: width,
                    height: height,
                    alignment: Alignment.centerLeft,
                    fit: fit ?? BoxFit.fill,
                    imageUrl: imageUrl.trim(),
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8, maxHeight: MediaQuery.of(context).size.height * 0.8),
                    child: Image.network(
                      imageUrl.trim(),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: const Text(
                      'Đóng',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
