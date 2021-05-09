# nft

View and save reasonably priced nfts.

[Demo](assets/nft-demo.gif)

# 1. Build the card layout

- Create the [Card Layout](assets/card.png) in the `_buildRow` method
- Fix the `onTap` function in `GestureDetector`. When the favorite icon is tapped, the icon should change color and the nft should be added/removed from the favourites page

# 2. Fetch data asynchronously

- Fetch data using the `_fetchNfts` function

# 3. Refactor navigation

- Extract the code in the `_goToFavourites` method into a `FavoritePage` StatelessWidget
- Refactor to use the `routes` param for navigation
