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

export const helloWorld = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
  });

export const createGame = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const gameRef = db.collection("pairs").doc();
    await gameRef.set({
      name: "peter",
      age: "19",
      arr: [1, 2, 3, 4],
      obj: {
        pp: "hard",
      },
    });
    const snapShot = await gameRef.get();
    const data = snapShot.data();
    response.send(data);
  });

export const userRecommendAlgo = functions.firestore
  .document("users/{docId}")
  .onUpdate((change, context) => {
    const oldUserData = change.before.data();
    const newUserData = change.after.data();
    if (oldUserData && newUserData) {
      const oldGenreCount = oldUserData.genreCount;
      const newGenreCount = newUserData.genreCount;
      //  const newUserRec = newUserData["recommendations"];
      if (newGenreCount["Anime"] > oldGenreCount["Anime"]) {
        return change.after.ref.update(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] + 1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Scifi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
            },
          },
          
        );
      }

      if (newGenreCount["Horror"] > oldGenreCount["Horror"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] + 1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Scifi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
            },
          },
          { merge: true }
        );
      }
      if (newGenreCount["Japanese"] > oldGenreCount["Japanese"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] + 1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Scifi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
            },
          },
          { merge: true }
        );
      }
      if (newGenreCount["Korean"] > oldGenreCount["Korean"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] + 1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Scifi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
            },
          },
          { merge: true }
        );
      }

      if (newGenreCount["MartialArts"] > oldGenreCount["MartialArts"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] + 1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Scifi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
            },
          },
          { merge: true }
        );
      }
      if (newGenreCount["MusicInspired"] > oldGenreCount["MusicInspired"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired: oldUserData["recommendations"]["MusicInspired"] + 1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Scifi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1
            },
          },
          { merge: true }
        );
      }
      if (newGenreCount["Romance"] > oldGenreCount["Romance"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] + 1,
              Scifi: oldUserData["recommendations"]["Scifi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
            },
          },
          { merge: true }
        );
      }
      if (newGenreCount["Scifi"] > oldGenreCount["Scifi"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Scifi"] + 1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
            },
          },
          { merge: true }
        );
      }
      if (newGenreCount["Superhero"] > oldGenreCount["Superhero"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Scifi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] + 1,
            },
          },
          { merge: true }
        );
      }

      if (newGenreCount["LGBTQ"] > oldGenreCount["LGBTQ"]) {
        return change.after.ref.set(
          {
            recommendations: {
              Anime: oldUserData["recommendations"]["Anime"] - 0.1,
              Horror: oldUserData["recommendations"]["Horror"] - 0.1,
              Japanese: oldUserData["recommendations"]["Japanese"] - 0.1,
              Korean: oldUserData["recommendations"]["Korean"] - 0.1,
              LGBTQ: oldUserData["recommendations"]["LGBTQ"] + 1,
              MartialArts: oldUserData["recommendations"]["MartialArts"] - 0.1,
              MusicInspired:
                oldUserData["recommendations"]["MusicInspired"] - 0.1,
              Romance: oldUserData["recommendations"]["Romance"] - 0.1,
              Scifi: oldUserData["recommendations"]["Sci-fi"] - 0.1,
              Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
            },
          },
          { merge: true }
        );
      }
    }
    return null;
  });

