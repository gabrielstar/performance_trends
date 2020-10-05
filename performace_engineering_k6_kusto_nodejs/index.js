var express = require("express");
var app = express();

app.get("/url", (req, res, next) => {
    res.json(["Jmeter","Locust","Gatling","k6"]);
});

app.listen(3000, () => {
    console.log("Server running on port 3000");
});