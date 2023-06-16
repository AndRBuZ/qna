import consumer from "./consumer"
import compiledTempate from "templates/comment.handlebars"

consumer.subscriptions.create("CommentsChannel",
  {
    connected() {
      this.perform('follow', { question_id: gon.question_id })
    },
    received(data) {
      let parseData = JSON.parse(data)

      if (gon.user_id && gon.user_id !== parseData.user_id || !gon.user_id) {
        if (parseData.commentable_type == 'question') {
          $('.question .comments').append(compiledTempate({
            comment_id: parseData.comment_id,
            comment_body: parseData.comment_body
          }))
        } else {
          $(`.answers .answer-${parseData.commentable_id} .comments`).append(compiledTempate({
            comment_id: parseData.comment_id,
            comment_body: parseData.comment_body
          }))
        }
      }
    }
  }
)