export const pairRecommendAlgo = functions.firestore
  .document("pairs/{docId}")
  .onUpdate((change, context) => {
    const oldUserInfo = change.before.data();
    const newUserData = change.after.data();
    const oldGenreCount = oldUserInfo["genreCount"];
    const newGenreCount = newUserData["genreCount"];
    const oldUserData = oldUserInfo["recommendations"];
    //  const newUserRec = newUserData["recommendations"];

    if (newGenreCount["Anime"] > oldGenreCount["Anime"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: admin.firestore.FieldValue.increment(1),
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }

    if (newGenreCount["Horror/Thriller"] > oldGenreCount["Horror/Thriller"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller": admin.firestore.FieldValue.increment(1),
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }
    if (newGenreCount["Japanese Movies"] > oldGenreCount["Japanese Movies"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies": admin.firestore.FieldValue.increment(1),
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }
    if (newGenreCount["Korean Movies"] > oldGenreCount["Korean Movies"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] + 1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }

    if (newGenreCount["Martial Arts"] > oldGenreCount["Martial Arts"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] + 1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }

    if (newGenreCount["Music Inspired"] > oldGenreCount["Music Inspired"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired": oldUserData["recommendations"]["Music Inspired"] + 1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }

    if (newGenreCount["Romance"] > oldGenreCount["Romance"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] + 1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }

    if (newGenreCount["Sci-fi"] > oldGenreCount["Sci-fi"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] + 1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }

    if (newGenreCount["Superhero"] > oldGenreCount["Superhero"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] - 0.1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] + 1,
        },
      });
    }

    if (newGenreCount["LGBTQ"] > oldGenreCount["LGBTQ"]) {
      return change.after.ref.update({
        recommendations: {
          Anime: oldUserData["recommendations"]["Anime"] - 0.1,
          "Horror/Thriller":
            oldUserData["recommendations"]["Horror/Thriller"] - 0.1,
          "Japanese Movies":
            oldUserData["recommendations"]["Japanese Movies"] - 0.1,
          "Korean Movies": oldUserData["recommendations"]["Korean Movies"] - 0.1,
          LGBTQ: oldUserData["recommendations"]["LGBTQ"] + 1,
          "Martial Arts": oldUserData["recommendations"]["Martial Arts"] - 0.1,
          "Music Inspired":
            oldUserData["recommendations"]["Music Inspired"] - 0.1,
          Romance: oldUserData["recommendations"]["Romance"] - 0.1,
          "Sci-fi": oldUserData["recommendations"]["Sci-fi"] - 0.1,
          Superhero: oldUserData["recommendations"]["Superhero"] - 0.1,
        },
      });
    }

    return null;
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
      response.send("delete matcherror!");
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

export const getRomanceMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("romanceMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getMartialArtsMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("martialArtMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getMusicMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("musicMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getScifiMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("scifiMovies");
    const result = await moviesRef.get();
    const data = result.docs.map((doc) => doc.data());
    response.json(data);
  });

export const getSuperHeroMovies = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const moviesRef = db.collection("superHeroMovies");
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
    const userEmail = req.query.email;
    const atIndex = userEmail.indexOf("@");
    const userUserName = userEmail.slice(0, atIndex);
    // const userCollection = db.collection("test");
    const userInfo: Object = {
      email: req.query.email,
      userName: req.query.userName,
      name: req.query.name,
      likes: [],
      dislikes: [],
      pairName: "",
      genreCount: {
        Anime: 0,
        LGBTQ: 0,
        Horror: 0,
        Japanese: 0,
        Korean: 0,
        Scifi: 0,
        Superhero: 0,
        MartialArts: 0,
        MusicInspired: 0,
        Romance: 0,
      },
      recommendations: {
        Anime: 20,
        LGBTQ: 20,
        Horror: 20,
        Japanese: 20,
        Korean: 20,
        Scifi: 20,
        Superhero: 20,
        MartialArts: 20,
        MusicInspired: 20,
        Romance: 20,
      },
      userIcon:
        "https://firebasestorage.googleapis.com/v0/b/movie-night-cc.appspot.com/o/default_avatar.jpg?alt=media&token=f7cbf25b-ad42-42f8-959e-fb39cce30817",
    };
    const userCollection = db.collection("users");
    const userRef = userCollection.doc(userUserName);
    await userRef.set(userInfo);
    response.send("stored!");
  });

//Create Pair
export const createPair = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    const pairInfo: Object = {
      pairName: req.query.pairName,
      members: [req.query.user1, req.query.user2],
      matches: [],
      likes: [],
      genreCount: {
        Anime: 0,
        LGBTQ: 0,
        Horror: 0,
        Japanese: 0,
        Korean: 0,
        Scifi: 0,
        Superhero: 0,
        MartialArts: 0,
        MusicInspired: 0,
        Romance: 0,
      },
      recommendations: {
        Anime: 20,
        LGBTQ: 20,
        Horror: 20,
        Japanese: 20,
        Korean: 20,
        Scifi: 20,
        Superhero: 20,
        MartialArts: 20,
        MusicInspired: 20,
        Romance: 20,
      },
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
    const movieRef = db.collection("allMovies").doc(String(arr[0]));
    const movieResult = await movieRef.get();
    const movieData = movieResult.data();
    const movieGenre = request.query.genre;
    const genreKey = `genreCount.${movieGenre}`;

    if (userData && movieData) {
      //dummy check
      arr.map(async (netflixId: Number) => {
        await userRef.update(
          {
            likes: admin.firestore.FieldValue.arrayUnion(netflixId),
            [genreKey]: admin.firestore.FieldValue.increment(1),
          },
        );
      });
      //Check if user is in a pair. If true, push to pair array or add to matches
      if (userData.pairName !== "" && userData.pairName !== undefined) {
        //case for user having pair
        const pairRef = db.collection("pairs").doc(userData.pairName);
        const pairResult = await pairRef.get();
        const pairData = pairResult.data();
        arr.map(async (netflixId: Number) => {
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
                [genreKey]: admin.firestore.FieldValue.increment(1),
              });
              response.send("match!");
            } else {
              console.log("no match");
              await pairRef.update({
                likes: admin.firestore.FieldValue.arrayUnion(netflixId),
                [genreKey]: admin.firestore.FieldValue.increment(1),
              });
              response.send(
                `updated to user and pair to movie genre ${movieGenre}`
              );
            }
          }
        });
      }
    }
  });

