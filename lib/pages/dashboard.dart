import 'package:flutter/material.dart';

// Models
import '../models/news_newstile.dart';

// Scripts
import '../scripts/news_framework.dart';
import '../scripts/fas.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Colors
  final Color unselected1 = Colors.white;
  final Color selected1 = const Color.fromARGB(255, 59, 89, 179);
  final Color unselected2 = Colors.black;
  final Color selected2 = Colors.white;

  int _selected = 0;

  // Data
  List<NewsTile> news = [];

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to log out?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Clear data from SecureStore
                  SecureStore.delete("user/email");
                  SecureStore.delete("user/password");
                  SecureStore.delete("user/time");

                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();

    // Call api
    News.getNews().then((news) {
      if (news == null) {
        return;
      }

      setState(() {
        this.news = news;
      });
    });
  }

  Widget getCard(int index) {
    return Container(
      key: Key(news[index].id.toString()),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: -22,
            offset: const Offset(0, 10), // Shadow position
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const SizedBox(width: 10),
              InkWell(
                // splashColor: Colors.transparent,
                onTap: () {
                  if (news[index].favourite) {
                    // Remove from favourites

                    setState(() {
                      news[index].favourite = false;

                      SecureStore.delete("favourites/${news[index].id}");
                    });
                  } else {
                    // Add to favourites

                    setState(() {
                      news[index].favourite = true;

                      SecureStore.write("favourites/${news[index].id}", "true");
                    });
                  }
                },
                child: Icon(
                  news[index].favourite
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  size: 50,
                  color: news[index].favourite ? Colors.pink : Colors.black,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      news[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      news[index].summary,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      news[index].published,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView.builder(
              itemBuilder: (ctx, i) =>
                  _selected == 0 || (_selected == 1 && news[i].favourite)
                      ? Column(
                          children: [
                            getCard(i),
                            SizedBox(height: i == news.length - 1 ? 75 : 0),
                          ],
                        )
                      : const SizedBox(),
              itemCount: news.length,
            ),
            Positioned(
              left: -4,
              right: -4,
              bottom: -5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selected = 0;
                        });
                      },
                      child: SizedBox(
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          color: _selected == 0 ? selected1 : unselected1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 50,
                                  color:
                                      _selected == 0 ? selected2 : unselected2,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "News",
                                  style: TextStyle(
                                    fontSize: 29,
                                    fontWeight: FontWeight.bold,
                                    color: _selected == 0
                                        ? selected2
                                        : unselected2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selected = 1;
                        });
                      },
                      child: SizedBox(
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          color: _selected == 1 ? selected1 : unselected1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  size: 50,
                                  color: Colors.pink,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Favs",
                                  style: TextStyle(
                                    fontSize: 29,
                                    fontWeight: FontWeight.bold,
                                    color: _selected == 1
                                        ? selected2
                                        : unselected2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
