import * as _knex from "knex"
import mysql from "mysql"
import path from "path"
import dotenv from "dotenv"

export function 获得环境变量() {
  if (process.env["NODE_ENV"] == "development") {
    console.log("使用 dev 环境")
    dotenv.config({ path: path.resolve(__dirname, "../../.env/dev.env") })
  } else if (process.env["NODE_ENV"] == "release") {
    console.log("使用 release 环境")
    dotenv.config({ path: path.resolve(__dirname, "../../.env/release.env") })
  } else if (process.env["NODE_ENV"] == "production") {
    console.log("使用 production 环境")
    dotenv.config({ path: path.resolve(__dirname, "../../.env/prod.env") })
  } else {
    throw "没有指定运行环境"
  }

  var DB_HOST = process.env["DB_HOST"]
  var DB_PORT = Number(process.env["DB_PORT"])
  var DB_USER = process.env["DB_USER"]
  var DB_PWD = process.env["DB_PWD"]
  var DB_NAME = process.env["DB_NAME"]
  var APP_PORT = Number(process.env["APP_PORT"])

  if (
    DB_HOST == null ||
    DB_PORT == null ||
    DB_USER == null ||
    DB_PWD == null ||
    DB_NAME == null ||
    APP_PORT == null
  ) {
    throw "环境变量错误"
  }
  if (isNaN(DB_PORT) || isNaN(APP_PORT)) {
    throw "环境变量错误"
  }

  return { DB_HOST, DB_PORT, DB_USER, DB_PWD, DB_NAME, APP_PORT }
}
export async function 删除所有表() {
  var { DB_HOST, DB_PORT, DB_USER, DB_PWD, DB_NAME } = 获得环境变量()

  var knex = _knex.default({
    client: "mysql",
    connection: {
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      password: DB_PWD,
      database: DB_NAME,
    },
  })

  try {
    var 所有表: string[] = (
      await knex
        .select("TABLE_NAME")
        .from("information_schema.TABLES")
        .where({ table_schema: DB_NAME })
    ).map((a: any) => a.TABLE_NAME)

    var 删除所有外键约束: string[] = (
      await knex.raw(`
            SELECT concat('alter table ',table_schema,'.',table_name,' DROP FOREIGN KEY ',constraint_name,';')
            FROM information_schema.table_constraints
            WHERE constraint_type='FOREIGN KEY'
            AND table_schema='${DB_NAME}'
        `)
    )[0].map((a: any) => (Object.values(a)[0] as string).trim())
    for (var sql of 删除所有外键约束) {
      await knex.raw(sql)
    }

    var 删除所有表 = await Promise.all(
      所有表.map((a) => knex.schema.dropTable(a))
    )
  } catch (e) {
    throw e
  } finally {
    await knex.destroy()
  }
}

export async function 新建表(
  schema: (knex: _knex.Knex<any, unknown[]>) => _knex.Knex.SchemaBuilder
) {
  var { DB_HOST, DB_PORT, DB_USER, DB_PWD, DB_NAME } = 获得环境变量()

  var knex = _knex.default({
    client: "mysql",
    connection: {
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      password: DB_PWD,
      database: DB_NAME,
    },
  })

  try {
    var cmd = await schema(knex).generateDdlCommands()
    var sqlarr: string[] = cmd.sql
      .map((a) => (a as any).sql)
      .sort((a, b) => {
        if (a.indexOf("create table") != -1) {
          return -1
        }
        if (b.indexOf("create table") != -1) {
          return 1
        }
        if (a.indexOf("foreign key") != -1) {
          return 1
        }
        if (b.indexOf("foreign key") != -1) {
          return -1
        }
        return a - b
      })

    await knex.transaction(async (trx) => {
      for (var sql of sqlarr) {
        await trx.raw(sql)
      }
    })
  } catch (e) {
    throw e
  } finally {
    await knex.destroy()
  }
}

export async function 新建数据库() {
  var { DB_HOST, DB_PORT, DB_USER, DB_PWD, DB_NAME } = 获得环境变量()

  var connection = mysql.createConnection({
    host: DB_HOST,
    port: DB_PORT,
    user: DB_USER,
    password: DB_PWD,
    database: DB_NAME,
  })

  connection.connect()

  await new Promise((res, rej) => {
    connection.query(
      `create database If Not Exists ${DB_NAME} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci`,
      function (error: any, results: any, fields: any) {
        if (error) return rej(error)
        res(null)
      }
    )
  })

  connection.end()
}
