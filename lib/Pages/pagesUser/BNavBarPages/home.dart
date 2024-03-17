import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_proj_on_github/Pages/pagesUser/BNavBarPages/workerslist.dart';



import '../../../Domain/customAppBar.dart';
import '../../../Domain/themeNotifier.dart';
import '../../menu.dart';
import '../reqCategory.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey, showSearchBox: true),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('services').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
          }
          
          return Padding(
            padding:
            const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: context.watch<ThemeNotifier>().isDarkModeEnabled ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 15,
                    mainAxisExtent: 125
                ),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var document = snapshot.data?.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  WorkersList()));
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFFBBA2BF),
                              shape: BoxShape.rectangle,
                            ),
                            child: Image.network(
                              document?['image_url'], // Assuming 'image_url' is the field in Firestore document representing category image URL
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Placeholder icon if image loading fails
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            document?['name'], // Assuming 'name' is the field in Firestore document representing category name
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ReqCategory()));
        },
        backgroundColor: const Color(0xFFBBA2BF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_chart_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: Menu(scaffoldKey: _scaffoldKey,),
    );
  }
}
