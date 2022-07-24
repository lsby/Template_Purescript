import { createApp } from "vue"
import App from "./src/Page/App.vue"
import Web from "./output/Web/index.js"

async function main() {
  var app = createApp(App)
  var { state, event } = await Web.main()
  app.config.globalProperties.state = state
  app.config.globalProperties.event = event
  app.mount("#app")
}
main()
