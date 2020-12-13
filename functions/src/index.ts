import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// import { firebaseConfig } from "firebase-functions";
const unirest = require("unirest");

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

//message

export const sendMatchNotification = functions.region("asia-northeast1").firestore
  .document("pairs/{pairName}")
  .onUpdate(async (change, context) => {
    console.log("----------------start function--------------------");
    const oldPairData = change.before.data();
    const newPairData = change.after.data();
    const user1Name = oldPairData["members"][0];
    const user2Name = oldPairData["members"][1];
    if (oldPairData && newPairData) {
      if (
        newPairData["matchMovieData"].length >
        oldPairData["matchMovieData"].length
      ) {
        const user1Ref = db.collection("users").doc(user1Name);
        const user2Ref = db.collection("users").doc(user2Name);
        const snap1 = await user1Ref.get();
        const snap2 = await user2Ref.get();
        const data1 = snap1.data();
        const data2 = snap2.data();
        const payload = {
          notification: {
            title: "You have a new match!",
            body: `click here to see what matches you have!`,
          },
        };
        if (data1 && data2) {
          try {
            if (data1.pushToken) {
              await admin.messaging().sendToDevice(data1.pushToken, payload);
              console.log("pushed to user1");
            }
            if (data2.pushToken) {
              await admin.messaging().sendToDevice(data2.pushToken, payload);
              console.log("pushed to user2");
            }
          } catch {
            console.log("error!");
          }
        }
      }
    }
    // const response = await admin.messaging().sendToDevice(tokens, payload);
    // const doc = snap.data()
    // console.log(doc)
    return null;
  });

export const rushStatusTracker = functions.region("asia-northeast1").firestore
  .document("rushplus/{pairName}")
  .onUpdate(async (change, context) => {
    const inviteMessage = {
      notification: {
        title: "Your partner invited you to RUSH!!",
        body: `click here to join!`,
      },
    };
    const startMessage = {
      notification: {
        title: "Start!",
        body: `Time to RUSH!!`,
      },
    };
    console.log("----------------start function--------------------");
    const newPairData = change.after.data();
    const pairRef = await db
      .collection("pairs")
      .doc(newPairData.pairName)
      .get();
    const pairData = pairRef.data();
    if (pairData) {
      const userTwoName = pairData.members[1];
      const userOneName = pairData.members[0];
      const userTwoRef = await db.collection("user").doc(userTwoName).get();
      const userOneRef = await db.collection("user").doc(userOneName).get();
      const userTwoData = userTwoRef.data();
      const userOneData = userOneRef.data();
      if (userTwoData && userOneData) {
        if (
          newPairData.playerOneJoined === true &&
          newPairData.playerTwoJoined === false
        ) {
          if (userTwoData.pushToken) {
            await admin
              .messaging()
              .sendToDevice(userTwoData.pushToken, inviteMessage);
          }
        }

        if (
          newPairData.playerOneJoined === false &&
          newPairData.playerTwoJoined === true
        ) {
          if (userOneData.pushToken) {
            await admin
              .messaging()
              .sendToDevice(userOneData.pushToken, inviteMessage);
            return "invited";
          }

          if (userTwoData) {
            if (userTwoData.pushToken) {
              await admin
                .messaging()
                .sendToDevice(userTwoData.pushToken, inviteMessage);
              return "invited";
            }
          }
        }
        if (
          newPairData.playerOneJoined === true &&
          newPairData.playerTwoJoined === true
        ) {
          if (userOneData.pushToken) {
            await admin
              .messaging()
              .sendToDevice(userOneData.pushToken, startMessage);
          }
          if (userTwoData.pushToken) {
            await admin
              .messaging()
              .sendToDevice(userTwoData.pushToken, startMessage);
          }
          return "start!";
        }
      }
    }

    return null;
  });

export const joinRush = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const userSnap = await db
      .collection("users")
      .doc(request.query.userName)
      .get();
    const pairSnap = await db
      .collection("pairs")
      .doc(request.query.pairName)
      .get();
    const userData = userSnap.data();
    const pairData = pairSnap.data();
    if (userData && pairData) {
      // const user1Token = userData.pushToken;
      if (userData.userName === pairData.members[0]) {
        await db.collection("rushPlus").doc(request.query.pairName).update({
          playerOneJoined: true,
        });
      }
      if (userData.userName === pairData.members[1]) {
        await db.collection("rushPlus").doc(request.query.pairName).update({
          playerTwoJoined: true,
        });
      }
    }
    response.send("joined!");
  });

