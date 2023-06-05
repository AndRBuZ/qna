$(document).on('turbolinks:load', function () {
  $('.votes').on('ajax:success', function (e) {
    let vote = e.detail[0]

    if (vote.model == 'question') {
      $('.question .votes .rating').html(vote.rating)
    } else {
      $(`.answer-${vote.votable_id} .votes .rating`).html(vote.rating)
    }
  })
    .on('ajax:error', function (e) {
      let errors = e.detail[0]

      $.each(errors, function (index, value) {
        $('p.notice').append('<p>' + value + '</p>')
      })
    })
})
