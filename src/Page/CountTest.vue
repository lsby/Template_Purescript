<template>
  <div>{{ s.hello }}</div>
  <div>{{ s.counter }}</div>
  <button @click="e.onIncrease()">增加</button>
  <button @click="e.onMakeZero()">归零</button>
</template>

<script lang="ts" setup>
import { getCurrentInstance } from "vue"
import { WebState, WebEvent } from "./Types/Types"

var { proxy } = getCurrentInstance() as any
var s = proxy.state as WebState
var e = proxy.event as WebEvent
</script>