export const helloWorld = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
  });

export const createOrEndGame = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const pairName = request.query.pairName;
    const rushRef = db.collection("rushPlus").doc(pairName);
    await rushRef.set(
      {
        pairName: pairName,
        playerOneJoined: false,
        playerTwoJoined: false,
      },
      { merge: true }
    );
    const snapShot = await rushRef.get();
    const data = snapShot.data();
    response.send(data);
  });

export const endGame = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const pairName = request.query.pairName;
    const gameRef = db.collection("rushPlus").doc(pairName);
    await gameRef.update({
      playerOneJoined: false,
      playerTwoJoined: false,
    });
    const snapShot = await gameRef.get();
    const data = snapShot.data();
    response.send(data);
  });

export const userRecommendAlgo = functions.region("asia-northeast1").firestore
  .document("users/{docId}")
  .onUpdate((change, context) => {
    const oldUserData = change.before.data();
    const newUserData = change.after.data();
    if (oldUserData && newUserData) {
      const oldGenreCount = oldUserData.genreCount;
      const newGenreCount = newUserData.genreCount;
      //  const newUserRec = newUserData["recommendations"];
      if (newGenreCount["Anime"] > oldGenreCount["Anime"]) {
        return change.after.ref.update({
          "recommendations.Anime": admin.firestore.FieldValue.increment(1),
          "recommendations.Horror": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Japanese": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.Korean": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.MartialArts": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.Romance": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Superhero": admin.firestore.FieldValue.increment(
            -0.1
          ),
        });
      }

      if (newGenreCount["Horror"] > oldGenreCount["Horror"]) {
        return change.after.ref.update({
          "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Horror": admin.firestore.FieldValue.increment(1),
          "recommendations.Japanese": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.Korean": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.MartialArts": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
            -0.1
          ),

          "recommendations.Romance": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Superhero": admin.firestore.FieldValue.increment(
            -0.1
          ),
        });
      }
      if (newGenreCount["Japanese"] > oldGenreCount["Japanese"]) {
        return change.after.ref.update({
          "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Horror": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Japanese": admin.firestore.FieldValue.increment(
            1
          ),
          "recommendations.Korean": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.MartialArts": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
            -0.1
          ),

          "recommendations.Romance": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Superhero": admin.firestore.FieldValue.increment(
            -0.1
          ),
        });
      }
      if (newGenreCount["Korean"] > oldGenreCount["Korean"]) {
        return change.after.ref.update({
          "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Horror": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Japanese": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.Korean": admin.firestore.FieldValue.increment(1),
          "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.MartialArts": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
            -0.1
          ),

          "recommendations.Romance": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Superhero": admin.firestore.FieldValue.increment(
            -0.1
          ),
        });
      }

      if (newGenreCount["MartialArts"] > oldGenreCount["MartialArts"]) {
        return change.after.ref.update({
          "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Horror": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Japanese": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.Korean": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.MartialArts": admin.firestore.FieldValue.increment(
            1
          ),
          "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
            -0.1
          ),

          "recommendations.Romance": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Superhero": admin.firestore.FieldValue.increment(
            -0.1
          ),
        });
      }
      if (newGenreCount["MusicInspired"] > oldGenreCount["MusicInspired"]) {
        return change.after.ref.update({
          "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Horror": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Japanese": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.Korean": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.MartialArts": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
            1
          ),
          "recommendations.Romance": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Superhero": admin.firestore.FieldValue.increment(
            -0.1
          ),
        });
      }
      if (newGenreCount["Romance"] > oldGenreCount["Romance"]) {
        return change.after.ref.update({
          "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Horror": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Japanese": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.Korean": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.MartialArts": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
            -0.1
          ),

          "recommendations.Romance": admin.firestore.FieldValue.increment(1),
          "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Superhero": admin.firestore.FieldValue.increment(
            -0.1
          ),
        });
      }
      if (newGenreCount["Scifi"] > oldGenreCount["Scifi"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
      if (newGenreCount["Superhero"] > oldGenreCount["Superhero"]) {
        return change.after.ref.update({
          "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Horror": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Japanese": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.Korean": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.MartialArts": admin.firestore.FieldValue.increment(
            -0.1
          ),
          "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
            -0.1
          ),

          "recommendations.Romance": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
          "recommendations.Superhero": admin.firestore.FieldValue.increment(
            1
          ),
        });
      }

      if (newGenreCount["LGBTQ"] > oldGenreCount["LGBTQ"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
    }
    return null;
  });

