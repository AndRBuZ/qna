import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require('jquery')
const GistClient = require("gist-client")
const gistClient = new GistClient()
window.gistClient = gistClient
require("@nathanvda/cocoon")
require("answers/update")
require("question/update")
require("votes/vote")
