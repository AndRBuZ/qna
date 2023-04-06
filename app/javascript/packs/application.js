import Rails from "@rails/ujs"
global.$ = require('jquery')
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("answers/update")
require("question/update")
