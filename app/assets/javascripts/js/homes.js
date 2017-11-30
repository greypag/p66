
$('.modal').on('show.bs.modal', function () {

  $('.modal').not($(this)).each(function () {
    $(this).modal('hide');
    // console.log($(this)[0]);
    // $('body').removeClass('modal-open');
    // $('.modal-backdrop').hide();
    // $('.modal').removeClass('fade');
    // $('.modal').modal('hide');
    // $('.modal-backdrop').fadeOut(150).on('hidden.bs.modal', $('.modal-backdrop').fadeOut(150));


    // $('#forgot-email-btn').click(function(){
      // $('.modal-backdrop').hide();


    // });


  });
});

// $(".close").click(function () {
//    $('.modal-backdrop').hide();
// $('.modal').on('hidden.bs.modal', function () {
//   $('.modal-backdrop').show();
//     });
// });

// $(function() {
//   return $(".modal").on("show.bs.modal", function() {
//     var curModal;
//     curModal = this;
//     $(".modal").each(function() {
//       if (this !== curModal) {
//         $(this).modal("hide");
//         // $('.modal-backdrop').hide().on('hidden.bs.modal');
//
//       }
//     });
//   });
//   // $('.modal').show();
// });

// if ($(".modal").attr("aria-hidden") === "false") {
//   $(".modal").modal('hide').on('hidden.bs.modal', function (event) {
//       $('.modal-backdrop').hide();
//   });
// } else {
//     $('.modal-backdrop').hide();
// }


// forget password
$("#forgot-pass-submit").click(function () {


  $("#forget_password_error_msg").empty();

  var email = $('#InputEmailForgotPass').val();

  if(email == ""){
      $("#forget_password_error_msg").append( "<p style='color:red;'>Please Type in Email</p>" );
      return;
  }

  $.post("/forget_password", {
    email: email
  }, function (data, status) {
    if(data.status == "false"){
      $( "#forget_password_error_msg" ).append( "<p style='color:red;'>"+data.message+"</p>" );
      return;
    }else {
      // console.log("Data: " + data + "\nStatus: " + status);
      // var a = $(this).attr("data-dismiss");
      $(this).attr("data-dismiss","modal");

      // $(this).data("data-dismiss","modal");
      console.log($(this)[0]);
      console.log("Data: " + data.status);
      console.log("Data: " + data.message);
      // $('.modal-backdrop').hide();
      $('#modal-forgot-pass').modal('hide');
      $('#modal-thankyou-password').modal('show');

    }
  });
});

// forget email
$("#forgot-email-submit").click(function () {

  $( "#forget_email_error_msg" ).empty();

  var f_name = $('#InputFirstname').val();
  var l_name = $('#InputLastname').val();
  var doy = $('#user_date_of_birth_1i').val();
  var dom = $('#user_date_of_birth_2i').val();
  var dod = $('#user_date_of_birth_3i').val();
  var date_of_birth = doy + "-" + dom + "-" + dod;

  if(f_name == ""){
      $( "#forget_email_error_msg" ).append( "<p style='color:red;'>Please Type in First Name</p>" );
      return;
  }
  if(l_name == ""){
      $( "#forget_email_error_msg" ).append( "<p style='color:red;'>Please Type in Last Name</p>" );
      return;
  }
  if(doy == ""){
      $( "#forget_email_error_msg" ).append( "<p style='color:red;'>Please Select Year of Birth</p>" );
      return;
  }
  if(dom == ""){
      $( "#forget_email_error_msg" ).append( "<p style='color:red;'>Please Select Month of Birth</p>" );
      return;
  }

  if(dod == ""){
      $( "#forget_email_error_msg" ).append( "<p style='color:red;'>Please Select Day of Birth</p>" );
      return;
  }

  $.post("/forget_email", {
    f_name: f_name,
    l_name: l_name,
    date_of_birth: date_of_birth
  }, function (data, status) {
    if(data.status == "false"){
      $( "#forget_email_error_msg" ).append( "<p style='color:red;'>"+data.message+"</p>" );

      return;
    }else{
      // console.log("Data: " + data + "\nStatus: " + status);
      console.log("Data: " + data.status);
      console.log("Data: " + data.message);
      $('#forgot-email-submit').attr("data-dismiss","modal");
      $('#modal-forgot-email').modal('hide');
      $('#modal-thankyou-email').modal('show');
    }
  });
});

// login
$("#login_submit").click(function () {

  $( "#login_error_msg" ).empty();

    var email = $('#InputEmail1').val();
    var password = $('#InputPassword1').val();

    if(email == ""){
        $( "#login_error_msg" ).append( "<p style='color:red;'>Please Type in Email</p>" );

        return;
    }

    if(password == ""){
        $( "#login_error_msg" ).append( "<p style='color:red;'>Please Type in Password</p>" );

        return;
    }


    $.post("/login", {
      email: email,
      password: password
    }, function (data, status) {
      // console.log("Data: " + data + "\nStatus: " + status);
      if(data.status == "false"){
        $( "#login_error_msg" ).append( "<p style='color:red;'>"+data.message+"</p>" );
        return;
      }else{
        //redirect to cms
        // console.log("Data: " + data.status);
        // console.log("Data: " + data.message);
        // window.location.href = "/home";
      }
    });
});

// add to cart

// $('.cart').click(function(){

  // console.log(tests);
  // var test_items = JSON.stringify(tests);
  // console.log(test_items);

  // $('.modal').not($(this)).each(function () {
    // $(this).modal('hide');
  // });

  // $.post("/add_to_cart", {
    // test: test_items
  // });
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

    $('#login').formValidation({
        framework: 'bootstrap',
        icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            'login_password': {
                validators: {
                    notEmpty: {
                        message: 'The password is required and cannot be empty'
                    },
                    securePassword: {
                        message: 'The password is not valid'
                    }
                }
            },
            'login_email': {
              validators: {
                notEmpty: {
                    message: 'The email is required and cannot be empty'
                },
                  regexp: {
                      regexp: '^[^@\\s]+@([^@\\s]+\\.)+[^@\\s]+$',
                      message: 'The value is not a valid email address'
                  }
              }
           }
        }
    }).on('err.validator.fv', function(e, data) {
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
      $('#forget_email').formValidation({
          framework: 'bootstrap',
          icon: {
              valid: 'glyphicon glyphicon-ok',
              invalid: 'glyphicon glyphicon-remove',
              validating: 'glyphicon glyphicon-refresh'
          },
          fields: {
            'forget_f_name': {
              validators: {
                notEmpty: {
                    message: 'The field is required and cannot be empty'
                }
              }
           },
              'forget_l_name': {
                validators: {
                  notEmpty: {
                      message: 'The field is required and cannot be empty'
                  }
                }
             }
          }
      }).on('err.validator.fv', function(e, data) {
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
          $('#forget_password').formValidation({
              framework: 'bootstrap',
              icon: {
                  valid: 'glyphicon glyphicon-ok',
                  invalid: 'glyphicon glyphicon-remove',
                  validating: 'glyphicon glyphicon-refresh'
              },
              fields: {
                'forget_email': {
                  validators: {
                    notEmpty: {
                        message: 'The field is required and cannot be empty'
                    },
                      regexp: {
                          regexp: '^[^@\\s]+@([^@\\s]+\\.)+[^@\\s]+$',
                          message: 'The value is not a valid email address'
                      }
                  }
               }
              }
          }).on('err.validator.fv', function(e, data) {
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
