import { Kysely, MysqlDialect } from "kysely"
import Database from "../../tools/types/Database"

function getDB() {
  var host = process.env["DB_HOST"]
  var port = Number(process.env["DB_PORT"])
  var user = process.env["DB_USER"]
  var password = process.env["DB_PWD"]
  var database = process.env["DB_NAME"]

  if (
    host == null ||
    port == null ||
    user == null ||
    password == null ||
    database == null
  ) {
    throw "环境变量错误"
  }
  if (isNaN(port)) {
    throw "环境变量错误"
  }

  var db = new Kysely<Database>({
    dialect: new MysqlDialect({ host, port, user, password, database }),
  })

  return db
}

// get_xs_by_id :: Int => Task { "姓名" :: String }
exports.get_xs_by_id = (id: number) => () => {
  return f()
  async function f() {
    var db = getDB()

    var r = await db
      .selectFrom("学生表")
      .select("姓名")
      .where("学生表.id", "=", id)
      .execute()

    await db.destroy()

    return r
  }
}
