<template>
  <CountTest></CountTest>
  <ElectronTest></ElectronTest>
  <el-button type="primary" @click="toPage1()">页面1</el-button>
  <el-button type="primary" @click="toPage2()">页面2</el-button>
</template>

<script lang="ts" setup>
import CountTest from "./CountTest.vue"
import ElectronTest from "./ElectronTest.vue"
import { useRoute, useRouter } from "vue-router"

var router = useRouter()
var route = useRoute()

function toPage1() {
  router.push({ path: "/CountTest" })
}
function toPage2() {
  router.push({ path: "/ElectronTest" })
}
</script>
