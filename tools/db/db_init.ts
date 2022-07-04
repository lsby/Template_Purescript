import _knex from "knex"
import { Kysely, MysqlDialect } from "kysely"
import DataBase from "../types/Database"
import { 获得环境变量 } from "./lib"

async function main() {
  var { DB_HOST, DB_PORT, DB_USER, DB_PWD, DB_NAME } = 获得环境变量()

  var kysely = new Kysely<DataBase>({
    dialect: new MysqlDialect({
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      password: DB_PWD,
      database: DB_NAME,
    }),
  })

  try {
    await kysely.connection().execute(async (db) => {
      await db.transaction().execute(async (trx) => {
        var _id = await trx
          .insertInto("班级表")
          .values({
            名称: "一班",
          })
          .executeTakeFirst()

        if (!_id.insertId) throw "插入失败"
        var id = Number(_id.insertId)

        await trx
          .insertInto("学生表")
          .values({
            姓名: "王二狗",
            性别: "男",
            所属班级: id,
          })
          .execute()
      })
    })
  } finally {
    kysely.destroy()
  }

  console.log("操作完成")
}

main()
