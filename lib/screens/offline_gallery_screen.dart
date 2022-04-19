import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rest_api_implementation/constant/AppUrls.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_implementation/model_class/DataForHive.dart';
import '../model_class/Data.dart';

late Box _box;

class OfflineGalleryScreen extends StatefulWidget {
  const OfflineGalleryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OfflineGalleryScreenState();
  }
}

class OfflineGalleryScreenState extends State<OfflineGalleryScreen> {
  late bool _isLoading;
  late int _pageNumber;
  late Data user;
  late final List<dynamic> _item = <dynamic>[];
  final ScrollController _scrollController = ScrollController();

  //region : Overridden Methods
  @override
  void initState() {
    super.initState();
    _initialiseScreenVariables();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _box.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_item.isEmpty) {
      return const Center(child: Text('List is empty :('));
    } else {
      return ListView.builder(
          controller: _scrollController,
          itemCount: _item.length,
          itemBuilder: (BuildContext context, int index) {
            user = Data.fromJson(_item.elementAt(index));
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
              child: Image(
                image: NetworkImage(_getImageUrl(user)),
                fit: BoxFit.fill,
              ),
            );
          });
    }
  }

  //endregion

  //region : Private Methods

  void _initialiseScreenVariables() {
    _isLoading = true;
    _pageNumber = 1;
    _scrollController.addListener(_initPagination);
    _box = Hive.box('shutterBox');
    _getDataFromHive();
  }

  Future<void> _getDataFromHive() async {
    setState(() {
      _isLoading = true;
    });
    try {
      dynamic userData = _box.get(_pageNumber);
      List<dynamic> newUserData = userData['data'];

      if (newUserData.isNotEmpty) {
        _item.addAll(newUserData);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('_getDataFromHive: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initPagination() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _pageNumber++;
      _getDataFromHive();
    }
  }

  String _getImageUrl(var user) {
    try {
      return user.assets.preview1000!.url!.toString();
    } catch (e) {
      return e.toString();
    }
  }

//endregion

}