export const pairRecommendAlgo = functions.region("asia-northeast1").firestore
  .document("users/{docId}")
  .onUpdate((change, context) => {
    const oldUserData = change.before.data();
    const newUserData = change.after.data();
    if (oldUserData && newUserData) {
      const oldGenreCount = oldUserData.genreCount;
      const newGenreCount = newUserData.genreCount;
      //  const newUserRec = newUserData["recommendations"];
      if (newGenreCount["Anime"] > oldGenreCount["Anime"]) {
        return change.after.ref.update({
            "recommendations.Anime":
              admin.firestore.FieldValue.increment(1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        })
      }

      if (newGenreCount["Horror"] > oldGenreCount["Horror"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(1),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
      if (newGenreCount["Japanese"] > oldGenreCount["Japanese"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              1
            ),            
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
      if (newGenreCount["Korean"] > oldGenreCount["Korean"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),            
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }

      if (newGenreCount["MartialArts"] > oldGenreCount["MartialArts"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              1
            ), 
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
      if (newGenreCount["MusicInspired"] > oldGenreCount["MusicInspired"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              1
            ),            
            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
      if (newGenreCount["Romance"] > oldGenreCount["Romance"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Romance": admin.firestore.FieldValue.increment(
              1
            ),            
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
      if (newGenreCount["Scifi"] > oldGenreCount["Scifi"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
      if (newGenreCount["Superhero"] > oldGenreCount["Superhero"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              1
            ),        
          });
      }

      if (newGenreCount["LGBTQ"] > oldGenreCount["LGBTQ"]) {
        return change.after.ref.update({
            "recommendations.Anime": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Horror": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Japanese": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Korean": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.LGBTQ": admin.firestore.FieldValue.increment(1),
            "recommendations.MartialArts": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.MusicInspired": admin.firestore.FieldValue.increment(
              -0.1
            ),

            "recommendations.Romance": admin.firestore.FieldValue.increment(
              -0.1
            ),
            "recommendations.Scifi": admin.firestore.FieldValue.increment(-0.1),
            "recommendations.Superhero": admin.firestore.FieldValue.increment(
              -0.1
            ),
        });
      }
    }
    return null;
  });

//// RUSH 2.0 game code ///////////

// create game
export const createGame = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const gameRef = db.collection("rushplus").doc();
    await gameRef.set({
      pairName: request.query.pairName,
      started: false,
      joined: true,
      movies: [1, 2, 3, 4],
    });
    const snapShot = await gameRef.get();
    const data = snapShot.data();
    response.send(`${data} current game state`);
  });

// get Game
export const getGame = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const gameRef = db.collection("rushplus").doc(request.query.pairName);
    const result = await gameRef.get();
    const data = result.data();
    if (data) response.json(data);
    else response.json("no game found.");
  });

// start timer
export const startGame = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const gameRef = db.collection("rushplus").doc(request.query.pairName);
    const result = await gameRef.get();

    gameRef
      .set(
        {
          started: true,
        },
        { merge: true }
      )
      .then((_) => console.log("success"))
      .catch((_) => console.error("did not set"));

    const data = result.data();
    if (data) response.json(`reset the game:${data}`);
    else response.json("failed to reset the game.");
  });

// reset game values (joined and started) or maybe just delete the game????
export const resetGame = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    const gameRef = db.collection("rushplus").doc(request.query.pairName);
    const result = await gameRef.get();

    gameRef
      .update({
        started: false,
      })
      .then((_) => console.log("success"))
      .catch((_) => console.error("did not set"));
    const data = result.data();
    if (data) response.json(`started the time:${data}`);
    else response.json("no game found.");
  });
