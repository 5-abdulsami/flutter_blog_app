import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blog_app/screens/add_post_screen.dart';
import 'package:flutter_blog_app/screens/detail_screen.dart';
import 'package:flutter_blog_app/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child('Posts');
  final auth = FirebaseAuth.instance;
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('New Blogs'),
          centerTitle: true,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPostScreen()));
                },
                child: const Icon(Icons.add)),
            const SizedBox(
              width: 20,
            ),
            InkWell(
                onTap: () {
                  auth.signOut().then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  });
                },
                child: const Icon(Icons.logout)),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Blogs',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: dbRef.child('Posts List'),
                  itemBuilder: ((context, snapshot, animation, index) {
                    //retrieve data from firebase as Map
                    var data = snapshot.value as Map<dynamic, dynamic>;
                    //store title name
                    String tempTitle = data['pTitle'];
                    //filtering based on searchController value
                    if (searchController.text.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        title: data['pTitle'],
                                        description: data['pDescription'],
                                        image: data['pImage'])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          'assets/images/blog_logo.png',
                                      image: data['pImage'],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data['pTitle'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        height: 1.3),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data['pDescription'],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(height: 1.25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (tempTitle
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        title: data['pTitle'],
                                        description: data['pDescription'],
                                        image: data['pImage'])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          'assets/images/blog_logo.png',
                                      image: data['pImage'],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data['pTitle'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        height: 1.3),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data['pDescription'],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(height: 1.25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
