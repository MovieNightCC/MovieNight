# how to use the Cloud Functions
Use the URL provided by firestore to access the functons

## list of functions
helloWorld (https://asia-northeast1-movie-night-cc.cloudfunctions.net/helloWorld)
Just a helloworld. You can use it to check the connection to firebase.

getAllUsers (https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllUsers)
Showing all users information

getAllMovies (https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies)
Showing all movies information

getUserByUserName (https://asia-northeast1-movie-night-cc.cloudfunctions.net/getUserByUserName)
    query params: userName (?userName=<userName>)
retrieving user's info by its username.

getPairByPairName (https://asia-northeast1-movie-night-cc.cloudfunctions.net/getPairByPairName)
    query params: pairName (?pairName=<pairName>)
retrieving pair's info by its pairName.

createUser (https://asia-northeast1-movie-night-cc.cloudfunctions.net/createUser)
    query params: userName,email,name
    (?userName=<userName>&email=<userEmail>&name=<name>)
initalizing a user with empty likes,dislikes and pair belonged

updateUserLikes (https://asia-northeast1-movie-night-cc.cloudfunctions.net/updateUserLikes)
    query params: userName,movieArr
    (?userName=<userName>&movieArr=<An Array of netflix IDs>)
the main feature of the app: swiping and matching.
You guys can either do this request by each swipe, or each 10 swipes or else.
How it works is when a user likes a movie, the movie will be firstly pushed 
to the <likes> array of its userinfo, and then if the user belongs to a pair,
the <likes> array of the pair will be checked, if the incoming movie is already 
in the <likes> array of the pair, there will be a match; where the movie item will be
removed from the <likes> array and added to the <matches> array of the pair.

simpleUpdateUserLike (https://asia-northeast1-movie-night-cc.cloudfunctions.net/simpleUpdateUserLike)
    query params: userName,movieArr
    (?userName=<userName>&movieArr=<An Array of netflix IDs>)
Just adding movies into the <likes> array of the user, for your dummy testing

simpleUpdatePairMatches (https://asia-northeast1-movie-night-cc.cloudfunctions.net/simpleUpdatePairMatches)
    query params: pairName,movieArr
    (?pairName=<pairName>&movieArr=<An Array of netflix IDs>)
Just adding movies into the <matches> array of the pair, for your dummy testing

checkIfUserHasPairs (https://asia-northeast1-movie-night-cc.cloudfunctions.net/checkIfUserHasPairs)
    query params: userName
Check if the user belongs to a pair. If true, the pair name will be returned; 
if false, false will be returned.

checkPairLikes (https://asia-northeast1-movie-night-cc.cloudfunctions.net/checkPairLikes)
    query params: pairName
check the liked movies of a pair

checkPair Matches (https://asia-northeast1-movie-night-cc.cloudfunctions.net/checkPairMatches)
    query params: pairName
check the matched movies of a pair

addMovies
Dont use it. this is for my seeding.


http://localhost:5001/movie-night-cc/asia-northeast1/createUser?name=testa&email=k@k.com&userName=testa
http://localhost:5001/movie-night-cc/asia-northeast1/createUser?name=testb&email=k@k.com&userName=testb
http://localhost:5001/movie-night-cc/asia-northeast1/createPair?pairName=test2&user1=testa&user2=testb
http://localhost:5001/movie-night-cc/asia-northeast1/updateUserLikes?userName=testa&movieArr=[1,2,3]
http://localhost:5001/movie-night-cc/asia-northeast1/updateUserLikes?userName=testb&movieArr=[1,2,3]