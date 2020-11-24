import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// const axios = require('axios')
// const cors = require("cors")({ origin: true });

admin.initializeApp();
const db = admin.firestore();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest(
  (request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
  }
);

//example GET
export const testGet = functions.https.onRequest(
    async (_, response) => {
      const docRef = db.collection("test").doc("alovelace");
      const result = await docRef.get()
      const data = result.data();
      response.send(data)
    }
  );
  

//example POST
export const testAdd = functions.https.onRequest(
  async (req, response) => {
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
export const testDelete = functions.https.onRequest(
    async (req, response) => {
        const docRef = db.collection("test").doc("alovelace");
        await docRef.delete(); //delete the Ref
        response.send("deleted!")
      }
)