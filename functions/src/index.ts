import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { NotificationTopics }   from "./notification_topics";
import { QuotesModel } from "./quotes_model";

admin.initializeApp( functions.config().firebase );


exports.sendTwelveAmNotification = functions.pubsub.schedule("0 0 * * *")
    .timeZone("America/Chicago")
    .onRun(async (_) => {
        console.log("Sending 12am notification...");
        const quote = await getRandomQuote();
        const notificationMessage = `Quote of the day: ${quote.quote} - ${quote.author}`;
        const notificationTopic = NotificationTopics.twelveAmTopic;
        const notificationId = generateUniqueNotificationIdId();
        const resultBool : Boolean = await sendNotificationToTopic(notificationMessage, notificationId, notificationTopic);
        if (resultBool) {
            console.log("12am notification sent successfully!");
        } else {
            console.log("12am notification failed to send!");
        }
    });




async function sendNotificationToTopic(notificationMessage  :string, notificationId : string, notificationTopic : string) : Promise<Boolean> {
   try {
    console.log(`Sending notification to topic: ${notificationTopic} with id: ${notificationId}`);
    
    const payload = {
        notification: {
            title: "Motivational Quote",
            body: notificationMessage,
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
            sound: "default",
        },
        data: {
            messageId: notificationId,
        },
    };

    console.log("Sending notification...");
    await admin.messaging().sendToTopic(notificationTopic, payload);
    return true;   
   } catch (error) {
    console.log(`Error sending notification to topic: ${notificationTopic} with id: ${notificationId}`);
    console.log(error);
    return false;
   }
    
}   


async function getRandomQuote(): Promise<QuotesModel> {
    const quotesSnapshot = await admin.firestore().collection("quotes").get();
    const quotes: QuotesModel[] = [];
    quotesSnapshot.forEach((quote) => {
        quotes.push(quote.data() as QuotesModel);
    });
    const randomIndex = Math.floor(Math.random() * quotes.length);
    return quotes[randomIndex];
}

function generateUniqueNotificationIdId(): string {
    const timestamp: number = Date.now();
    const random: number = Math.floor(Math.random() * 100000);
    return `${timestamp}${random.toString().padStart(5, '0')}`;
}


exports.sendTestNotification  = functions.https.onCall(async (data, context) => {

    const notificationMessage = `Test notification: ${data.message}`;
    const notificationTopic = NotificationTopics.twelvePmTopic;
    const notificationId = generateUniqueNotificationIdId();
    const resultBool : Boolean = await sendNotificationToTopic(notificationMessage, notificationId, notificationTopic);
    if (resultBool) {
        console.log("Test notification sent successfully!");
    } else {
        console.log("Test notification failed to send!");
    }
    return resultBool;
    }
);