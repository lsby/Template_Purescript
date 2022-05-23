import { Generated } from 'kysely'

export default interface Database {
    '学生表': { 'id': Generated<number>; '姓名': string; '性别': '男' | '女'; '所属班级': number; 'created_at': Generated<string> }
    '班级表': { 'id': Generated<number>; '名称': string; 'created_at': Generated<string> }
    'kysely_migration': { 'name': string; 'timestamp': string }
    'kysely_migration_lock': { 'id': string; 'is_locked': Generated<number> }
}
