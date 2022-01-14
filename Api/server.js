const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const PORT = process.env.PORT || 8080;
const pointsRouter = require("./routes/points.js");

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.json({ message: "Welcome to H-Nearer's API :)" });
});

app.use("/points", pointsRouter);

app.use((err, req, res, next) => {
  console.error(err.message);
  res.status(err.statusCode || 500).json({ message: err.message });

  return;
});

app.listen(PORT, () => console.log("App is running :)"));
