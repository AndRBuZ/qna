$(document).on('turbolinks:load', function() {
    $('.question-subscription').on('ajax:success', function (e) {
        let subscription = e.detail[0]
        $('.question-subscription').html(subscription.body.innerHTML)
    })
})
