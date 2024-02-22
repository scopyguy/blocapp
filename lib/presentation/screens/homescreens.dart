import 'package:blocapp/data/models/channel_mod.dart';
import 'package:blocapp/data/models/vid_mod.dart';
import 'package:blocapp/data/service/api_service.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late Channel _channel;
   bool _isLoading; false;

  @override
  void initState (){
    super.initState();
    _initChannel();
  }

  _initChannel() async{
    Channel channel = await APIService.instance.fetchChannel(channelId: 'Iv1PHAhiqb0');
  setState(() {
    _channel = channel;
  });
   Widget _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      height: 100,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 1),
          blurRadius: 6.0,
        ),
      ]),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            backgroundImage: NetworkImage(_channel.profilePictureUrl),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channel.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_channel.subscriberCount} subscribers',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoInfo(int index) {
    final video = _channel
        .videos[index - 1]; // Subtract 1 to account for the profile info.
    return ListTile(
      leading: Image.network(video.thumbnailUrl),
      title: Text(video.title),
      subtitle: Text(video.publishedAt as String),
    );
  }

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Youtube Channel'),),
        body: ListView.builder( itemCount: _channel.videos.length,
          itemBuilder:(BuildContext context, int index){
            if (index == 0){
              return _buildProfileInfo();

            }
          } ),
          Video video = _channel.videos[index - 1];
          return _buildVideo(video);
    );
  }
}
