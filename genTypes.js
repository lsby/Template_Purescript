console.log("start")
try {
  var main = require("./output/Tools.GenTypes/index.js")
  main.genTypes()
} catch (e) {
  console.error("error:", e)
}
console.log("end")