export const testAiko = functions
  .region("asia-northeast1")
  .https.onRequest(async (_, response) => {
    const userRef = db.collection("users").doc("aiko");
    const snapshot = await userRef.get();
    const userData = snapshot.data();
    if (userData) {
      await userRef.update({
        ["genreCount" + ".Anime"]: userData["genreCount"]["Anime"] + 1,
      });
      response.json(
        `new aiko anime count is ${userData["genreCount"]["Anime"]}`
      );
    }
  });

// //query ?userName=<userName>&movieArr=[4243423,234234234,234423234]
// export const simpleUpdateUserLike = functions
//   .region("asia-northeast1")
//   .https.onRequest(async (request: any, response) => {
//     //Adding to user
//     const userRef = db.collection("users").doc(request.query.userName);
//     const userResult = await userRef.get();
//     const userData = userResult.data();
//     const arr = JSON.parse(request.query.movieArr);
//     arr.map(async (netflixId: Number) => {
//       await userRef.update({
//         likes: admin.firestore.FieldValue.arrayUnion(netflixId),
//       });
//     });
//     response.send(userData);
//   });

// //query ?pairName=<userName>&movieArr=[4243423,234234234,234423234]
// export const simpleUpdatePairMatches = functions
//   .region("asia-northeast1")
//   .https.onRequest(async (request: any, response) => {
//     //Adding to user
//     const pairRef = db.collection("pairs").doc(request.query.pairName);
//     const pairResult = await pairRef.get();
//     const pairData = pairResult.data();
//     const arr = JSON.parse(request.query.movieArr);
//     arr.map(async (netflixId: Number) => {
//       await pairRef.update({
//         matches: admin.firestore.FieldValue.arrayUnion(netflixId),
//       });
//     });
//     response.send(pairData);
//   });

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

export const setUpImageAndAlgo = functions
  .region("asia-northeast1")
  .https.onRequest(async (_, response) => {
    // const allMoviesObj: { [key: string]: Object } = {};
    const userRef = db.collection("users");
    const snapshot = await userRef.get();

    snapshot.forEach(async (doc) => {
      await doc.ref.update({
        genreCount: {
          Anime: 0,
          LGBTQ: 0,
          Horror: 0,
          Japanese: 0,
          Korean: 0,
          Scifi: 0,
          Superhero: 0,
          MartialArts: 0,
          MusicInspired: 0,
          Romance: 0,
        },
        recommendations: {
          Anime: 20,
          LGBTQ: 20,
          Horror: 20,
          Japanese: 20,
          Korean: 20,
          Scifi: 20,
          Superhero: 20,
          MartialArts: 20,
          MusicInspired: 20,
          Romance: 20,
        },
        likeCount: 0,
      });
    });
    response.json("success");
  });

