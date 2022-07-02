exports.mk = (obj) => () => {
  var { reactive } = require("vue")
  return new Promise((res, rej) => {
    var r = reactive(obj)
    res(r)
  })
}
exports.get = (key) => (_) => (_) => (obj) => () => {
  var { isProxy, toRaw } = require("vue")
  return new Promise((res, rej) => {
    var _v = obj[key.reflectSymbol()]
    var v = isProxy(_v) ? toRaw(_v) : _v
    res(v)
  })
}
exports.set = (key) => (_) => (_) => (value) => (obj) => () => {
  return new Promise((res, rej) => {
    obj[key.reflectSymbol()] = value
    res(null)
  })
}
exports.over = (key) => (_) => (_) => (value_f) => (obj) => () => {
  var { isProxy, toRaw } = require("vue")
  return new Promise((res, rej) => {
    var _v = obj[key.reflectSymbol()]
    var v = isProxy(_v) ? toRaw(_v) : _v
    obj[key.reflectSymbol()] = value_f(v)
    res(null)
  })
}
