// multi_form

$("#Continue-panel-1").css("pointer-events","none");
$("#Continue-panel-2").css("pointer-events","none");
$('#method').change(function(e) {

  if ($(this).find(':selected').val() === '') {
      $("#Continue-panel-1").css("pointer-events","none");
      $("#Continue-panel-2").css("pointer-events","none");
       $("#panelBodyTwo").collapse('hide');
       $("#panelBodyThree").collapse('hide');

  } else if ($(this).find(':selected').val() === 'credit_card') {
       $("#panelBodyTwo").collapse('show');
       $("#panelBodyThree").collapse('hide');
       $("#paypal-button").css("display","none");
       $("#place_order").css("display","block");
       $("#Continue-panel-1").css("pointer-events","auto");
      //  $("#Continue-panel-2").css("pointer-events","auto");
      //  $(".some-space").css("display","none");

   } else {
     $("#panelBodyTwo").collapse('hide');
      $("#panelBodyThree").collapse('show');
      $("#place_order").css("display","none");
      $("#paypal-button").css("display","block");
      $("#Continue-panel-1").css("pointer-events","none");
      $("#Continue-panel-2").css("pointer-events","auto");
      // $(".some-space").css("display","none");
   }
});
  $("#Continue").on("click", function () {
    $("#panelBodyThree").collapse('show');
    $("#Continue-panel-2").css("pointer-events","auto");
  });

  // $(function(){
  //     $('#paypal-button').click(function(e){
  //         e.preventDefault();
  //         $('#paypal-button').click();
  //       }
  //     );
  // });



// validiation
$(document).ready(function() {

   FormValidation.Validator.securePassword = {
     validate: function(validator, $field, options) {
         var value = $field.val();
         if (value === '') {
             return true;
         }
         return true;
     }
 };

   $('#billing_form').formValidation({
       framework: 'bootstrap',
       icon: {
           valid: 'glyphicon glyphicon-ok',
           invalid: 'glyphicon glyphicon-remove',
           validating: 'glyphicon glyphicon-refresh'
       },
       fields: {
           'f_name': {
               validators: {
                   notEmpty: {
                       message: 'The first name is required'
                   }
               }
           },
           'l_name': {
               validators: {
                   notEmpty: {
                       message: 'The last name is required'
                   }
               }
           },
           'card_type': {
               validators: {
                   notEmpty: {
                       message: 'The type is required'
                   }
               }
           },
           'card_number': {
               validators: {
                   notEmpty: {
                       message: 'The card number is required'
                   },
                   creditCard: {
                     message: 'The card number is not valid'
                   }
               }
           },
           'cvv2': {
               validators: {
                   notEmpty: {
                       message: 'The CVV is required'
                   },
                   cvv: {
                     creditCardField: 'card_number',
                     message: 'The CVV number is not valid'
                   }
               }
           },
           'expire_month': {
               validators: {
                   notEmpty: {
                       message: 'The month is required'
                   }
               }
           },
           'expire_year': {
               validators: {
                   notEmpty: {
                       message: 'The year is required'
                   }
               }
           },
           'postal_code': {
               validators: {
                   notEmpty: {
                       message: 'The postal code is required'
                   }
               }
           },
           'address': {
               validators: {
                   notEmpty: {
                       message: 'The address is required'
                   }
               }
           },
           'city': {
               validators: {
                   notEmpty: {
                       message: 'The city is required'
                   }
               }
           },
           'country': {
               validators: {
                   notEmpty: {
                       message: 'The country is required'
                   }
               }
           },
           'state': {
               validators: {
                   notEmpty: {
                       message: 'The state is required'
                   }
               }
           }
       }
   })
   .on('success.validator.fv', function(e, data) {
            if (data.field === 'cc' && data.validator === 'creditCard') {
                var $icon = data.element.data('fv.icon');
                // data.result.type can be one of
                // AMERICAN_EXPRESS, DINERS_CLUB, DINERS_CLUB_US, DISCOVER, JCB, LASER,
                // MAESTRO, MASTERCARD, SOLO, UNIONPAY, VISA

                switch (data.result.type) {
                    case 'AMERICAN_EXPRESS':
                        $icon.removeClass().addClass('form-control-feedback fa fa-cc-amex');
                        break;

                    case 'DISCOVER':
                        $icon.removeClass().addClass('form-control-feedback fa fa-cc-discover');
                        break;

                    case 'MASTERCARD':
                    case 'DINERS_CLUB_US':
                        $icon.removeClass().addClass('form-control-feedback fa fa-cc-mastercard');
                        break;

                    case 'VISA':
                        $icon.removeClass().addClass('form-control-feedback fa fa-cc-visa');
                        break;

                    default:
                        $icon.removeClass().addClass('form-control-feedback fa fa-credit-card');
                        break;
                }
            }
        })
        .on('err.field.fv', function(e, data) {
                if (data.field === 'cc') {
                    var $icon = data.element.data('fv.icon');
                    $icon.removeClass().addClass('form-control-feedback fa fa-times');
                }
            })
   .on('err.validator.fv', function(e, data) {
           // $(e.target)    --> The field element
           // data.fv        --> The FormValidation instance
           // data.field     --> The field name
           // data.element   --> The field element
           // data.validator --> The current validator name
           data.element
               .data('fv.messages')
               // Hide all the messages
               .find('.help-block[data-fv-for="' + data.field + '"]').hide()
               // Show only message associated with current validator
               .filter('[data-fv-validator="' + data.validator + '"]').show();
       });

});
