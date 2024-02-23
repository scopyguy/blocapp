import 'package:blocapp/data/models/channel_mod.dart';
import 'package:blocapp/data/models/vid_mod.dart';
import 'package:blocapp/data/service/api_service.dart';
import 'package:blocapp/presentation/screens/video_screens.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late Channel  _channel;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _initChannel();
  }
 _loadMoreVideos() async {
      _isLoading = true;
      List<Video> moreVideos = await APIService.instance
          .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
      List<Video> allVideos = _channel.videos..addAll(moreVideos);
      setState(() {
        _channel.videos = allVideos;
      });
     
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('YouTube Channel'),
        ),
        body: _channel != null
            ? NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollDetails) {
                  if (!_isLoading &&
                      _channel.videos.length !=
                          int.parse(_channel.videoCount) &&
                      scrollDetails.metrics.pixels ==
                          scrollDetails.metrics.maxScrollExtent) {
                    _loadMoreVideos();
                  }
                  return false;
                },
                child: ListView.builder(
                    itemCount: _channel.videos.length,
                    itemBuilder: (BuildContext context, index) {
                      if (index == 0) {
                        return _buildProfileInfo();
                      }
                      Video video = _channel.videos[index - 1];
                    }),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ));
  }

 

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

  Widget _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => VideoScreen(id: video.id))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
        padding: const EdgeInsets.all(10),
        height: 140,
        decoration: const BoxDecoration(color: Colors.white10, boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 6)
        ]),
        child: Row(
          children: [
            Image(
              width: 150,
              image: NetworkImage(video.thumbnailUrl),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              video.title,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            )),
          ],
        ),
      ),
    );
  }

  _initChannel() async {
    Channel channel =
        await APIService.instance.fetchChannel(channelId: 'Iv1PHAhiqb0');
    setState(() {
      _channel = channel;
    });

   
  }
}
