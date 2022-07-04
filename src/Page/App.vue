<template>
  <Demo></Demo>
</template>

<script lang="ts">
import { getCurrentInstance } from "vue"
import Demo from "./Demo.vue"
import { State, Event } from "./Types"

export default {
  components: {
    Demo,
  },
  setup() {
    var { proxy } = getCurrentInstance() as any
    var s = proxy.state as State
    var e = proxy.event as Event
    return { s, e }
  },
}
</script>
