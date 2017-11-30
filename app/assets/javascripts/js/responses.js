$("li.admin-response").addClass("active");
$("#create-response").addClass("active");
$('.btn-record').click(function(){
  $('span.start-record').toggle();
  $('span.stop-record').toggle();
});
$('.play-prompt').click(function(){
  $('span.play-test').toggle();
  $('span.stop-test').toggle();
});


// browser audio recorder

  var audio_context;
  var recorder;
  function startUserMedia(stream) {
    var input = audio_context.createMediaStreamSource(stream);
    // Uncomment if you want the audio to feedback directly
    //input.connect(audio_context.destination);

    recorder = new Recorder(input);
  }
  function startRecording(button) {
    recorder && recorder.record();
    // button.disabled = true;
    // button.nextElementSibling.disabled = false;
  }
  function stopRecording(button) {
    recorder && recorder.stop();
    // button.disabled = true;
    // button.previousElementSibling.disabled = false;

    // create WAV download link using audio data blob
    // createDownloadLink();

    // terminate previous record
    recordingslist.innerHTML = "";

    sendWaveToPost();

    recorder.clear();
  }
  var data = new FormData();
  var url;
  var name;
  function sendWaveToPost() {
  // console.log(data);
    recorder && recorder.exportWAV(function(blob) {
      url = URL.createObjectURL(blob);
      name = new Date().toISOString() + '.wav';
      data.set('avatar', blob, name);
      //  console.log(data.get('avatar'));
      //  console.log(url);
      var li = document.createElement('li');
      var p = document.createElement('p');

      p.innerHTML = name;
      li.appendChild(p);
      recordingslist.appendChild(li);
      console.log(data);
    });

  }
  function createDownloadLink() {
    recorder && recorder.exportWAV(function(blob) {
      var url = URL.createObjectURL(blob);
      var li = document.createElement('li');
      var au = document.createElement('audio');
      var hf = document.createElement('a');

      au.controls = true;
      au.src = url;
      hf.href = url;
      hf.download = new Date().toISOString() + '.wav';
      hf.innerHTML = hf.download;
      li.appendChild(au);
      li.appendChild(hf);
      recordingslist.appendChild(li);
    });
  }
  window.onload = function init() {
    try {
      // webkit shim
      window.AudioContext = window.AudioContext || window.webkitAudioContext;
      navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia;
      window.URL = window.URL || window.webkitURL;

      audio_context = new AudioContext;
    } catch (e) {
      alert('No web audio support in this browser!');
    }

    navigator.getUserMedia({audio: true}, startUserMedia, function(e) {
    });
  };

// switch form submit & ajax
  $('#response_avatar').on('change', function(){
    if ($('#response_avatar').val() != "") {
      $('#create').prop("type", "submit");
      $("#new_response").attr("action", "/responses");
      $('#new_response').attr('method', 'post');
      // console.log($('#create').prop('type'));

    }else {
      $('#create').prop("type", "button");
      $("#new_response").attr("action", "");
      $('#new_response').attr('method', '');
      // console.log($('#create').prop('type'));
    }
  });
  $('#recorder_btn').click(function(){
    $('#create').prop("type", "button");
    $("#new_response").attr("action", "");
    $('#new_response').attr('method', '');
  });

// response create ajax
  $('#create').click(function(){
    if ($('#create').prop('type') == "button") {
      recorder && recorder.exportWAV(function(blob) {

        var title = $('#response_title').val();
        var language = $('#response_language').val();
        var industry = $('#response_industry').val();
        var level = $('#response_level').val();
        var type = $('#response_type').val();
        var obj = {"title": title, "language": language, "industry": industry, "level": level, "type": type}
        $.each(obj, function(key, value){
          data.append(key, value);
        });

         $.ajax({
           url: '/audio_record_create',
           data: data,
           cache: false,
           contentType: false,
           processData: false,
           type: 'POST'
         });
      });
    }
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

     $('#new_response').formValidation({
         framework: 'bootstrap',
         icon: {
             valid: 'glyphicon glyphicon-ok',
             invalid: 'glyphicon glyphicon-remove',
             validating: 'glyphicon glyphicon-refresh'
         },
         fields: {
             'response[title]': {
                 validators: {
                     notEmpty: {
                         message: 'The title is required.'
                     }
                 }
             },
             'response[language]': {
                 validators: {
                     notEmpty: {
                         message: 'Please select a language.'
                     }
                 }
             },
             'response[industry]': {
                 validators: {
                     notEmpty: {
                         message: 'Please select an industry.'
                     }
                 }
             },
             'response[level]': {
                 validators: {
                     notEmpty: {
                         message: 'Please select a level.'
                     }
                 }
             },
             'response[response_type]': {
                 validators: {
                     notEmpty: {
                         message: 'Please select an type.'
                     }
                 }
             },
             file: {
                // All the email address field have emailAddress class
                selector: '.file_data',
                validators: {
                    callback: {
                        message: 'You must upload at least one file',
                        callback: function(value, validator, $field) {
                            var isEmpty = true,
                                // Get the list of fields
                                $fields = validator.getFieldElements('file');
                            for (var i = 0; i < $fields.length; i++) {
                                if ($fields.eq(i).val() !== '') {
                                    isEmpty = false;
                                    break;
                                }
                            }

                            if (!isEmpty) {
                                // Update the status of callback validator for all fields
                                validator.updateStatus('email', validator.STATUS_VALID, 'callback');
                                return true;
                            }

                            return false;
                        }
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
