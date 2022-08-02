// trForeignRecordTsValue :: Foreign -> Foreign
exports.trForeignRecordTsValue = (data, r = {}) => {
  var { key, value } = data
  var d = Object.assign(r, { [key]: value })
  if (JSON.stringify(data.tail) == JSON.stringify({})) {
    return d
  }
  return exports.trForeignRecordTsValue(data.tail, d)
}
