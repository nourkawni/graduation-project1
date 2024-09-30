const express = require("express");
const app = express();

const db = require('./config/database');
const bodyParser = require("body-parser")
const UserRoute = require("./routes/userRoutes");

app.use(bodyParser.json())
app.use("/",UserRoute);


app.listen(3000, '0.0.0.0', () => {
    console.log('Server is running on port 3000');
  });
