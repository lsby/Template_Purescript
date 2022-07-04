import { createApp } from "vue"
import App from "./src/Page/App.vue"
import Web from "./output/Web/index.js"

async function main() {
  var app = createApp(App)
  app.config.globalProperties.state = await Web.state()
  app.config.globalProperties.event = await Web.event()
  app.mount("#app")
}
main()
