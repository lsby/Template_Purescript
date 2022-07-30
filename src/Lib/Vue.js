exports.wrapVueData = (obj) => () => {
  var { reactive } = require("vue")
  return new Promise((res, rej) => {
    res(reactive(obj))
  })
}
exports.unsafeWrapVueData = (obj) => {
  var { reactive } = require("vue")
  return reactive(obj)
}
exports.unwrapVueData = (obj) => () => {
  var { toRaw } = require("vue")
  return new Promise((res, rej) => {
    res(toRaw(obj))
  })
}
exports.setVueDateValue = (obj) => (vueData) => () => {
  return new Promise((res, rej) => {
    for (var name in obj) {
      vueData[name] = obj[name]
    }
    res(null)
  })
}
