exports.mk = (obj) => {
  var { reactive } = require("vue")
  var r = reactive(obj)
  return r
}
exports.get = (key) => (_) => (_) => (obj) => () => {
  return new Promise((res, rej) => {
    var r = obj[key.reflectSymbol()]
    res(r)
  })
}
exports.set = (key) => (_) => (_) => (value) => (obj) => () => {
  return new Promise((res, rej) => {
    obj[key.reflectSymbol()] = value
    res(null)
  })
}
