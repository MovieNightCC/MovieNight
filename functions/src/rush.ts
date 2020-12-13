// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
// // import { UserRecord } from "firebase-functions/lib/providers/auth";

// // const axios = require('axios')
// // const cors = require("cors")({ origin: true });

// admin.initializeApp();
// const db = admin.firestore();

// export const createRushGameForPair = functions.firestore
//   .document("pairs/{pairName}")
//   .onCreate(async (snap, context) => {
//     console.log("----------------start function--------------------");
//     const pairData = snap.data();
//     const pairName = pairData.pairName;
//     const user1Name = pairName["members"][0];
//     const user2Name = pairName["members"][1];
//     const snap1 = await db.collection("user").doc(user1Name).get();
//     const snap2 = await db.collection("user").doc(user2Name).get();
//     const data1 = snap1.data();
//     const data2 = snap2.data();

//     if (data1 &&data2) {

//         await db.collection("rushPlus").doc(pairName).set(
//             {
//               pairName: pairName,
//               playerOneJoined: false,
//               playerTwoJoined: false,
//               playerOne: pairData["members"][0],
//               playerTwo: pairData["members"][1],
//               iconOne: data1["userIcon"],
//               iconTwo: data2["userIcon"],
//             },
//             { merge: true }
//           );
//     }
//   });

// export const joinRush = functions
//   .region("asia-northeast1")
//   .https.onRequest(async (request: any, response) => {
//     const userSnap = await db
//       .collection("users")
//       .doc(request.query.userName)
//       .get();
//     const userData = userSnap.data();
//     const pairSnap = await db
//       .collection("pairs")
//       .doc(request.query.pairName)
//       .get();
//     const pairData = pairSnap.data();
//     if (userData && pairData) {
//       // const user1Token = userData.pushToken;
//       if (userData.userName === pairData.members[0]) {
//         await db.collection("rushPlus").doc(request.query.pairName).update({
//           playerOneJoined: true,
//         });
//       }
//       if (userData.userName === pairData.members[1]) {
//         await db.collection("rushPlus").doc(request.query.pairName).update({
//           playerTwoJoined: true,
//         });
//       }
//     }
//     response.send("joined!");
//   });
