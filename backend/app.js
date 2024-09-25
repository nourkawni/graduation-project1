const express = require("express");
const app = express();

const db = require('./config/database');
const bodyParser = require("body-parser")
const UserRoute = require("./routes/userRoutes");

app.get('/', (req,res)=>{

    res.send("Hello World");
})



app.use(bodyParser.json())
app.use("/",UserRoute);


app.listen(3000, ()=>{
    console.log('server Listening on Port 3000');
});
