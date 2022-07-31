import { createApp } from "vue"
import * as VueRouter from "vue-router"
import ElementPlus from "element-plus"
import "element-plus/dist/index.css"
import Web from "./output/Web/index.js"
import App from "./src/Page/App.vue"
import Demo from "./src/Page/Demo.vue"
import CountTest from "./src/Page/CountTest.vue"
import ElectronTest from "./src/Page/ElectronTest.vue"

async function main() {
  var app = createApp(App)
  var { state, event } = await Web.main()
  app.config.globalProperties.state = state
  app.config.globalProperties.event = event
  app.use(ElementPlus)
  app.use(
    VueRouter.createRouter({
      history: VueRouter.createWebHashHistory(),
      routes: [
        { path: "/", component: Demo },
        { path: "/Demo", component: Demo },
        { path: "/CountTest", component: CountTest },
        { path: "/ElectronTest", component: ElectronTest },
      ],
    })
  )
  app.mount("#app")
}
main()
