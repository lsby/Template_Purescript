import _knex from "knex"
import fs from "fs"
import path from "path"
import { 获得环境变量 } from "./lib"

export async function main() {
  var { DB_HOST, DB_PORT, DB_USER, DB_PWD, DB_NAME } = 获得环境变量()

  var knex = _knex({
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
    var 描述 = await knex
      .select<
        {
          TABLE_NAME: string
          COLUMN_NAME: string
          COLUMN_DEFAULT: null | "CURRENT_TIMESTAMP"
          IS_NULLABLE: "NO" | "YES"
          DATA_TYPE:
            | "timestamp"
            | "int"
            | "varchar"
            | "enum"
            | "double"
            | "tinyint"
            | "decimal"
          COLUMN_TYPE: string
          EXTRA: "DEFAULT_GENERATED" | "auto_increment" | ""
          COLUMN_COMMENT: string
        }[]
      >()
      .from("information_schema.columns")
      .where({ table_schema: DB_NAME })

    var 整理 = 描述
      .map((a) => a.TABLE_NAME)
      .map((a) => ({ 表名: a, 描述: 描述.filter((b) => b.TABLE_NAME == a) }))
      .map((a) => ({
        ...a,
        描述: a.描述.map((b) => ({
          ...b,
          翻译类型: (function () {
            var 结果 = ""
            var 空补充 = b.IS_NULLABLE == "YES" ? " | null" : ""
            var 选填标记 =
              b.EXTRA == "DEFAULT_GENERATED" ||
              b.EXTRA == "auto_increment" ||
              b.COLUMN_DEFAULT != null
                ? true
                : false

            if (b.DATA_TYPE == "int") {
              结果 = "number"
            } else if (b.DATA_TYPE == "double") {
              结果 = "number"
            } else if (b.DATA_TYPE == "varchar") {
              结果 = "string"
            } else if (b.COLUMN_TYPE == "tinyint(1)") {
              结果 = "0 | 1"
            } else if (b.DATA_TYPE == "tinyint") {
              结果 = "number"
            } else if (b.DATA_TYPE == "decimal") {
              结果 = "number"
            } else if (b.DATA_TYPE == "enum") {
              结果 = (b.COLUMN_TYPE as string)
                .replace(/enum\((.*)\)/, "$1")
                .split(",")
                .join(" | ")
            } else {
              结果 = "string"
            }
            if (选填标记) {
              结果 = `Generated<${结果}>`
            }

            return 结果 + 空补充
          })(),
        })),
      }))

    var ts描述 = [
      [`import { Generated } from 'kysely'`],
      [""],
      ["export default interface Database {"],
      [
        ...new Set(
          整理.map(
            (a) =>
              `    '${a.表名}': { ${a.描述
                .map((b) => `'${b.COLUMN_NAME}': ${b.翻译类型}`)
                .join("; ")} }`
          )
        ),
      ],
      ["}"],
      [""],
    ]
      .map((a) => a.join("\n"))
      .join("\n")

    fs.writeFileSync(path.resolve(__dirname, "../types/Database.ts"), ts描述)
  } catch (e) {
    throw e
  } finally {
    await knex.destroy()
  }
}
main()
