const express = require("express");
const app = express();
app.get("/users", (req, res) => {
  res.json({
    name: "Carlos Tiago",
  });
});
app.listen(4000, () => console.log("Running"));
