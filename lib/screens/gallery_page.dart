import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rest_api_implementation/constant/AppUrls.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_implementation/model_class/DataForHive.dart';
import 'package:rest_api_implementation/model_class/ShutterstockModel.dart';
import 'package:rest_api_implementation/screens/offline_gallery_screen.dart';


class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GalleryPageState();
  }
}

class GalleryPageState extends State<GalleryPage> {
  late bool _isLoading;
  late int _pageNumber;
  //ShutterstockModel? user;
  Data? user;
  DataForHive? dataForHiveUser;
  late final List<dynamic> _item = <dynamic>[];
  late Box _box;
  final ScrollController _scrollController = ScrollController();

  //region : Overridden Methods
  @override
  void initState() {
    super.initState();
   // _box = Hive.box<DataForHive>('shutterBox');
    _box = Hive.box('shutterBox');
    _initialiseScreenVariables();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _box?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      backgroundColor:  const Color(0xF5F5F5F5),
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
  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100), // Set this height
      child: Container(
        padding: const EdgeInsets.only(left: 30.0,top: 20),
        decoration: const BoxDecoration(
            color: Color(0xFF0C9869),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF000000),
                  offset: Offset.zero,
                  blurRadius: 0.0,
                  spreadRadius: 0.0),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(
              height: 10,
            ),
            Text(
              'Welcome:',
              style: TextStyle(
                color: Color(0xF5F5F5F5),
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'To the art gallery',
              style: TextStyle(
                  color: Color(0xF5F5F5F5),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_item.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return
        ListView.builder(
            controller: _scrollController,
            itemCount: _item.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < _item.length) {
                  user = Data.fromJson(_item.elementAt(index));
              }
              return Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  height: 300,
                  decoration: BoxDecoration(
                      color: Color(0xFFF9F8FD),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xFF000000),
                            offset: Offset.zero,
                            blurRadius: 0.0,
                            spreadRadius: 0.0),
                      ]),
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _getImageWidth(user),
                        style: const TextStyle(
                            color: Color(0xFF3C4046),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _getImageHeight(user),
                        style: const TextStyle(
                            color: Color(0xFF3C4046),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      index < _item.length
                          ? Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 200,
                        child: Image(
                          image: NetworkImage(_getImage(user)),
                          fit: BoxFit.fill,
                        ),
                      )
                          : const Center(child: CircularProgressIndicator()),
                    ],
                  ));
            }
        );
    }
    //}
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
    print("fetching api ");
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
      //var data = ShutterstockModel.fromJson(userData);
      if (newUserData.isNotEmpty) {
        _item.clear();
        _item.addAll(newUserData);
        print(_item.toString());
       _box.put(_pageNumber, newUserData);
       // addDataToHive;
        if (kDebugMode) {
          print(_box.values);
        }
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      print("response is null");

      setState(() {
        _isLoading = false;
      });
    }
  }

  void pagination() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _pageNumber += 5;
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

  String _getImageWidth(var user) {
    try {
      return "Width of Image : " + user.assets.preview1000!.width!.toString();
    } catch (e) {
      return e.toString();
    }
  }

  String _getImageHeight(var user) {
    try {
      return "Height of Image : " + user.assets.preview1000!.height!.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future addDataToHive(List<Data> data) async {
    /*for (var d in data) {
      // Map<dynamic, dynamic> newdata = {"url": d.assets.preview.url, "width": d.width, "height" : d.height};
      var model = DataForHive(url : d.assets!.preview!.url!, width : d.assets!.preview!.width, height : d.assets!.preview!.height)
      _box.add(newdata);
    }*/
  }

  void _openOfflineGalleryScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const OfflineGalleryScreen()));
  }

//endregion

}
