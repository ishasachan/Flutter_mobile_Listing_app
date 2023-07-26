import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../firebase_options.dart';
import '../models/filter_model.dart';
import '../models/product_model.dart';
import '../widgets/filter_dialog_widget.dart';
import '../widgets/product_card_widget.dart';
import 'notification_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> brandNames = [];
  Map<String, List<String>> brandModelsMap = {};
  bool showSearchResult = false;
  RemoteMessage? _lastMessage;

  void _searchModels(String searchModel) async {
    if (searchModel.isEmpty) {
      setState(() {
        brandNames.clear();
        brandModelsMap.clear();
        showSearchResult = false;
      });
      return;
    }

    const url =
        'https://dev2be.oruphones.com/api/v1/global/assignment/searchModel';

    final response = await http.post(
      Uri.parse(url),
      body: {'searchModel': searchModel},
    );

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    debugPrint(response.body);

    setState(() {
      if (responseData.containsKey('makes')) {
        brandNames = List<String>.from(responseData['makes']);
      } else {
        brandNames.clear();
      }

      brandModelsMap = {};
      if (responseData.containsKey('models')) {
        brandModelsMap['Models'] = List<String>.from(responseData['models']);
      }

      for (final brand in brandNames) {
        if (responseData.containsKey(brand)) {
          brandModelsMap[brand] = List<String>.from(responseData[brand]);
        }
      }

      showSearchResult = true;
    });
  }

  //Products Functionality
  List<Product> products = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreProducts = true;
  int _currentPageIndex = 0;
  bool isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadProducts();
    _initializeFirebaseMessaging();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _messageStreamController.close();
    super.dispose();
  }

  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
  }

  // Firebase Messaging initialization and stream subscription
  void _initializeFirebaseMessaging() async {
    await Firebase.initializeApp();

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }

    const vapidKey = "AIzaSyBzyGYtpNvTkSStT47EgpggiV79BicF5eU";

    String? token;

    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      token = await messaging.getToken(
        vapidKey: vapidKey,
      );
    } else {
      token = await messaging.getToken();
    }

    if (kDebugMode) {
      print('Registration Token=$token');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }

      // Store the last message received in the _lastMessage variable
      setState(() {
        _lastMessage = message;
      });

      //Show the notification screen when a message is received
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(
            title: message.notification?.title ?? 'No Title',
            body: message.notification?.body ?? 'No Body',
          ),
        ),
      );

      _messageStreamController.sink.add(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }


  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadProducts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final url =
        'https://dev2be.oruphones.com/api/v1/global/assignment/getListings?page=$currentPage&limit=10';

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final listings = responseData['listings'] as List<dynamic>;

      final List<Product> fetchedProducts =
          listings.map((item) => Product.fromJson(item)).toList();

      if (fetchedProducts.isEmpty) {
        hasMoreProducts = false;
      } else {
        setState(() {
          products.addAll(fetchedProducts);
          isLoading = false;
          currentPage++;
        });
      }
    } catch (error) {
      debugPrint('Error fetching products: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (isLoadingMore || !hasMoreProducts) return;

    setState(() {
      isLoadingMore = true;
    });

    final url =
        'https://dev2be.oruphones.com/api/v1/global/assignment/getListings?page=$currentPage&limit=10';

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final listings = responseData['listings'] as List<dynamic>;

      final List<Product> fetchedProducts =
          listings.map((item) => Product.fromJson(item)).toList();

      if (fetchedProducts.isEmpty) {
        hasMoreProducts = false;
      } else {
        setState(() {
          products.addAll(fetchedProducts);
          isLoadingMore = false;
          currentPage++;
        });
      }
    } catch (error) {
      debugPrint('Error fetching products: $error');
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  //Filters
  Filter? filters;

  // Fetch filters function
  Future<void> _fetchFilters() async {
    const url =
        'https://dev2be.oruphones.com/api/v1/global/assignment/getFilters?isLimited=true';

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      setState(() {
        filters = Filter.fromJson(responseData['filters']);
      });
    } catch (error) {
      debugPrint('Error fetching filters: $error');
    }
    finally{
      _showFilterMenu();
    }
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: FilterMenu(
            filters: filters ??
                Filter(make: [], condition: [], storage: [], ram: [], warranty: [], verification: []),
            onMakeSelected: (selectedMake) {
              // Handle make selection here
            },
            onConditionSelected: (selectedCondition) {
              // Handle condition selection here
            },
            onRamSelected: (selectedRam) {
              // Handle RAM selection here
            },
            onStorageSelected: (selectedStorage) {
              // Handle storage selection here
            },
          ),
        );
      },
    );
  }

  final List<String> imagePaths = [
    'images/banner2.png',
    'images/banner3.png',
    'images/banner2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 45, 46, 64),
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showSearchResult = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      'images/logo.png',
                      width: 120,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Location icon (you can replace this with your icon)
                const Text(
                  "India",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(
                          title: _lastMessage?.notification?.title ?? '',
                          body: _lastMessage?.notification?.body ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(50), // Set the height of the second row
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Search',
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search functionality here
                _searchModels(value);
                setState(() {
                  showSearchResult = true;
                });
                debugPrint(value);
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Buy Top Brands',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('images/brand1.png', width: 80, height: 80),
                    Image.asset('images/brand2.png', width: 80, height: 80),
                    Image.asset('images/brand3.png', width: 80, height: 80),
                    Image.asset('images/brand4.png', width: 80, height: 80),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: imagePaths.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      imagePaths[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < imagePaths.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPageIndex == i ? 12 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPageIndex == i ? Colors.blue : Colors.grey,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Shop By',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 4, // Replace this with the number of categories you want to display
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String iconAssetPath;
                    String categoryName;

                    List<String> iconAssetPaths = [
                      'images/category1.png',
                      'images/category2.png',
                      'images/category3.png',
                      'images/category4.png',
                    ];
                    List<String> categoryList = ['BestSelling Mobiles', 'Verified Devices Only', 'Like New Condition', 'Phones With Warranty'];

                    iconAssetPath = iconAssetPaths[index];
                    categoryName = categoryList[index];

                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(iconAssetPath, height: 50, width: 50),
                            const SizedBox(height: 8),
                            Text(
                              textAlign: TextAlign.center,
                              categoryName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12,),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),


              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Best Deals Near You',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'India',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          child: const Text(
                            'Filter',
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            _fetchFilters();
                          },
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _fetchFilters();
                          },
                            child: const Icon(Icons.sort),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Product List
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: products.length + 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == products.length) {
                    return isLoadingMore
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox();
                  } else {
                    final product = products[index];
                    return ProductCard(product: product);
                  }
                },
              ),
            ],
          ),

          //Search Background
          if (showSearchResult)
            Positioned.fill(
              top: 0,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Brand',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (brandNames.isNotEmpty)
                        for (final brand in brandNames)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                brand,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),

                      // Show the "Models" section if it contains models
                      if (brandModelsMap.containsKey('Models'))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Mobile Models',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            for (final model in brandModelsMap['Models']!)
                              ListTile(
                                title: Text(
                                  model,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                          ],
                        ),

                      const SizedBox(height: 250,)
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


