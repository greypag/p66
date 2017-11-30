  $(document).ready(function () {
if(!$("input[name='inbox_message']").is(':checked')){
    // $('#check-all-inbox').prop("checked", false);
}
});

$(document).ready(function () {

  // inbox select all
  $("#check-all-inbox").click(function () {
    if ($("#check-all-inbox").prop("checked") == true) {
      $("input[name='inbox_message']").each(function(){
        $(this).prop("checked", true);
      });
    }else {
      $("input[name='inbox_message']").each(function(){
        $(this).prop("checked", false);
      });
    }
  });

    $("input[name='inbox_message']").click(function(){

        $("#check-all-inbox").prop("checked", false);

  });
  // sendbox select all
  $("#check-all-sendbox").click(function () {
    if ($("#check-all-sendbox").prop("checked") == true) {
      $("input[name='sendbox_message']").each(function(){
        $(this).prop("checked", true);
      });
    }else {
      $("input[name='sendbox_message']").each(function(){
        $(this).prop("checked", false);
      });
    }
  });
});
$("input[name='sendbox_message']").click(function(){

    $("#check-all-sendbox").prop("checked", false);

});

// trim the string
$(function(){
  var len = 105;
  $(".JQellipsis").each(function(i){
      if($(this).text().length>len){
          $(this).attr("title",$(this).text());
          var text=$(this).text().substring(0,len-1)+"...";
          $(this).text(text);
      }
  });
});
// $("tr[data-link]").click(function() {
//   window.location = this.data("link")
// })
jQuery(document).ready(function($) {

  $("tr.clickable-row").click(function(evt) {
    if(!$(evt.target).is('input[type=checkbox]')){
      window.location.href = $(this).find("a").attr("href");
    }
    if (($(evt.target).is('td.checkbox-td'))) {
      window.location.href = 'javascript:;';
    }
  });

});



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

    $('#new_message').formValidation({
        framework: 'bootstrap',
        icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            'message[content]': {
                validators: {
                    notEmpty: {
                        message: 'The content is required and cannot be empty'
                    }
                }
            },
            'message[subject]': {
                validators: {
                    notEmpty: {
                        message: 'The subject is required and cannot be empty'
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

    // clean message text
      $('#discard').click(function(){
        $('#message_content').val('');
        $('#message_subject').val('');
        $('#reply_content').val('');
        $('#new_message').data('formValidation').resetForm();
      });
});
