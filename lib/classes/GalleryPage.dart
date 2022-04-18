import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api_implementation/constant/AppUrls.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_implementation/model_class/Data.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {

        },
      ),    );
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
    }
    else if (_item.isEmpty) {
      return const Center(child: Text('List is empty :('));
    }
    else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: _item.length,
        itemBuilder: (BuildContext context, int index) {
          Data user = Data.fromJson(_item.elementAt(index));
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
              image: NetworkImage(_getImage(user)),
              fit: BoxFit.fill,
            ),
          );
        },
      );
    }
  }

  //endregion

  //region : Private Methods

  void _initialiseScreenVariables() {
    _isLoading = true;
    _pageNumber = 1;
    _scrollController.addListener(pagination);
    _getDataFromApi();
  }

  Future<void> _getDataFromApi() async {
    setState(() {
      _isLoading = true;
    });
    Uri uri = Uri.parse(AppUrls.baseUrl +
        AppUrls.imageSearch +
        '?page=$_pageNumber&per_page=10');
    final response = await http.get(
      uri,
      headers: {'Authorization': AppUrls.header},
    );

    if (response.statusCode == 200) {
      dynamic userData = json.decode(response.body);
      List<dynamic> newUserData = userData['data'];
      if (newUserData.isNotEmpty) {
        _item.addAll(newUserData);
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
      _pageNumber++;
      _getDataFromApi();
    }
  }

  String _getImage(var user) {
    try {
      return user.assets.preview1000!.url!.toString();
    } catch (e){
      return e.toString();
    }
  }

 //endregion

}
