import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/beta_video.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BetaVideosView extends StatefulWidget {
  final int routeId;
  const BetaVideosView({super.key, required this.routeId});

  @override
  State<BetaVideosView> createState() => _BetaVideosViewState();
}

class _BetaVideosViewState extends State<BetaVideosView> {
  bool isLoading = true;
  List<BetaVideo> betaVideos = [];
  String caption = "";
  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async{
    betaVideos = await getBetaVideosByRouteId(widget.routeId);
    final gymNameWithoutSpaces = (await getGymName(context)).replaceAll(' ', '');
    caption = "Route: ${widget.routeId} @BoulderBudAus #$gymNameWithoutSpaces";
    setState(() {
      isLoading = false;
    });
  }

  void copyCaptionAndOpenInstagram() async {
    await Clipboard.setData(ClipboardData(text: caption));
    const String instagramUrl = "instagram://camera";
    if (await canLaunchUrl(Uri.parse(instagramUrl))) {
      await launchUrl(Uri.parse(instagramUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Instagram')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beta Videos")),
     body: isLoading ? const Center(child: CircularProgressIndicator()) :
         Column(children: [
           Card(
             elevation: 2,
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text(
                     'Tap the button to copy the suggested caption below and open Instagram. When you create your Instagram video post, you can paste the caption. We will find your post and link to it here.',
                     style: TextStyle(fontSize: 16),
                   ),
                   Text(
                     caption,
                     style: TextStyle(fontSize: 16),
                   ),
                   const SizedBox(height: 10),
                   ElevatedButton(
                     onPressed: copyCaptionAndOpenInstagram,
                     child: const Text('COPY CAPTION & OPEN INSTAGRAM'),
                   ),
                 ],
               ),
             ),
           ),
           Expanded(child: GridView.builder(
             padding: const EdgeInsets.all(8),
             itemCount: betaVideos.length,
             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 3,    // number of columns
                 mainAxisSpacing: 8,
                 crossAxisSpacing: 8,
                 childAspectRatio: 9/16
             ),
             itemBuilder: (context, index) {
               final videoUrl = betaVideos[index].url;
               final thumbnailUrl = betaVideos[index].thumbnailUrl;
               return GestureDetector(
                 onTap: () => _launchInstagramUrl(videoUrl),
                 child: AspectRatio(
                   aspectRatio: 9 / 16,
                   child: Stack(
                     alignment: Alignment.center,
                     children: [
                       // Thumbnail Image
                       Positioned.fill(
                         child: Image.network(
                           thumbnailUrl,
                           fit: BoxFit.cover, // Makes sure the image fills the container
                           loadingBuilder: (context, child, loadingProgress) {
                             if (loadingProgress == null) return child;
                             return Center(child: CircularProgressIndicator());
                           },
                           errorBuilder: (context, error, stackTrace) =>
                               Container(color: Colors.grey.shade300),
                         ),
                       ),
                       // Play Icon Overlay
                       const Icon(
                         Icons.play_circle_fill,
                         color: Colors.white70,
                         size: 50,
                       ),
                     ],
                   ),
                 ),
               );
             },
           ))
         ])
    )
    ;
  }

  Future<void> _launchInstagramUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // Opens in Instagram if installed, otherwise in a browser
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}