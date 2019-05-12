import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

void main() {
  runApp(new MaterialApp(
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void newsData() async {
    Map data = await getNews();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Flu-News"),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: new Container(
        child: allNewsToListView(),
      ),
    );
  }
}

Future<Map> getNews() async {
  String newsApi =
      "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=97f023a6ba294cd79bbb566c66c07fb0";

  http.Response response = await http.get(newsApi);

  return json.decode(response.body);
}

Widget allNewsToListView() {
  return FutureBuilder(
      future: getNews(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List allArticlesData = snapshot.data["articles"];

          debugPrint("data ${allArticlesData.length}");
          //for (int i = 0; i < allArticlesData.length; i++){

          return new ListView.builder(
              itemCount: allArticlesData.length,
              itemBuilder: (BuildContext context, int position) {
                final index = position ~/ 2;
                if (position.isOdd) return new Divider();
                return new ListTile(
                  title: Text(allArticlesData[index]['title'].toString(),
                      style: new TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  subtitle: Text(
                    allArticlesData[index]['content'].toString() + " ...",
                    style: new TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                    maxLines: 4,
                  ),
                  leading: new Card(
                    elevation: 5,
                    child: new FadeInImage.assetNetwork(
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      placeholder: "images/ph.png",
                      image: allArticlesData[index]['urlToImage'],
                    ),
                  ),
                  onTap: () {
                    var route =
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new DetailsPage(
                          allArticlesData[index]['title'] == null
                              ? "Unknown"
                              : allArticlesData[index]['title'],
                          allArticlesData[index]['content'] == null
                              ? "Unknown"
                              : allArticlesData[index]['content'],
                          allArticlesData[index]['publishedAt'] == null
                              ? "Unknown"
                              : allArticlesData[index]['publishedAt'],
                          allArticlesData[index]['urlToImage'] == null
                              ? "Unknown"
                              : allArticlesData[index]['urlToImage'],
                          allArticlesData[index]['url'] == null
                              ? "Unknown"
                              : allArticlesData[index]['url'],
                          allArticlesData[index]['author'] == null
                              ? "Unknown"
                              : allArticlesData[index]['author'],
                          allArticlesData[index]['source']['name'] == null
                              ? "Unknown"
                              : allArticlesData[index]['source']['name']);
                    });
                    Navigator.push(context, route);
                  },
                );
              });
          //}
        } else if (snapshot.hasError) {
          return new Container();
        } else {
          return new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Colors.cyan,
            ),
          );
        }
      });
}

class DetailsPage extends StatefulWidget {
  String title;
  String details;
  String publishedAt;
  String imageUrl;
  String mainNewsUrl;
  String author;
  String source;

  DetailsPage(this.title, this.details, this.publishedAt, this.imageUrl,
      this.mainNewsUrl, this.author, this.source);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: EdgeInsets.all(8),
          child: new Column(
            children: <Widget>[
              new Card(
                elevation: 8,
                child: new FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    height: 250,
                    placeholder: "images/ph.png",
                    image: widget.imageUrl),
              ),
              new Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                child: new Text(
                  widget.title,
                  style: new TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              new Padding(padding: EdgeInsets.all(4)),
              new Row(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.person,
                          color: Colors.blueGrey,
                        ),
                        new Padding(padding: EdgeInsets.all(2)),
                        new Text(
                          widget.author,
                          style: new TextStyle(
                              fontSize: 15, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(left: 100),
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.access_time,
                          color: Colors.blueGrey,
                        ),
                        new Padding(padding: EdgeInsets.all(2)),
                        new Text(
                          widget.publishedAt
                              .substring(0, widget.publishedAt.indexOf('T')),
                          style: new TextStyle(
                              fontSize: 15, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              new Padding(padding: EdgeInsets.all(4)),
              new Row(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.android,
                          color: Colors.blueGrey,
                        ),
                        new Padding(padding: EdgeInsets.all(2)),
                        new Text(
                          widget.source,
                          style: new TextStyle(
                              fontSize: 15, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(left: 40),
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _openInWebView(widget.mainNewsUrl, context);
                        },
                        child: new Row(
                          children: <Widget>[
                            new Icon(
                              Icons.open_in_new,
                              color: Colors.blue,
                            ),
                            new Padding(padding: EdgeInsets.all(1)),
                            new Text(
                              "Source Link",
                              style: new TextStyle(
                                  color: Colors.blue, fontSize: 16),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              new Padding(padding: EdgeInsets.all(8)),
              Container(
                  margin: EdgeInsets.all(4),
                  child: new Text(
                  widget.details,
                    style: new TextStyle(color: Colors.blueGrey,fontSize: 20),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

Future<Null> _openInWebView (String url,BuildContext context) async{
  if(await launcher.canLaunch(url)){

    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context){
        return WebviewScaffold(
          initialChild: Center(child: CircularProgressIndicator()),
          url: url,
          appBar: AppBar(
            title: Text(url),
          ),
        );
      })
    );

  }else{
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("URL $url can not be launched"))
    );
  }
}
