# how to use the Cloud Functions
Use the URL provided by firestore to access the functons

## list of functions
helloWorld
Just a helloworld. You can use it to check the connection to firebase.

getAllUsers
Showing all users information

getAllMovies
Showing all movies information

getUserByUserName
    query params: userName (?userName=<userName>)
retrieving user's info by its username.

getPairByPairName
    query params: pairName (?pairName=<pairName>)
retrieving pair's info by its pairName.

createUser
    query params: userName,email,name
    (?userName=<userName>&email=<userEmail>&name=<name>)
initalizing a user with empty likes,dislikes and pair belonged

updateUserLikes
    query params: userName,movieArr
    (?userName=<userName>&movieArr=<An Array of netflix IDs>)
the main feature of the app: swiping and matching.
You guys can either do this request by each swipe, or each 10 swipes or else.
How it works is when a user likes a movie, the movie will be firstly pushed 
to the <likes> array of its userinfo, and then if the user belongs to a pair,
the <likes> array of the pair will be checked, if the incoming movie is already 
in the <likes> array of the pair, there will be a match; where the movie item will be
removed from the <likes> array and added to the <matches> array of the pair.


http://localhost:5001/movie-night-cc/asia-northeast1/createUser?name=testa&email=k@k.com&userName=testa
http://localhost:5001/movie-night-cc/asia-northeast1/createUser?name=testb&email=k@k.com&userName=testb
http://localhost:5001/movie-night-cc/asia-northeast1/createPair?pairName=test2&user1=testa&user2=testb
http://localhost:5001/movie-night-cc/asia-northeast1/updateUserLikes?userName=testa&movieArr=[1,2,3]
http://localhost:5001/movie-night-cc/asia-northeast1/updateUserLikes?userName=testb&movieArr=[1,2,3]