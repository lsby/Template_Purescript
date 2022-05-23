"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const kysely_1 = require("kysely");
function getDB() {
    var host = process.env["DB_HOST"];
    var port = Number(process.env["DB_PORT"]);
    var user = process.env["DB_USER"];
    var password = process.env["DB_PWD"];
    var database = process.env["DB_NAME"];
    if (host == null ||
        port == null ||
        user == null ||
        password == null ||
        database == null) {
        throw "环境变量错误";
    }
    if (isNaN(port)) {
        throw "环境变量错误";
    }
    var db = new kysely_1.Kysely({
        dialect: new kysely_1.MysqlDialect({ host, port, user, password, database }),
    });
    return db;
}
// get_xs_by_id :: Int => Task { "姓名" :: String }
exports.get_xs_by_id = (id) => () => {
    return f();
    function f() {
        return __awaiter(this, void 0, void 0, function* () {
            var db = getDB();
            var r = yield db
                .selectFrom("学生表")
                .select("姓名")
                .where("学生表.id", "=", id)
                .execute();
            yield db.destroy();
            return r;
        });
    }
};
