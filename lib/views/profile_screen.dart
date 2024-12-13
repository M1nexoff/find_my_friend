import 'package:find_my_friend/data/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Stack(
                  children: [
                    Image.network(
                      user.imageUrl??'https://cdn-icons-png.flaticon.com/512/3282/3282224.png',
                      width: 150,
                      height: 150,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return
                          CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes !=
                                null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          );
                      },
                      cacheHeight: 1024,
                      cacheWidth: 1024,
                      fit: BoxFit.cover,
                    ),
                    SizedBox.square(dimension: 20)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                user.name ?? 'Unknown Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email ?? 'No Email Provided',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
