var express = require("express");
var app = express();
const path = require('path');

function getTools() {
    return ["Jmeter","Locust","Gatling","k6"]
}

app.get("/url", (req, res, next) => {
    console.log("Request /url coming in ..");
    res.json(getTools());
});
app.get("/tools", (req, res, next) => {
    console.log("Request /tools coming in ..");
    res.sendFile(path.join(__dirname+'/html/index.html'));
});

app.listen(3000, () => {

    console.log("Server running on port 3000");
});