export const pairSetup = functions
  .region("asia-northeast1")
  .https.onRequest(async (_, response) => {
    // const allMoviesObj: { [key: string]: Object } = {};
    const userRef = db.collection("pairs");
    const snapshot = await userRef.get();

    snapshot.forEach(async (doc) => {
      await doc.ref.update({
        genreCount: {
          Anime: 0,
          LGBTQ: 0,
          Horror: 0,
          Japanese: 0,
          Korean: 0,
          Scifi: 0,
          Superhero: 0,
          MartialArts: 0,
          MusicInspired: 0,
          Romance: 0,
        },
        recommendations: {
          Anime: 20,
          LGBTQ: 20,
          Horror: 20,
          Japanese: 20,
          Korean: 20,
          "Sci-fi": 20,
          Superhero: 20,
          MartialArts: 20,
          MusicInspired: 20,
          Romance: 20,
        },
      });
    });
    response.json("success");
  });

export const sorry = functions
  .region("asia-northeast1")
  .https.onRequest(async (_, response) => {
    // const allMoviesObj: { [key: string]: Object } = {};
    const userRef = db.collection("users");
    const snapshot = await userRef.get();

    snapshot.forEach(async (doc) => {
      await doc.ref.update({
        swipeCount: admin.firestore.FieldValue.delete(),
      });
    });
    response.json("success");
  });

export const seedGenres = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    let APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/genres");

    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });

    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.netflixid));
        const docRef = db.collection("genres").doc(String(obj.netflixid));
        docRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedIndie = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "7077",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      audiosubtitle_andor: "and",
      limit: "100",
      subtitle: "english",
      country_andorunique: "unique",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("indieMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedSuperHero = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "10118",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("superHeroMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedJapanese = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "10398",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("japaneseMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedScifi = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "1492",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("scifiMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedMusic = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "1701",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("musicMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedKorean = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "5685",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("koreanMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
        docRef
          .update({
            genre: "Korean Movies",
          })
          .then((_) => console.log("success!"))
          .catch((_) => console.log(_));
        allMoviesRef
          .update({
            genre: "Korean Movies",
          })
          .then((_) => console.log("success!"))
          .catch((_) => console.log(_));
      });
      response.send(APIres.body);
    });
  });

export const seedAnime = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "7424",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("animeMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedHorror = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "8711",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("horrorMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedGay = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "5977",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("gayLesbianMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedMartial = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "8985",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;
      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("martialArtMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedRomance = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "36103",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      subtitle: "english",
      offset: "0",
    });
    APIreq.headers({
      "x-rapidapi-key": "a9d2dfbe76msh26e338e4a5751f8p1e69bajsn164d1666776a",
      "x-rapidapi-host": "unogsng.p.rapidapi.com",
      useQueryString: true,
    });
    APIreq.end(function (APIres: any) {
      if (APIres.error) throw new Error(APIres.error);
      const result = APIres.body.results;

      result.map((obj: any) => {
        console.log(String(obj.nfid));
        const docRef = db.collection("romanceMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));

        docRef
          .update({
            genre: "Romance",
          })
          .then((_) => console.log("success!"))
          .catch((_) => console.log(_));
        allMoviesRef
          .update({
            genre: "Romance",
          })
          .then((_) => console.log("success!"))
          .catch((_) => console.log(_));
      });
      response.send(APIres.body);
    });
  });

export const giveGenreToRomance = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    const romanceRef = db.collection("romanceMovies");
    const snap = await romanceRef.get();
    snap.forEach(async (doc: any) => {
      await doc.ref.update({
        genre: "Romance",
      });
    });
  });
