<template>
  <Demo></Demo>
</template>

<script lang="ts">
import { getCurrentInstance } from "vue"
import Demo from "./Demo.vue"
import { WebState, WebEvent } from "./Types"

export default {
  components: {
    Demo,
  },
  setup() {
    var { proxy } = getCurrentInstance() as any
    var s = proxy.state as WebState
    var e = proxy.event as WebEvent
    return { s, e }
  },
}
</script>
