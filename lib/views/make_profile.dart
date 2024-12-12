import 'package:cross_file/cross_file.dart';
import 'package:find_my_friend/data/services/location_service.dart';
import 'package:find_my_friend/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:image_picker/image_picker.dart' as pick;
import 'package:find_my_friend/controllers/profile_controller.dart';
import 'package:find_my_friend/data/models/user_model.dart';
import 'package:geolocator/geolocator.dart';

class MakeProfile extends StatefulWidget {
  UserModel? userModel;
  MakeProfile({super.key, this.userModel});

  @override
  State<MakeProfile> createState() => _MakeProfileState(userModel);
}

class _MakeProfileState extends State<MakeProfile> {
  final ProfileController controller = ProfileController();
  final TextEditingController nameController = TextEditingController();
  late UserModel currentModel;
  _MakeProfileState(UserModel? userModel){
    if(userModel == null) {
      currentModel = UserModel(
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/3282/3282224.png');
    }else{
      currentModel = userModel;
      nameController.text = currentModel.name ?? '';
    }
  }
  XFile? pickedFile;
  Future<void> selectImage() async {
    final _picker = HLImagePicker();
    final images = await _picker.openCamera(
      cropping: true,
      cameraOptions: HLCameraOptions(maxSizeOutput: MaxSizeOutput(maxWidth: 1024, maxHeight: 1024),cameraType: CameraType.image),
    );
    // final picker = pick.ImagePicker();
    // pickedFile = await picker.pickImage(source: pick.ImageSource.gallery);

    if (images.path.isNotEmpty) {
      String imageUrl = await controller.uploadImage(XFile(images.path));
      setState(() {
        currentModel = currentModel.copyWith(imageUrl: imageUrl.isNotEmpty ? imageUrl : currentModel.imageUrl);
      });
    }
  }

  Future<void> getCurrentLocation() async {
    var locationService = LocationService();
    if (!await locationService.checkPermission()){
      if (!await locationService.requestPermission()) {
        return;
      }
    }
    var location = await locationService.getCurrentLocation();
    setState(() {
      currentModel = currentModel.copyWith(
        latitude: location.lat,longitude: location.long,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: selectImage,
              child: CircleAvatar(
                radius: 75.0,
                backgroundImage: NetworkImage(currentModel.imageUrl!),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Detect Location'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            currentModel.latitude != null && currentModel.latitude != null ?
            Center(child: Text("Location Dedected at\n latitude ${currentModel.latitude} and longitude ${currentModel.longitude}",textAlign: TextAlign.center,)):Center(child: Text("Location not Dedected")),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () async{
                var result =widget.userModel == null ? await controller.createProfile(
                  currentModel.copyWith(name: nameController.text),
                ):await controller.updateProfile(
                  currentModel.copyWith(name: nameController.text),
                ) ;
                if(result != "Success"){
                  Get.snackbar("Error", result);
                }else{
                  if(widget.userModel == null){
                    Get.off(HomeScreen());
                  }else{
                    Get.back();
                  }
                }
              },
              child: const Text('Next'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
