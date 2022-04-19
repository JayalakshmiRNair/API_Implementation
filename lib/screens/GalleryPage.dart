import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rest_api_implementation/constant/AppUrls.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_implementation/model_class/DataForHive.dart';
import 'package:rest_api_implementation/screens/offline_gallery_screen.dart';
import '../model_class/Data.dart';

late Box _box;

class ImagePreview extends StatefulWidget {
  const ImagePreview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImagePreviewState();
  }
}

class ImagePreviewState extends State<ImagePreview> {
  late bool _isLoading;
  late int _pageNumber;
  late Data user;
  late final List<dynamic> _item = <dynamic>[];
  final ScrollController _scrollController = ScrollController();

  //region : Overridden Methods
  @override
  void initState() {
    super.initState();
    _box = Hive.box('shutterBox');
    _initialiseScreenVariables();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.small(
        tooltip: 'Click to open offline screen',
          child: const Icon(Icons.cloud_off_outlined),
          onPressed: () {
            _openOfflineGalleryScreen();
          }),
    );
  }

  //endregion method

  //region: Widgets
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "The Art Gallery",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBody() {
   if (_item.isEmpty) {
      return const Center(child: Text('List is empty :('));
    } else {
      return ListView.builder(
          controller: _scrollController,
          itemCount: _item.length+1,
          itemBuilder: (BuildContext context, int index) {
            //print(_item.length);
            if(index < _item.length) {
              user = Data.fromJson(_item.elementAt(index));
            }
            //print(index);
            return Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFF000000),
                        offset: Offset.zero,
                        blurRadius: 0.0,
                        spreadRadius: 0.0),
                  ]),
              margin: const EdgeInsets.all(10.0),
              child: index < _item.length ? Image(
                image: NetworkImage(_getImage(user)),
                fit: BoxFit.fill,
              ):
            const Center(child: CircularProgressIndicator())
            );
          });
     }
  }

  //endregion

  //region : Private Methods

  void _initialiseScreenVariables() {
    _isLoading = false;
    _pageNumber = 10;
    _scrollController.addListener(pagination);
    _getDataFromApi();
  }

  Future<void> _getDataFromApi() async {
    setState(() {
      _isLoading = true;
    });

    Uri uri = Uri.parse(AppUrls.baseUrl +
        AppUrls.imageSearch +
        '?page=1&per_page=$_pageNumber');
    final response = await http.get(
      uri,
      headers: {'Authorization': AppUrls.header},
    );
    if (response.statusCode == 200) {
      dynamic userData = json.decode(response.body);
      List<dynamic> newUserData = userData['data'];
      //addDataToHive(newUserData);

      if (newUserData.isNotEmpty){
        _item.clear();
        _item.addAll(newUserData);
        //_box.put(_pageNumber, userData);
      }
      setState(() {
        _isLoading = false;
      });
    }
    else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void pagination() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _pageNumber+= 5;
      _getDataFromApi();
    }

  }

  String _getImage(var user) {
    try {
      return user.assets.preview1000!.url!.toString();
    } catch (e) {
      return e.toString();
    }
  }

  String _getImageFromBox() {
    return (_box.get("url"));
  }

  Future addDataToHive(List<Data> data) async {

    for(var d in data){
      Map<String, dynamic> newdata = {
        "url" : d.assets!.preview!.url
      };
      _box.add(newdata);
    }
  }

  void _openOfflineGalleryScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OfflineGalleryScreen()));
  }
//endregion

}
