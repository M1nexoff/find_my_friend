import 'package:find_my_friend/controllers/profile_controller.dart';
import 'package:find_my_friend/data/models/user_model.dart';
import 'package:find_my_friend/data/services/location_service.dart';
import 'package:find_my_friend/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:image_picker/image_picker.dart';

class MakeProfile extends StatefulWidget {
  final UserModel? userModel;

  const MakeProfile({super.key, this.userModel});

  @override
  State<MakeProfile> createState() => _MakeProfileState(userModel);
}

class _MakeProfileState extends State<MakeProfile> {
  final ProfileController controller = ProfileController();
  final TextEditingController nameController = TextEditingController();
  late UserModel currentModel;

  _MakeProfileState(UserModel? userModel) {
    currentModel = userModel ??
        UserModel(
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/3282/3282224.png',
        );
    if (userModel != null) {
      nameController.text = currentModel.name ?? '';
    }
  }

  Future<void> selectImage() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.camera_alt)),
                  Text("Camera"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.image_sharp),
                  ),
                  Text("Gallery"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (isCamera == null) return;

    XFile? pickedFile = await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource,maxWidth: 1024,maxHeight: 1024);

    final _picker = HLImagePicker();
    // final images = await _picker.openCamera(
    //   cropping: false,
    //   cameraOptions: HLCameraOptions(
    //     maxSizeOutput: MaxSizeOutput(maxWidth: 1024, maxHeight: 1024),
    //     cameraType: CameraType.image,
    //   ),
    // );

    if (pickedFile != null) {
      final image = await _picker.openCropper(
        pickedFile.path,
        cropOptions: HLCropOptions(maxSizeOutput: MaxSizeOutput(maxWidth: 1024, maxHeight: 1024),croppingStyle: CroppingStyle.circular,aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1))
      );
      if (image.path.isNotEmpty) {
        var dialog = Get.dialog(
            Center(
                child: Container(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      color: Colors.lightBlueAccent,
                    ))),
            barrierDismissible: false);
        String imageUrl = await controller.uploadImage(XFile(image.path));
        Get.back();
        setState(() {
          currentModel = currentModel.copyWith(
            imageUrl: imageUrl.isNotEmpty ? imageUrl : currentModel.imageUrl,
          );
        });
      }
    }
  }

  Future<void> getCurrentLocation() async {
    var locationService = LocationService();
    if (!await locationService.checkPermission()) {
      if (!await locationService.requestPermission()) return;
    }
    var location = await locationService.getCurrentLocation();
    setState(() {
      currentModel = currentModel.copyWith(
        latitude: location.lat,
        longitude: location.long,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: selectImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Stack(
                        children: [
                          Image.network(
                            currentModel.imageUrl!,
                            width: 150,
                            height: 150,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            cacheHeight: 1024,
                            cacheWidth: 1024,
                            fit: BoxFit.cover,
                          ),
                          SizedBox.square(dimension: 150)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: getCurrentLocation,
                    icon: Icon(Icons.location_on,
                        color: Theme.of(context).colorScheme.background),
                    label: Text('Detect Location',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.background)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentModel.latitude != null &&
                              currentModel.longitude != null
                          ? "Location detected:\nLatitude: ${currentModel.latitude},\nLongitude: ${currentModel.longitude}"
                          : "Location not detected",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                String result = widget.userModel == null
                    ? await controller.createProfile(
                        currentModel.copyWith(name: nameController.text))
                    : await controller.updateProfile(
                        currentModel.copyWith(name: nameController.text));

                if (result != "Success") {
                  Get.snackbar(
                    "Error",
                    result,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                } else {
                  if (widget.userModel == null) {
                    Get.off(HomeScreen());
                  } else {
                    Get.back();
                  }
                }
              },
              child: Text(
                'Next',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.background),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
