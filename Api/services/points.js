const database = require("./database.js");

const getPoints = async (page = 1) => {
  const rows = await database.query("SELECT * FROM Points");

  return rows;
};

const createPoint = async (point) => {
  const result = await database.query(
    `INSERT INTO Points (name, latitude, longitude) VALUES ("${point.name}", "${point.latitude}", "${point.longitude}")`
  );

  return result.affectedRows ? "Done ! :)" : "Oops, something went wrong :(";
};

const updatePoint = async (id, point) => {
  const result = await database.query(
    `UPDATE Points SET name="${point.name}", latitude="${point.latitude}", longitude="${point.longitude}" WHERE id="${id}"`
  );

  return result.affectedRows ? "Done ! :)" : "Oops, something went wrong :(";
};

const deletePoint = async (id) => {
  const result = await database.query(`DELETE FROM Points WHERE id="${id}"`);

  return result.affectedRows ? "Done ! :)" : "Oops, something went wrong :(";
};

module.exports = { getPoints, createPoint, updatePoint, deletePoint };
