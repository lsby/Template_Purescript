// initEnv :: Task Unit
exports.initEnv = () => {
  var dotenv = require("dotenv")
  var path = require("path")

  return f()
  async function f() {
    if (process.env["NODE_ENV"] == "development") {
      console.log("使用 dev 环境")
      dotenv.config({ path: path.resolve(__dirname, "../../.env/dev.env") })
    } else if (process.env["NODE_ENV"] == "release") {
      console.log("使用 release 环境")
      dotenv.config({
        path: path.resolve(__dirname, "../../.env/release.env"),
      })
    } else if (process.env["NODE_ENV"] == "production") {
      console.log("使用 production 环境")
      dotenv.config({ path: path.resolve(__dirname, "../../.env/prod.env") })
    } else {
      throw "没有指定运行环境"
    }

    if (process.env["NODE_ENV"] != "development") {
      console.log("环境变量:", process.env)
    }
  }
}

// testFun :: Task Unit
exports.testFun = () => {
  return f()
  async function f() {
    console.log("这是用js写的函数")
  }
}
