exports.trForeignRecordTsType = (data) => {
  var _data = data
  var c = []
  var t = JSON.stringify({})
  while (JSON.stringify(_data) != t) {
    var { key, value } = _data
    c.push({ key, value })
    _data = _data.tail
  }
  var o = c.map((a) => `${a.key}: ${a.value}`).join(", ")

  return `{ ${o} }`
}
