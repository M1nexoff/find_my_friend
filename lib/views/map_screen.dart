import 'dart:developer';
import 'dart:math' as math;
import 'package:yandex_maps_mapkit_lite/src/mapkit/animation.dart' as animation;
import 'package:yandex_maps_mapkit_lite/src/mapkit/map/text_style.dart'
as mapkit_map_text_style;
import 'package:find_my_friend/controllers/map_controller.dart';
import 'package:find_my_friend/data/models/user_model.dart';
import 'package:find_my_friend/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/ui_view.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';
import 'package:yandex_maps_mapkit_lite/mapkit_factory.dart';
import 'package:yandex_maps_mapkit_lite/src/bindings/image/image_provider.dart'
    as img_provider;
import 'package:yandex_maps_mapkit_lite/src/mapkit/geometry/point.dart'
as mapkit_geometry_point;
import 'package:yandex_maps_mapkit_lite/src/mapkit/map/map_object.dart'
as mapkit_map_map_object;


class MapScreen extends StatelessWidget {
  UserModel? userModel;
  MapScreen({super.key, this.userModel});
  final listener = MyMapObjectTapListener();

  MapWindow? _mapWindow;
  final MapController controller = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find My Friend")),
      body: Stack(
        children: [
          // Padding(
          //   padding: EdgeInsets.all(12),
          //   child: Align(
          //     alignment: Alignment.topRight,
          //     child: IconButton(
          //         onPressed: () {
          //           // Get.to(ProfileScreen());
          //         },
          //         icon: const Icon(Icons.person)),
          //   ),
          // ),
          YandexMap(onMapCreated: (mapWindow) {
            log("create");
            final clusterListener = MyClusterListener(ontap: ClusterTapListenerImpl(onClusterTapCallback: (p0) {
              mapWindow.map.moveWithAnimation(CameraPosition(Point(longitude: p0.appearance.geometry.longitude,latitude: p0.appearance.geometry.latitude), zoom: mapWindow.map.cameraPosition.zoom + 2, azimuth: mapWindow.map.cameraPosition.azimuth, tilt: mapWindow.map.cameraPosition.tilt), animation.Animation(animation.AnimationType.Linear, duration: 1));
              return true;
            },));
            final clusterizedCollection = mapWindow.map.mapObjects
                .addClusterizedPlacemarkCollection(clusterListener);
            if(userModel == null){
            controller.getUsersProfiles().listen(
              (event) {
                clusterizedCollection.clear();
                event.forEach((e) {
                  if (e.id != null &&
                      e.latitude != null &&
                      e.longitude != null &&
                      e.email != null &&
                      e.name != null) {
                    log("added place mark");
                    clusterizedCollection.addPlacemark()
                      ..geometry = Point(
                        latitude: e.latitude!,
                        longitude: e.longitude!,
                      )
                      ..userData = e
                      ..setTextWithStyle(mapkit_map_text_style.TextStyle(offset: 0.8,placement: mapkit_map_text_style.TextStylePlacement.Bottom),text: e.name!,)
                      ..setIconWithStyle(
                        img_provider.ImageProvider.fromImageProvider(material.Image.network(e.imageUrl??'https://cdn-icons-png.flaticon.com/512/3282/3282224.png',cacheHeight:  1024, cacheWidth: 1024,fit: BoxFit.cover,filterQuality: FilterQuality.low,).image),
                        const IconStyle(
                          anchor: math.Point<double>(0.5,0.1),
                            flat: true,
                            scale: 0.15,
                        ))
                      ..addTapListener(listener)
                      ;}

                });
                clusterizedCollection.clusterPlacemarks(
                  clusterRadius: 17.0,
                  minZoom: 15,
                );
                if (event.isNotEmpty) {
                  mapWindow.map.moveWithAnimation(
                    CameraPosition(
                      Point(
                        latitude: event.first.latitude??41.311081,
                        longitude: event.first.longitude??69.240562,
                      ),
                      zoom: 9, azimuth: 0, tilt: 45,
                    ),
                    animation.Animation(AnimationType.Linear, duration: 1.0),

                  );
                }
              },
            );
            log("update");

            }else{

              var e = userModel!;
              if (e.id != null &&
                  e.latitude != null &&
                  e.longitude != null &&
                  e.email != null &&
                  e.name != null) {
                mapWindow.map.mapObjects.addPlacemark()
                  ..geometry = Point(
                    latitude: e.latitude!,
                    longitude: e.longitude!,
                  )
                  ..userData = e
                  ..setTextWithStyle(mapkit_map_text_style.TextStyle(offset: 0.8,placement: mapkit_map_text_style.TextStylePlacement.Bottom),text: e.name!,)
                  ..setIconWithStyle(
                      img_provider.ImageProvider.fromImageProvider(material.Image.network(e.imageUrl??'https://cdn-icons-png.flaticon.com/512/3282/3282224.png',cacheHeight:  1024, cacheWidth: 1024,fit: BoxFit.cover,filterQuality: FilterQuality.low,width: 1024,height: 1024,).image),
                      const IconStyle(
                        rotationType: RotationType.Rotate,
                        anchor: math.Point<double>(0.5,0.1),
                        flat: true,
                        scale: 0.15,
                      ))
                  ..addTapListener(listener);
                mapWindow.map.move(
                  CameraPosition(
                    Point(
                      latitude: e.latitude!,
                      longitude: e.longitude!,
                    ),
                    zoom: 12, azimuth: 0, tilt: 45,
                  ),
                );
                ;}

            }
            mapkit.onStart();
          })
        ],
      ),
    );
  }
}

