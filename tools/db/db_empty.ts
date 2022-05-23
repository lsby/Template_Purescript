import readlineSync from "readline-sync"
import { 删除所有表, 获得环境变量 } from "./lib"

async function main() {
  var { DB_HOST, DB_NAME } = 获得环境变量()

  process.stdout.write(
    `本操作将清除和清空数据库${DB_HOST}:${DB_NAME}, 所有表结构和数据都将丢失, 确定吗?[y/N]`
  )
  var yes = readlineSync.question()
  if (yes != "y" && yes != "Y") {
    console.log("用户取消了操作")
    return
  }

  console.log("删除所有表...")

  await 删除所有表()
}
main()
