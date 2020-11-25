import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const unirest = require('unirest');
// import { UserRecord } from "firebase-functions/lib/providers/auth";

// const axios = require('axios')
// const cors = require("cors")({ origin: true });

admin.initializeApp();
const db = admin.firestore();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.region('asia-northeast1').https.onRequest(
  async (request:any, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
  }
);

//example GET
export const testGet = functions.region('asia-northeast1').https.onRequest(
    async (_:any, response) => {
      const docRef = db.collection("test").doc("alovelace");
      const result = await docRef.get()
      const data = result.data();
      response.send(data)
    }
  );
  

//example POST
export const testAdd = functions.region('asia-northeast1').https.onRequest(
  async (req:any, response) => {
    const docRef = db.collection("test").doc("alovelace");
    await docRef.set({
      first: "Ada",
      last: "Lovelace",
      born: 1815,
    });
    response.send("stored!")
  }
);

//example DELETE
export const testDelete = functions.region('asia-northeast1').https.onRequest(
    async (req:any, response) => {
        const docRef = db.collection("test").doc("alovelace");
        await docRef.delete(); //delete the Ref
        response.send("deleted!")
      }
)


//Getting Stuffs

//Get all Users

export const getAllUsers = functions.region('asia-northeast1').https.onRequest(
  async (request:any, response) => {
    const usersRef = db.collection('users');
    const result= await usersRef.get();
    const data = result.docs.map(doc=>doc.data())
    response.json(data);
  }
);

export const getAllMovies = functions.region('asia-northeast1').https.onRequest(
  async (request:any, response) => {
    const moviesRef = db.collection('movies');
    const result= await moviesRef.get();
    const data = result.docs.map(doc=>doc.data())
    response.json(data);
  }
);
//Get userbyId

export const getUserByUserName = functions.region('asia-northeast1').https.onRequest(
  async (request:any, response) => {
    const usersRef = db.collection('users').doc(request.query.userName)
    const result= await usersRef.get();
    const data = result.data();
    response.json(data);
  }
);

//Creating Stuffs

//Get Pair by PairName

export const getPairByPairName = functions.region('asia-northeast1').https.onRequest(
  async (request:any, response) => {
    const pairsRef = db.collection('pairs').doc(request.query.pairName)
    const result= await pairsRef.get();
    const data = result.data();
    response.json(data);
  }
);


//Create User
export const createUser = functions.region('asia-northeast1').https.onRequest(
  async (req:any, response) => {
    // const userCollection = db.collection("test");
    const userInfo : Object = {
      email: req.query.email,
      userName: req.query.userName,
      name: req.query.name,
      likes: [],
      dislikes: [],
    }
    const userCollection = db.collection("users");
    const userRef = userCollection.doc(req.query.userName)
    await userRef.set(userInfo)
    response.send("stored!")
  }
);


//Create Pair
export const createPairs = functions.region('asia-northeast1').https.onRequest(
  async (req:any, response) => {
    // const userCollection = db.collection("test");
    interface Pair {
      pairName?: String;
      members?: Array<String>;
      matches?: Array<Number>; //by netflexId
    }
    const pairInfo: Pair = {
      pairName: req.query.pairName,
      members: [req.query.member1,req.query.member2],
      matches: [],
    }
    const pairsCollection = db.collection("pairs");
    const pairsRef = pairsCollection.doc(req.query.pairName)
    await pairsRef.set(pairInfo)
    response.send("stored!")
  }
);

//Modifying Stuffs


//Add like and dislike to Users
// export const updateUserLikes = functions.https.onRequest(
//   async (request:any, response) => {
//     const userRef = db.collection('users').doc(req.query.userName)
//     response.send("Hello from Firebase!");
//   }
// );


//seed from netflix db

export const addMovies = functions.region('asia-northeast1').https.onRequest(
  async (req:any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      "type": "movie",
      "start_year": "2019",
      "orderby": "rating",
      "audiosubtitle_andor": "and",
      "subtitle": "english",
      "offset": "0",
      "end_year": "2021",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      "useQueryString": true,
    });
    APIreq.end(function (APIres:any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map ( (obj: any) => {
        console.log(String(obj.nfid))
        const docRef = db.collection("movies").doc(String(obj.nfid));
         docRef.set(obj).catch(err=>console.log(err))
      })
      response.send(APIres.body)
    });
  }
);
