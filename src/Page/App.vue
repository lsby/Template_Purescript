<template>
  <Demo></Demo>
</template>

<script lang="ts" setup>
import { getCurrentInstance } from "vue"
import Demo from "./Demo.vue"
import { WebState, WebEvent } from "./Types"

var { proxy } = getCurrentInstance() as any
var s = proxy.state as WebState
var e = proxy.event as WebEvent
</script>