class MyMapObjectTapListener implements MapObjectTapListener {
  @override
  bool onMapObjectTap(mapkit_map_map_object.MapObject mapObject, mapkit_geometry_point.Point point) {
    log("tap");
    var user = mapObject.userData as UserModel;
    Get.to(ProfileScreen(user: user));
    return true;
  }
}
final class ClusterTapListenerImpl implements ClusterTapListener {
  final bool Function(Cluster) onClusterTapCallback;

  const ClusterTapListenerImpl({required this.onClusterTapCallback});

  @override
  bool onClusterTap(Cluster cluster) => onClusterTapCallback(cluster);
}


class MyClusterListener implements ClusterListener {
  ClusterTapListenerImpl ontap;

  MyClusterListener({required this.ontap});
  @override
  void onClusterAdded(Cluster cluster) {
    log("MyClusterlistener");
    var clusterLat = 0.0;
    var clusterLong = 0.0;

    cluster.addClusterTapListener(ontap);

    cluster.placemarks.forEach((e) {
      clusterLong += e.geometry.longitude;
      clusterLat += e.geometry.latitude;
    });

// Calculate the average latitude and longitude
    double avgLat = clusterLat / cluster.placemarks.length;
    double avgLong = clusterLong / cluster.placemarks.length;

// Update the cluster's geometry
    cluster.appearance..geometry = Point(latitude: avgLat, longitude: avgLong)
    ..setIconWithStyle(img_provider.ImageProvider.fromImageProvider(material.Image.network('https://cdn-icons-png.flaticon.com/512/3282/3282224.png',cacheHeight:  1024, cacheWidth: 1024,fit: BoxFit.cover,filterQuality: FilterQuality.low,width: 1024,height: 1024,).image),
        const IconStyle(
          rotationType: RotationType.Rotate,
          anchor: math.Point<double>(0.5,0.1),
          flat: true,
          scale: 0.15,
        ))..setTextWithStyle(mapkit_map_text_style.TextStyle(offset: 0.8,placement: mapkit_map_text_style.TextStylePlacement.Bottom),text: cluster.placemarks.length.toString());
  }
}
class ClusterView extends StatelessWidget {
  final String text;

  ClusterView({required this.text});

  @override
  Widget build(BuildContext context) {
    log("clusterView");
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          material.Image.network('https://cdn-icons-png.flaticon.com/512/3282/3282224.png'),
          Text(
            text,
            style: const material.TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
