
<p align="center"><img width="400" src="./client/assets/icons/icon-512x512-ios.png" alt="App logo"></p>

<p align="center">
<img  src="https://img.shields.io/github/stars/MovieNightCC/MovieNight" alt="starts">
</p>
<h1>Table of Contents</h1>
<h4><a href="#intro"> 1. Introduction </a></h4>
<h4><a href="#user_guide"> 2. User Guide </a></h4>
<h4><a href="#tech_stack"> 3. Tech Stack </a></h4>
<h4><a href="#contacts">4. Contact Us </a></h4>
<h1 id="intro">Introduction</h1>
Movie Night is a Movie-swiping app to bring you a seamless and painless Movie Night Experience. <br/>
The App is available on Google Play store: https://play.google.com/store/apps/details?id=movienight.cc.app
<h1 id="user_guide">User Guide</h1>
<h3><b>User Registration:</b></h3>
Upon opening the App, you need to register your account. In order to get the full Movie Night Experience the user should connect with a pair who already has a Movie Night account.
<h3><b>Swiper:</b></h3>
Swiper consists of different movies from the Netflix JP database. If you swipe right (✅like) a movie, it will be recorded in the FireStore database which has two effects: 
<br>
<p>  1. Our <b>Recommendation Algorithm</b> Reacts to the user's habits and updates your movie feed using an algorithm based on the <a href="https://en.wikipedia.org/wiki/Distance_matrix">distance matrix</a>.
<p>  2. Our <b>Matches Mechanism</b> that tracks if you and your partner (in a pair 👽👽) has a match.

When you have a match, you will see an alert box if you are the second swiper; or a notification message, if you are the first swiper and do not currently have the app open.

If you click on the movie poster, you can see the details of a movie including title, synopsis, genre and runtime. From the Movie Info screen you can also like ✅ or dislike ❌ a movie as well see detailed movie information on Netflix.

<h3><b>Genre Filter:⚙️</b></h3>
You can also click on the filter button to filter movies by genre. We have over 10 genres: Sci-Fi, romance, Horror and many more. The user can choose to see multiple genres in their feed.
<h3><b>Rush Mode:🚄</b></h3>
Rush Mode is for people who want to find a movie to watch fast ⚡️. Pairs who still have no match can use this feature to make a decision. In this mode, you and your partner will have a 30-seconds swiping session synchronously with the same movies provided.
<h3><b>Matches:✅ ✅</b></h3>
in Matches you can see all the past match you and your partner has made. You can click on the movie poster to see the movie info, and inside you can delete the  movie (which deletes it from your list of match history).
<h3><b>Profile:🙂</b></h3>
in Profile, you can see you user information and what pair you belong to. You can also upload your own profile picture, which will be shown in the rush mode screen. from the profile screen you can also link with your pair.
<h1 id="tech_stack">Tech Stack📱</h1>
Front-end: Flutter <br>
Back-end: Firebase Firestore, Firebase Storage, Firebase Cloud Messaging
Platform: Android 

<h1 id="contacts">Contact Us📬</h1>
For questions and support please contact the developers: <br><br>
<p><a href="https://github.com/OnigiriJack">Jack Fowler</a> 
Mobile front-end logic and iOS build
</p>
<p> 
<a href="https://github.com/kenny01123">Kenny  Ng</a>
Firestore database and flutter front-end connections
</p>
<p> <a href="https://github.com/dhequex">Jose M. Torres</a> UI/UX developer: UI Design, User Authentication and Android build
</p>
<p> <a href="https://github.com/alexdang1993374">Alex Dang</a> Front-End developer: mobile front-end logic
</p>

<br>
<h6>This was developed during our time as students at <a href="https://github.com/codechrysalis">Code Chrysalis</a>.</h6>
