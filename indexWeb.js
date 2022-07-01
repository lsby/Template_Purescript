import { createApp } from "vue"
import App from "./src/Page/App.vue"
import purs from "./output/Web/index.js"

var app = createApp(App)
app.config.globalProperties.state = purs.state
app.mount("#app")
