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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const kysely_1 = require("kysely");
const path_1 = __importDefault(require("path"));
const lib_1 = require("./lib");
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        var { DB_HOST, DB_PORT, DB_USER, DB_PWD, DB_NAME } = (0, lib_1.获得环境变量)();
        yield (0, lib_1.新建数据库)();
        var db = new kysely_1.Kysely({
            dialect: new kysely_1.MysqlDialect({
                host: DB_HOST,
                port: DB_PORT,
                user: DB_USER,
                password: DB_PWD,
                database: DB_NAME,
            }),
        });
        var migrator = new kysely_1.Migrator({
            db,
            provider: new kysely_1.FileMigrationProvider(path_1.default.resolve(__dirname, "../migrations")),
        });
        var { error, results } = yield migrator.migrateToLatest();
        if ((results === null || results === void 0 ? void 0 : results.length) == 0) {
            console.log("没有要更新的描述");
            db.destroy();
        }
        results === null || results === void 0 ? void 0 : results.forEach((it) => {
            if (it.status === "Success") {
                console.log(`migration "${it.migrationName}" was executed successfully`);
            }
            else if (it.status === "Error") {
                console.error(`failed to execute migration "${it.migrationName}"`);
            }
            db.destroy();
        });
        if (error) {
            console.error("failed to run `migrateToLatest`");
            console.error(error);
            db.destroy();
        }
    });
}
main();
