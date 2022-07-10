module Lib.Lib where

import Prelude

import Hby.Task (Task)
import Hby.Task as T

----------------------
-- | 测试函数
foreign import testFun :: Task Unit

----------------------
-- | 测试函数
hello :: Task Unit
hello = T.log "hello, world!"

-- | 给字符串增加外层引号
addQuotation :: String -> String
addQuotation s = "\"" <> s <> "\""

-- | 生成pure类型名称
genPureType :: String -> String
genPureType name = addQuotation $ "PureType_" <> name

-- | 生成pure数组类型名称
genPureArrayType :: String -> String
genPureArrayType name = "Array<" <> (addQuotation $ "PureType_" <> name) <> ">"
