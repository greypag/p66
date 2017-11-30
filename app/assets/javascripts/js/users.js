// invite users
$('#send_invitation').click(function(){
  var invite_email = $('#invite_email').val();
  var invite_subject = $('#invite_subject').val();
  var invite_content = $('#invite_content').val();
  console.log(invite_email);
  console.log(invite_subject);
  console.log(invite_subject);

  $.post( "/invite_user", {
    invite_email: invite_email,
    invite_subject: invite_subject,
    invite_content: invite_content
  });
});

// invite as rater
$('#invite_as_rater').click(function(){
  var id = this.value;
  // console.log(id);
  $.post( "/invite_as_rater", {
    user_id: id
  });
});
