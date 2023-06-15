class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions_#{data['question_id']}_answers" if data['question_id'].present?
  end
end
