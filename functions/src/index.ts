import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const unirest = require("unirest");
// import { UserRecord } from "firebase-functions/lib/providers/auth";

// const axios = require('axios')
// const cors = require("cors")({ origin: true });

admin.initializeApp();
const db = admin.firestore();

interface oneMovie {
  top250?: Number;
  imdbrating?: Number;
  title?: String; //by netflexId
  avgrating?: Number;
  top250tv?: Number;
  poster?: String;
  titledate?: String;
  synopsis?: String;
  year?: Number;
  img?: String;
  nfid?: Number;
  runtime?: Number;
  id?: Number;
  clist: String;
  vtype: String;
}
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
  });

//example DELETE
export const testDelete = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    const docRef = db.collection("test").doc("alovelace");
    await docRef.delete(); //delete the Ref
    response.send("deleted!");
  });

//Deleting Stuffs
//params: pairName, nfid
export const deleteMatch = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    try {
      const netflixId = Number(request.query.nfid);
      //Adding to user
      const pairRef = db.collection("pairs").doc(request.query.pairName);
      const pairResult = await pairRef.get();
      const pairData = pairResult.data();
      if (pairData) {
        await pairRef.update({
          matchMovieData: pairData.matchMovieData.filter(
            (movie: any) => movie.nfid !== netflixId
          ),
          matches: admin.firestore.FieldValue.arrayRemove(netflixId),
        });

        response.send("deleted!");
      }
    } catch {
      response.send("error!");
    }
  });
//Getting Stuffs

//Get all Users

export const getAllUsers = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const usersRef = db.collection("users");
    const result = await usersRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getAllMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("allMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getGayMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("gayLesbianMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getAnimeMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("animeMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getHorrorMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("horrorMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getJapanMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("japanMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getKoreaMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("koreanMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

//Get User Info by User Name
//query ?userName=<username>
export const getUserByUserName = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const usersRef = db.collection("users").doc(request.query.userName);
    const result = await usersRef.get();
    const data = result.data();
    response.json(data);
  });

//Get Pair by PairName
//query ?pairName=<pairName>
export const getPairByPairName = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const pairsRef = db.collection("pairs").doc(request.query.pairName);
    const result = await pairsRef.get();
    const data = result.data();
    response.json(data);
  });

//Create User
export const createUser = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const userCollection = db.collection("test");
    const userInfo: Object = {
      email: req.query.email,
      userName: req.query.userName,
      name: req.query.name,
      likes: [],
      dislikes: [],
      pairName: "",
      //add a line that says partnered with ""
    };
    const userCollection = db.collection("users");
    const userRef = userCollection.doc(req.query.email);
    await userRef.set(userInfo);
    response.send("stored!");
  });

//Create Pair
export const createPair = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    interface Pair {
      pairName?: String;
      members?: Array<String>;
      matches?: Array<Number>; //by netflexId
      likes?: Array<Number>;
    }
    const pairInfo: Pair = {
      pairName: req.query.pairName,
      members: [req.query.user1, req.query.user2],
      matches: [],
      likes: [],
    };
    //create Pair
    const pairsCollection = db.collection("pairs");
    const pairsRef = pairsCollection.doc(req.query.pairName);
    await pairsRef.set(pairInfo);
    //update pairName to users
    const usersCollection = db.collection("users");
    const usersRef1 = usersCollection.doc(req.query.user1);
    const usersRef2 = usersCollection.doc(req.query.user2);
    //get user data and get their display name

    await usersRef1.update({ pairName: req.query.pairName });
    await usersRef2.update({ pairName: req.query.pairName });
    // await usersRef2.update({partner: <the other user's display name>})
    response.send("pair created!");
  });

//dummy create Pair
export const dummy = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    interface Pair {
      pairName?: String;
      members?: Array<String>;
      matches?: Array<Number>; //by netflexId
      likes?: Array<Number>;
    }
    const pairInfo: Pair = {
      pairName: req.query.pairName,
      members: [req.query.user1, req.query.user2],
      matches: [],
      likes: [],
    };
    const pairsCollection = db.collection("pairs");
    const pairsRef = pairsCollection.doc(req.query.pairName);
    await pairsRef.set(pairInfo);
    // also please add pairName to userEntity

    // const usersCollection = db.collection("users");
    // const usersRef1 = usersCollection.doc(req.query.user1);
    // const usersRef2 = usersCollection.doc(req.query.user2);
    // await usersRef1.update({pairName: req.query.pairName})
    // await usersRef2.update({pairName: req.query.pairName})
    response.send("pair created!");
  });

