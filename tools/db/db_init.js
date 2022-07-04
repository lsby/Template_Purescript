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
const lib_1 = require("./lib");
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        var { DB_HOST, DB_PORT, DB_USER, DB_PWD, DB_NAME } = (0, lib_1.获得环境变量)();
        var kysely = new kysely_1.Kysely({
            dialect: new kysely_1.MysqlDialect({
                host: DB_HOST,
                port: DB_PORT,
                user: DB_USER,
                password: DB_PWD,
                database: DB_NAME,
            }),
        });
        try {
            yield kysely.connection().execute((db) => __awaiter(this, void 0, void 0, function* () {
                yield db.transaction().execute((trx) => __awaiter(this, void 0, void 0, function* () {
                    var _id = yield trx
                        .insertInto("班级表")
                        .values({
                        名称: "一班",
                    })
                        .executeTakeFirst();
                    if (!_id.insertId)
                        throw "插入失败";
                    var id = Number(_id.insertId);
                    yield trx
                        .insertInto("学生表")
                        .values({
                        姓名: "王二狗",
                        性别: "男",
                        所属班级: id,
                    })
                        .execute();
                }));
            }));
        }
        finally {
            kysely.destroy();
        }
        console.log("操作完成");
    });
}
main();
