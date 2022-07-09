exports.mkVueData = (obj) => () => {
  var { reactive } = require("vue")
  return new Promise((res, rej) => {
    var r = reactive(obj)
    res(r)
  })
}
exports.getVueData = (key) => (_) => (_) => (obj) => () => {
  var { isProxy, toRaw } = require("vue")
  return new Promise((res, rej) => {
    var _v = obj[key.reflectSymbol()]
    var v = isProxy(_v) ? toRaw(_v) : _v
    res(v)
  })
}
exports.setVueData = (key) => (_) => (_) => (value) => (obj) => () => {
  return new Promise((res, rej) => {
    obj[key.reflectSymbol()] = value
    res(null)
  })
}
exports.overVueData = (key) => (_) => (_) => (value_f) => (obj) => () => {
  var { isProxy, toRaw } = require("vue")
  return new Promise((res, rej) => {
    var _v = obj[key.reflectSymbol()]
    var v = isProxy(_v) ? toRaw(_v) : _v
    obj[key.reflectSymbol()] = value_f(v)
    res(null)
  })
}
exports.mapTaskVueData = (f) => (obj) => () => {
  var { isProxy, toRaw } = require("vue")
  return new Promise((res, rej) => {
    var obj_clone = {}
    for (var name in obj) {
      var _v = obj[name]
      var v = isProxy(_v) ? toRaw(_v) : _v
      obj_clone[name] = v
    }

    f(obj_clone)().then((f_obj) => {
      for (var name in obj) {
        obj[name] = f_obj[name]
      }
      res(null)
    })
  })
}