//Modifying Stuffs

//Add liked movies to User Entity
//query: userName, movieArr (An array of netflix ids)
export const updateUserLikes = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response: any) => {
    //Adding to user
    const userRef = db.collection("users").doc(request.query.userName);
    const userResult = await userRef.get();
    const userData = userResult.data();
    const arr = JSON.parse(request.query.movieArr);
    arr.map(async (netflixId: Number) => {
      await userRef.update({
        likes: admin.firestore.FieldValue.arrayUnion(netflixId),
      });
    });
    //Check if user is in a pair. If true, push to pair array or add to matches
    if (userData) {
      if (userData.pairName !== "" || userData.pairName !== undefined) {
        //case for user having pair
        const pairRef = db.collection("pairs").doc(userData.pairName);
        const pairResult = await pairRef.get();
        const pairData = pairResult.data();
        arr.map(async (netflixId: Number) => {
          const movieRef = db.collection("allMovies").doc(String(netflixId));
          const movieResult = await movieRef.get();
          const movieData = movieResult.data();
          //check if movie already exists in like
          if (pairData) {
            if (pairData.likes.includes(netflixId)) {
              console.log("yes match");
              await pairRef.update({
                matches: admin.firestore.FieldValue.arrayUnion(netflixId),
                likes: admin.firestore.FieldValue.arrayRemove(netflixId),
                matchMovieData: admin.firestore.FieldValue.arrayUnion(
                  movieData
                ),
              });
              response.send("match!");
            } else {
              console.log("no match");
              await pairRef.update({
                likes: admin.firestore.FieldValue.arrayUnion(netflixId),
              });
              response.send("updated to user and pair!");
            }
          }
        });
      }
    }
  });

//query ?userName=<userName>&movieArr=[4243423,234234234,234423234]
export const simpleUpdateUserLike = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    //Adding to user
    const userRef = db.collection("users").doc(request.query.userName);
    const userResult = await userRef.get();
    const userData = userResult.data();
    const arr = JSON.parse(request.query.movieArr);
    arr.map(async (netflixId: Number) => {
      await userRef.update({
        likes: admin.firestore.FieldValue.arrayUnion(netflixId),
      });
    });
    response.send(userData);
  });

//query ?pairName=<userName>&movieArr=[4243423,234234234,234423234]
export const simpleUpdatePairMatches = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    //Adding to user
    const pairRef = db.collection("pairs").doc(request.query.pairName);
    const pairResult = await pairRef.get();
    const pairData = pairResult.data();
    const arr = JSON.parse(request.query.movieArr);
    arr.map(async (netflixId: Number) => {
      await pairRef.update({
        matches: admin.firestore.FieldValue.arrayUnion(netflixId),
      });
    });
    response.send(pairData);
  });

//Get Pair Name of user (by UserName)
export const checkIfUserHasPairs = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const usersRef = db.collection("users").doc(request.query.userName);
    const result = await usersRef.get();
    const data = result.data();
    if (data) response.json(data.pairName);
    else response.json(false);
  });

//get list of liked movies of a Pair
export const checkPairLikes = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const pairRef = db.collection("users").doc(request.query.pairName);
    const result = await pairRef.get();
    const data = result.data();
    if (data) response.json(data.likes);
    else response.json("no array found.");
  });

//get list of matched movies of a pair
export const checkPairMatches = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const pairRef = db.collection("users").doc(request.query.pairName);
    const result = await pairRef.get();
    const data = result.data();
    if (data) response.json(data.matches);
    else response.json("no array found.");
  });

//seed from netflix db (unogsNG API)

export const addMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      type: "movie",
      start_year: "2019",
      orderby: "rating",
      audiosubtitle_andor: "and",
      subtitle: "english",
      offset: "0",
      end_year: "2021",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: oneMovie) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("movies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });
