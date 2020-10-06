var express = require("express");
var app = express();

function getTools() {
    return ["Jmeter","Locust","Gatling","k6"]
}

app.get("/url", (req, res, next) => {
    console.log("Request coming in ..");
    res.json(getTools());
});

app.listen(3000, () => {
    console.log("Server running on port 3000");
});