import consumer from "./consumer"
import compiledTempate from "templates/answer.handlebars"

consumer.subscriptions.create("AnswersChannel",
  {
    connected() {
      this.perform('follow', { question_id: gon.question_id })
    },
    received(data) {
      let parseData = JSON.parse(data)

      if (gon.user_id && gon.user_id !== parseData.user_id || !gon.user_id) {
        $('.answers').append(compiledTempate({
          answer_body: parseData.answer_body, answer_id: parseData.answer_id, answer_rating: parseData.votes,
          answer_links: parseData.links, answer_files: parseData.files,
          user: gon.user_id
        }))
      }
    }
  }
)
