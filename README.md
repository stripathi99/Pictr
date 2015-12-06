# Pictr

##Introduction

Pictr is an iOS app for discovering new movies of your choice.
The movie information is fetched from TMDB API.

You can add movies to your Watch or Favorites List.

You can use Pictr to discover new movies using the Genre tab or search for your 
favorite movies by title from the Search tab.

There are 4 tabs available:
    
   - Movies: Displays the movies as:
     1. Now Playing
     
        ![Now Paying](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/NowPlaying.png)

     2. Top Rated
     
        ![Top Rated](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/TopRated.png)

     3. Popular
     
        ![Popular](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/Popular.png)

     4. Upcoming
     
        ![Upcoming](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/Upcoming.png)
     
    The navigation across the above four is handled via Sidebar menu, implemented using SWRevealViewController libarary
    https://github.com/John-Lluch/SWRevealViewController
    
    ![Sidebar Menu](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/SidebarMenu.png)
     
     Movie Details:
     Clicking on a Movie displays the details: Manga title, year, vote average, vote count and overview

    ![Movie Details tab](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/MovieDetail.png)
     
   - Genres: Displays movie genres alphabetically. Clicking on a genre displays the movies related to that genre
     
    ![Genres tab](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/Genres.png)
     
   - Search: Provides users search functionality by movie title. Clicking on a search
     result display movie details.

    ![Search tab](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/Search.png)
     
   - My Lists: Provides Watch List and Favorites List. Movies are added or removed from 
     these two lists in the Movie Details view. Clicking on a movie in the My Lists tab
     will show movie details.

    ![My List tab](https://raw.githubusercontent.com/coolshubh4/Pictr/master/Screenshots/WatchList.png)
