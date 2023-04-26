const express = require("express");
const nodemailer = require("nodemailer");
const cron = require("node-cron");
const amqplib = require("amqplib/callback_api");
const config = require("./config");
const bodyParser = require("body-parser");
const cors = require("cors");

const msg = require('./firebase-config.js');

const app = express();
const port = 3000;

const notification_options = {
    priority: "high",
    timeToLive: 60 * 60 * 24
  };

const transporter = nodemailer.createTransport({
  host: "smtp.ethereal.email",
  port: 587,
  auth: {
    user: "mac.steuber@ethereal.email",
    pass: "KMkvHKKe6eY5rqdbzN",
  },
});

async function main() {
  app.use(cors());

  // Configuring body parser middleware
  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());

  app.post("/mail", (req, res) => {
    pushToQueue(req.body);
    res.status(200).end();
  });

  app.listen(port, () => {
    console.log("application listening.....");
  });

  cron.schedule('* * * * *', () => {
    popFromQueue();
  });
}

function popFromQueue() {
  amqplib.connect(config.amqp, (err, connection) => {
    if (err) {
      console.error(err.stack);
      return process.exit(1);
    }

    connection.createChannel((err, channel) => {
      if (err) {
        console.error(err.stack);
        return process.exit(1);
      }

      channel.assertQueue(config.queue, { durable: true }, (err) => {
        if (err) {
          console.error(err.stack);
          return process.exit(1);
        }

        channel.prefetch(1);

        channel.consume(config.queue, (data) => {
          if (data === null) {
            return;
          }

          const message = JSON.parse(data.content.toString());
          console.log("Received from queue: %s", message.to);

          let timestamp = new Date();

          const email = {
            from: "mac.steuber@ethereal.email",
            to: message.to,
            subject: message.subject,
            html: `<b>${message.message}</b>
            <p>
            <b>${message.price} EUR</b>`,
          };

          let payload = {
            data: {
              message: `Aktivacija paketa za ${message.to} je poslana u`,
              timestamp: timestamp.toISOString(),
            }
          };

          transporter.sendMail(email, (err) => {
            if (err) {
              console.error(err.stack);
              return channel.nack(data); // put the failed message item back to queue
            }

            console.log("Delivered message %s", email.subject);
            channel.ack(data); // remove message item from the queue
            sendFcmNotification(message.fcmToken, payload);
          });
        });
      });
    });
  });
}

function pushToQueue(values) {
  amqplib.connect(config.amqp, (err, connection) => {
    if (err) {
      console.error(err.stack);
      return process.exit(1);
    }

    connection.createChannel((err, channel) => {
      if (err) {
        console.error(err.stack);
        return process.exit(1);
      }

      // durable - Ensure that the queue is not deleted when server restarts
      channel.assertQueue(config.queue, { durable: true }, (err) => {
        if (err) {
          console.error(err.stack);
          return process.exit(1);
        }

        const sender = (content, next) => {
          const data = Buffer.from(JSON.stringify(content));
          const sent = channel.sendToQueue(config.queue, data, {
            persistent: true, // Store queued elements on disk
            contentType: "application/json",
          });

          if (sent) {
            return next();
          }

          channel.once("drain", () => next());
        };

        let sent = 0;

        const sendNext = () => {
          if (sent >= values.recipient.length) {
            console.log("All messages sent!");
            return channel.close(() => connection.close()); // close connection to send messages to queue
          }

          const message = {
            to: values.recipient[sent],
            subject: "Oryx aktivacija clanstva",
            message: values.message,
            price: values.price,
            fcmToken: values.fcmToken,
          };

          console.log(message);

          sent++;
          sender(message, sendNext);
        };

        sendNext();
      });
    });
  });
}

function sendFcmNotification(registrationToken, payload){
    msg.messaging().sendToDevice(registrationToken, payload, notification_options)
  .then(function(response) {
    console.log("Successfully sent message:", response);
  })
  .catch(function(error) {
    console.log("Error sending message:", error);
  });
}

main().catch(console.error);
