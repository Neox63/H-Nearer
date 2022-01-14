const express = require("express");
const router = express.Router();
const points = require("../services/points.js");

router.get("/", async (req, res, next) => {
  try {
    res.json(await points.getPoints(req.query.page));
  } catch (err) {
    console.error(err.message);
    next(err);
  }
});

router.post("/create", async (req, res, next) => {
  try {
    res.json(await points.createPoint(req.body));
  } catch (err) {
    console.error(err.message);
    next(err);
  }
});

router.put("/update/:id", async (req, res, next) => {
  try {
    res.json(await points.updatePoint(req.params.id, req.body));
  } catch (err) {
    console.error(err.message);
    next(err);
  }
});

router.delete("/delete/:id", async (req, res, next) => {
  try {
    res.json(await points.deletePoint(req.params.id));
  } catch (err) {
    console.error(err.message);
    next(err);
  }
});

module.exports = router;
