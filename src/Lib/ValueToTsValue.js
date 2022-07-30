// trForeignRecordTsValue :: Foreign -> Foreign
exports.trForeignRecordTsValue = (data, r = {}) => {
  var { key, value } = data
  var d = Object.assign(r, { [key]: value })
  if (JSON.stringify(data.tail) == JSON.stringify({})) {
    return d
  }
  return exports.trForeignRecordTsValue(data.tail, d)
}
// Array Foreign -> Array Foreign
exports.trForeignSumTsValue = (data) => {
  if (!Array.isArray(data[1])) {
    return data
  }
  return [data[0], ...exports.trForeignSumTsValue(data[1])]
}
