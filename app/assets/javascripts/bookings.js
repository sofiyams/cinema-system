(function(dom) {
  dom
  .addEventListener('turbolinks:load', () => {
    dom
    .getElementById('pay-now')
    .addEventListener('click', (event) => {
      fetch(`/payments/new?booking_id=${event.currentTarget.dataset.bookingid}`)
      .then(response => response.json())
      .then((json) => {
        var stripe = Stripe('pk_test_MCHM33TZus0Z0kayzfx82Cq400U9ATXMlE');
        stripe.redirectToCheckout({
          sessionId: json.session_id
        })
      .then(function (result) {
      });
    });
    event.returnValue = false;
  });  
  })
}(document))