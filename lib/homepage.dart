import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isscrolling = false;
  bool isSearching = false;
  List<bool> followStatus = List<bool>.generate(15, (index) => false);
  TextEditingController searchController = TextEditingController();

  void _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.scrollDelta! > 0) {
        // Scrolling down
        setState(() {
          isscrolling = true;
        });
      } else if (notification.scrollDelta! < 0) {
        // Scrolling up
        setState(() {
          isscrolling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //here if not searching and
        preferredSize: isscrolling == false && isSearching == false
            ? const Size(300, 290)
            : const Size(300, 70),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isscrolling == false && isSearching == false
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(176, 0, 0, 0)),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ))
                : Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: isscrolling == false && isSearching == false
                ? _weekendcommunity()
                : _scrollupAppbar(),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          _onScroll(scrollNotification);
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isSearching == false) ...[
                //widget for showing paragraph
                _paragraphwidget(),

                //widget for showing outdoor widget
                _outdoorwidget(),

                //widget for media,docs, link
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Media, docs and link',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),

                //scrolling widget
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _scrollweekend(),
                      _scrollweekend(),
                      _scrollweekend(),
                      _scrollweekend(),
                    ],
                  ),
                ),

                //widget for mute notification
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mute Notification',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Image(
                        image: AssetImage("assets/notification.png"),
                      ),
                    ],
                  ),
                ),

                //wideget for list
                Column(
                  children: [
                    _listtilewidget(
                        imag: "assets/trash.png", title: 'Clear chat'),
                    _listtilewidget(
                        imag: "assets/lock.png", title: 'Encryption'),
                    _listtilewidget(
                        imag: "assets/logout.png",
                        title: 'Exit Community',
                        col: Colors.red),
                    _listtilewidget(
                        imag: "assets/dislike.png",
                        title: 'Report',
                        col: Colors.red),
                  ],
                ),

                //widgets for members
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Members',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSearching = !isSearching;
                          });
                        },
                        child: const Image(
                          image: AssetImage("assets/search.png"),
                        ),
                      ),
                    ],
                  ),
                ),

                //list of members
                Column(
                  children: [
                    for (int i = 0; i < 15; i++) _listofmember(follow: i),
                  ],
                ),
              ] else ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: '  Search member',
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors
                                        .transparent), // No border on focus
                                borderRadius: BorderRadius.circular(25),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors
                                        .transparent), // No border when enabled
                                borderRadius: BorderRadius.circular(25),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          setState(() {
                            isSearching = false;
                            searchController.clear(); // Clear search text
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
                // List of members
                Column(
                  children: [
                    for (int i = 0; i < 15; i++) _listofmember(follow: i),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // widget for showing weekend community
  Widget _weekendcommunity() {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/weekend.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: 70,
            color: const Color.fromARGB(231, 206, 41, 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //widget for weekend community text
                _weekendDetails(),

                const SizedBox(
                  width: 70,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white)),
                  child: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Widget when scroll up
  Widget _scrollupAppbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 70,
      color: const Color.fromARGB(231, 206, 41, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
          ),
          const Expanded(
            child: ClipOval(
              child: Image(
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/weekend.png',
                  )),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          //widget for weekend community text
          _weekendDetails(),
          const SizedBox(
            width: 70,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      child: Column(
                        children: [
                          _bottomsheettile(
                              imag: 'assets/link.png', title: 'Invite'),
                          _bottomsheettile(
                              imag: 'assets/add_user.png', title: 'Add member'),
                          _bottomsheettile(
                              imag: 'assets/add_group.png', title: 'Add Group'),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Image(image: AssetImage('assets/more.png')),
            ),
          ),
        ],
      ),
    );
  }

  //bottomsheet tile
  Widget _bottomsheettile({required String imag, required String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image(image: AssetImage(imag)),
        title: Text(title),
        onTap: () {
          // Handle
          Navigator.pop(context);
        },
      ),
    );
  }

  //weekend details widget
  Widget _weekendDetails() {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align children to the start horizontally
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'The weekend',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.start,
        ),
        Row(
          children: [
            Text(
              'Community',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.circle,
              size: 6,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.add,
              size: 12,
              color: Colors.white,
            ),
            Text(
              '11K Members',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ],
        )
      ],
    );
  }

  //widget for showing paragraph
  Widget _paragraphwidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(fontWeight: FontWeight.bold),
          text:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod vestibulum lacus, nec consequat nulla efficitur sit amet. Proin eu lorem libero. Sed id enim in urna tincidunt sodales. Vivamus vel semper ame...',
          children: <TextSpan>[
            TextSpan(
              text: 'Read more',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  //widget for showing outdoor widget
  Widget _outdoorwidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) _outdoorbutton(),

          //widget for showing +1 button
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red),
              color: Colors.white,
            ),
            child: const Text(
              '+1',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  //widget for showing the outdoor buttons
  Widget _outdoorbutton() {
    return Expanded(
      child: Container(
        height: 30,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(top: 5, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red),
          color: Colors.white,
        ),
        child: const Text(
          'Outdoor',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  //widget for scroll container
  Widget _scrollweekend() {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      width: 100,
      height: 100, // Set the desired height here
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/weekend.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _listtilewidget(
      {required String imag, required String title, Color? col}) {
    return ListTile(
      leading: Image(
        image: AssetImage(imag),
      ),
      title: Text(
        title,
        style: TextStyle(color: col),
      ),
    );
  }

  Widget _listofmember({required int follow}) {
    return ListTile(
        leading: const ClipOval(
          child: Image(
            image: AssetImage('assets/girl.png'),
            width: 50, // Adjust the width and height as needed
            height: 50,
            fit: BoxFit.cover, // Ensures the image covers the circular area
          ),
        ),
        title: const Text('Yashika'),
        subtitle: const Text('29, India'),
        trailing: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: followStatus[follow]
                ? MaterialStateProperty.all<Color>(Colors.grey)
                : MaterialStateProperty.all<Color>(Colors.pink.shade500),
          ),
          child: Text(
            followStatus[follow] ? 'Following' : 'Add',
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              followStatus[follow] = !followStatus[follow];
            });
          },
        ));
  }
}