//// RUSH 2.0 game code ///////////

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
      matchMovieData: [],
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
    const movieGenre = request.query.genre;
    const arr = JSON.parse(request.query.movieArr);

    const userRef = db.collection("users").doc(request.query.userName);
    const userResult = await userRef.get();
    const userData = userResult.data();
    const movieRef = db.collection("allMovies").doc(String(arr[0]));
    const movieResult = await movieRef.get();
    const movieData = movieResult.data();
    const genreKey = `genreCount.${movieGenre}`;

    if (userData && movieData) {
      arr.map(async (netflixId: Number) => {
        await userRef.update({
          likes: admin.firestore.FieldValue.arrayUnion(netflixId),
          [genreKey]: admin.firestore.FieldValue.increment(1),
        });
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

export const setUpAlgo = functions
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
          Scifi: 20,
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

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/genres");

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
      countrylist: "267",
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
        obj["genre"]="Superhero";
        console.log(String(obj.nfid));
        const docRef = db.collection("superHeroMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
      });
      response.send(APIres.body);
    });
  });

export const seedSuperHero2 = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    // const moviesCollection = db.collection("movies").doc("alovelace");

    const APIreq = unirest("GET", "https://unogsng.p.rapidapi.com/search");
    APIreq.query({
      genrelist: "67698",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      countrylist: "267",
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
        obj["genre"]="Superhero";
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
      countrylist: "267",
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
        obj["genre"]="Japanese";
        console.log(String(obj.nfid));
        const docRef = db.collection("japanMovies").doc(String(obj.nfid));
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
      countrylist: "267",
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
        obj["genre"]="Scifi";
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
      countrylist: "267",
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
        obj["genre"]="MusicInspired";
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
      genrelist: "5685, 1989, 5685, 6626, 8248,11283",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      countrylist: "267",
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
        obj["genre"]="Korean";
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
      genrelist: "2653, 3063, 7424, 9302, 10695, 11146",
      type: "movie",
      start_year: "1972",
      orderby: "rating",
      limit: "100",
      countrylist: "267",
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
        obj["genre"]="Anime";
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
      countrylist: "267",
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
        obj["genre"]="Horror";
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
      countrylist: "267",
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
        obj["genre"]="LGBTQ";
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
      countrylist: "267",

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
        obj["genre"]="MartialArts";
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
      countrylist: "267",
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
        obj["genre"]="Romance";
        console.log(String(obj.nfid));
        const docRef = db.collection("romanceMovies").doc(String(obj.nfid));
        docRef.set(obj).catch((err) => console.log(err));
        const allMoviesRef = db.collection("allMovies").doc(String(obj.nfid));
        allMoviesRef.set(obj).catch((err) => console.log(err));
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

export const setUpRushGame = functions
  .region("asia-northeast1")
  .https.onRequest(async (req: any, response) => {
    const snapshot = await db.collection("pair").get();
    snapshot.forEach(async function (doc) {
      const pairName = doc.data().pairName;
      await db.collection("rushPlus").doc(pairName).set(
        {
          pairName: pairName,
          playerOneJoined: false,
          playerTwoJoined: false,
        },
        { merge: true }
      );
    });
  });

export const createRushGameForPair = functions.region("asia-northeast1").firestore
  .document("pairs/{pairName}")
  .onCreate(async (snap, context) => {
    console.log("----------------start function--------------------");
    const pairData = snap.data();
    const pairName = pairData.pairName;
    const user1Name = pairName["members"][0];
    const user2Name = pairName["members"][1];
    const snap1 = await db.collection("users").doc(user1Name).get();
    const snap2 = await db.collection("users").doc(user2Name).get();
    const data1 = snap1.data();
    const data2 = snap2.data();

    if (data1 && data2) {
      await db.collection("rushPlus").doc(pairName).set(
        {
          pairName: pairName,
          playerOneJoined: false,
          playerTwoJoined: false,
          playerOne: pairData["members"][0],
          playerTwo: pairData["members"][1],
          iconOne: data1["userIcon"],
          iconTwo: data2["userIcon"],
        },
        { merge: true }
      );
    }
  });

export const deleteUser = functions
  .region("asia-northeast1")
  .https.onRequest(async (request: any, response) => {
    try {
      //Adding to user
      const userRef = db.collection("users").doc(request.query.userName);

      if (userRef) {
        await userRef.delete();

        response.send("deleted!");
      }
    } catch {
      response.send("delete matcherror!");
    }
  });


