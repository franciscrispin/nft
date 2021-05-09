import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        'favorites': (_) => FavoritePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Nft>>? _nftsFuture;
  final _favourites = <Nft>{};

  @override
  void initState() {
    super.initState();
    _nftsFuture = _fetchNfts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _goToFavourites),
        ],
      ),
      // Gets a snapshot of the future and builds a widget.
      // The snapshot includes information about the future such its connection
      // state and the error or data returned.
      body: FutureBuilder<List<Nft>>(
        future: _nftsFuture,
        builder: (context, snapshot) {
          // Returns a progress indicator if the future has not completed.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Else assume no errors.
          // Pass the data from the snapshot to build the nft list.
          return _buildNftList(snapshot.data!);
        },
      ),
    );
  }

  // Navigates to the favorite route.
  void _goToFavourites() {
    Navigator.of(context).pushNamed('favorites', arguments: _favourites);
  }

  // Creates a scrollable list.
  Widget _buildNftList(List<Nft> nfts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // The itemBuilder callback is called once for each item in the list.
      itemBuilder: (BuildContext _context, int index) => _buildRow(nfts[index]),
      itemCount: nfts.length,
    );
  }

  Widget _buildRow(Nft nft) {
    final isSaved = _favourites.contains(nft);
    return Column(
      children: [
        Stack(
          children: [
            Image.network(nft.asset!),
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                color: Colors.blue[700],
                padding: const EdgeInsets.all(8),
                child: Text(
                  nft.coin!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nft.name!,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    nft.price!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? Colors.red : Colors.grey,
                size: 30,
              ),
              onTap: () {
                setState(() {
                  if (isSaved) {
                    _favourites.remove(nft);
                  } else {
                    _favourites.add(nft);
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saved = ModalRoute.of(context)?.settings.arguments as Set<Nft>;
    final tiles = saved.map(
      (Nft nft) => ListTile(
        title: Text(
          nft.name!,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: tiles.isEmpty
          ? Container()
          : ListView(
              children:
                  ListTile.divideTiles(context: context, tiles: tiles).toList(),
            ),
    );
  }
}

// Mock data and helper methods. Do not edit.

/// The nft model.
class Nft {
  const Nft({this.name, this.price, this.coin, this.asset});

  final String? name;
  final String? price;
  final String? coin;
  final String? asset;

  // Converts the json representation of the nft to the nft model.
  factory Nft.fromJson(Map<String, dynamic> json) {
    return Nft(
      name: json['name'] as String,
      price: json['price'] as String,
      coin: json['coin'] as String,
      asset: json['asset'] as String,
    );
  }
}

Future<List<Nft>> _fetchNfts() async {
  final response = await _mockGetNftsNetworkRequest();
  return _decodeNfts(response);
}

Future<List<String>> _mockGetNftsNetworkRequest() {
  return Future.delayed(Duration(seconds: 1), () {
    return _jsonNfts;
  });
}

List<Nft> _decodeNfts(List<String> jsonNfts) {
  return jsonNfts.map<Nft>(
    (jsonString) {
      final parsedJson = json.decode(jsonString) as Map<String, dynamic>;
      return Nft.fromJson(parsedJson);
    },
  ).toList();
}

const List<String> _jsonNfts = [
  '''
  {
    "name": "Homer Pepe",
    "price": "320,000",
    "coin": "ETH",
    "asset": "https://s3.cointelegraph.com/uploads/2021-03/b369da86-76ae-4a9a-b74b-3697a24c8ee3.png"
  }''',
  '''
  {
    "name": "The EverLasting Beautiful",
    "price": "550,000",
    "coin": "ETH",
    "asset": "https://res.cloudinary.com/nifty-gateway/video/upload/q_jpegmini,w_600,so_0/v1614644534/Ashley/FewoCollaboration/3_The_EverLasting_Beautiful_-_FEWOCiOUS_rzuxao.jpg"
  }''',
  '''
  {
    "name": "Nyan Cat",
    "price": "580,000",
    "coin": "ETH",
    "asset": "https://cdn.vox-cdn.com/thumbor/8KxJUDwQsz5Qy-_HzZjtCTRR5PU=/0x164:1440x884/fit-in/1200x600/cdn.vox-cdn.com/uploads/chorus_asset/file/22310830/NmJgg.jpg"
  }''',
  '''
  {
    "name": "The Smintons",
    "price": "1.65 Million",
    "coin": "ETH",
    "asset": "https://media.niftygateway.com/image/upload/q_auto:good,w_800/v1610584870/A/JustinRoiland/010_the_smintons_zxs3tm.png"
  }''',
  '''
  {
    "name": "CryptoPunk #3100",
    "price": "7.58 Million",
    "coin": "ETH",
    "asset": "https://static0.srcdn.com/wordpress/wp-content/uploads/2021/04/CryptoPunk-3100-NFT.jpeg?q=50&fit=crop&w=740&h=370&dpr=1.5 740w"
  }''',
  '''
  {
    "name": "Everydays—The First 5000 Days",
    "price": "69 Million",
    "coin": "ETH",
    "asset": "https://upload.wikimedia.org/wikipedia/en/thumb/d/d4/Everydays%2C_the_First_5000_Days.jpg/300px-Everydays%2C_the_First_5000_Days.jpg"
  }''',
];
