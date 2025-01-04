
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controller/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({required this.videolink});
  String videolink = "";
  @override
  State<HomeScreen> createState() => _HomeScreenState(videolink: videolink);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState({required this.videolink});

  String? videolink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: videolink != null || videolink != ""
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final _ytController = YoutubePlayerController(
                    
                    initialVideoId: YoutubePlayer.convertUrlToId(videolink!)!,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      enableCaption: true,
                      captionLanguage: 'en',
                    ),
                  );
                  bool _isPlaying = false;
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.3,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2)),
                          child: YoutubePlayer(
                            controller: _ytController
                              ..addListener(() {
                                if (_ytController.value.isPlaying) {
                                  setState(() {
                                    _isPlaying = true;
                                  });
                                } else {
                                  _isPlaying = false;
                                }
                              }),
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.blue,
                            progressColors: ProgressBarColors(
                              bufferedColor: 
                       colorController.normalgreenbtnclr,
                              
                                backgroundColor: Colors.black),
                            bottomActions: [
                              CurrentPosition(),
                              ProgressBar(isExpanded: true),
                              FullScreenButton(),
                            ],
                            onEnded: (YoutubeMetaData _md) {
                              _ytController.reset();
                              _md.videoId;
                              print(_md.title);
                            },
                          ),
                        ),
                      ),
                      _isPlaying
                          ? Container()
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _ytController.metadata.title,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  );
                },
              )
            : Text("Video link Not Available"));
  }
}
