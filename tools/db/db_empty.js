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
const readline_sync_1 = __importDefault(require("readline-sync"));
const lib_1 = require("./lib");
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        var { DB_HOST, DB_NAME } = (0, lib_1.获得环境变量)();
        process.stdout.write(`本操作将清除和清空数据库${DB_HOST}:${DB_NAME}, 所有表结构和数据都将丢失, 确定吗?[y/N]`);
        var yes = readline_sync_1.default.question();
        if (yes != "y" && yes != "Y") {
            console.log("用户取消了操作");
            return;
        }
        console.log("删除所有表...");
        yield (0, lib_1.删除所有表)();
    });
}
main();
