(function(dom) {
  function process_payment(event) {
    let bookingId = event.currentTarget.dataset.bookingid;
      let redeemPoints = event.currentTarget.dataset.redeempoints;
      fetch(`/payments/new?booking_id=${bookingId}&redeem_points=${redeemPoints}`)
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
  }

  dom.addEventListener('turbolinks:load', () => {
    let btns = dom.getElementsByClassName('payment-btn');
    for (let i = 0; i < btns.length; i++){
      btns[i].addEventListener('click', process_payment);
    }  
  })
}(document))