$("li.admin-tests").addClass("active");
$("#create-tests").addClass("active");

// Activate Next Step

$(document).ready(function() {
    // DEMO ONLY //
    $('#activate-step-1').on('click', function(e) {
        $('ul.setup-panel li:eq(1)').removeClass('disabled');
        $('ul.setup-panel li a[href="#test-ilr1"]').trigger('click');
        // $(this).remove();
    })

    $('#activate-step-2').on('click', function(e) {
        $('ul.setup-panel li:eq(2)').removeClass('disabled');
        $('ul.setup-panel li a[href="#test-ilr1-plus"]').trigger('click');
        // $(this).remove();
    })
    $('#activate-step-3').on('click', function(e) {
        $('ul.setup-panel li:eq(3)').removeClass('disabled');
        $('ul.setup-panel li a[href="#test-ilr2"]').trigger('click');
        // $(this).remove();
    })


    $('#activate-step-4').on('click', function(e) {
        $('ul.setup-panel li:eq(4)').removeClass('disabled');
        $('ul.setup-panel li a[href="#test-ilr2-plus"]').trigger('click');
        // $(this).remove();
    })

    $('#activate-step-5').on('click', function(e) {
        $('ul.setup-panel li:eq(5)').removeClass('disabled');
        $('ul.setup-panel li a[href="#test-ilr3"]').trigger('click');
        // $(this).remove();
    })

});


// test status
$('#test_status').click(function() {
  // var test_status = 0;
  if ($(this).is(':checked')) {
    $(this).val("1");
  }else {
    $(this).val("0");
  }
  console.log($(this).val());
});


// prevent selecting the same option from a different select box
$(".select-prompt").change(function(){
  $(".select-prompt option").prop("disabled",""); //enable everything
  //collect the values from selected;
  var arr = $.map($(".select-prompt option:selected"), function(n){
    return n.value;
  });
  $(".select-prompt option").filter(function(){
    return $.inArray($(this).val(),arr)>-1;
  }).prop("disabled","disabled");
});

// create test
$('#create_test').click(function(){
  var test_status = $('#test_status').val();
  var test_title = $('#test_title').val();
  var test_language = $('#test_language').val();
  var test_industry = $("#test_industry").val();
  var test_description = $('#test_description').val();
  var test_time = $('#test_time').val();
  var test_price = $('#test_price').val();

  var test_ilr1_prompt1 = $('#ilr1_prompt1 option:selected').val();
  var test_ilr1_prompt2 = $('#ilr1_prompt2 option:selected').val();
  var test_ilr1plus_prompt1 = $('#ilr1plus_prompt1 option:selected').val();
  var test_ilr1plus_prompt2 = $('#ilr1plus_prompt2 option:selected').val();
  var test_ilr2_prompt1 = $('#ilr2_prompt1 option:selected').val();
  var test_ilr2_prompt2 = $('#ilr2_prompt2 option:selected').val();
  var test_ilr2plus_prompt1 = $('#ilr2plus_prompt1 option:selected').val();
  var test_ilr2plus_prompt2 = $('#ilr2plus_prompt2 option:selected').val();
  var test_ilr3_prompt1 = $('#ilr3_prompt1 option:selected').val();
  var test_ilr3_prompt2 = $('#ilr3_prompt2 option:selected').val();

  console.log(test_ilr1_prompt1);
  console.log(test_ilr1_prompt2);
  console.log(test_ilr1plus_prompt1);
  console.log(test_ilr1plus_prompt2);
  console.log(test_ilr2_prompt1);
  console.log(test_ilr2_prompt2);
  console.log(test_ilr2plus_prompt1);
  console.log(test_ilr2plus_prompt2);
  console.log(test_ilr3_prompt1);
  console.log(test_ilr3_prompt2);


  $.post("/tests", {
    status: test_status,
    title: test_title,
    language: test_language,
    industry: test_industry,
    description: test_description,
    time: test_time,
    price: test_price,
    ilr1_prompt1: test_ilr1_prompt1,
    ilr1_prompt2: test_ilr1_prompt2,
    ilr1plus_prompt1: test_ilr1plus_prompt1,
    ilr1plus_prompt2: test_ilr1plus_prompt2,
    ilr2_prompt1: test_ilr2_prompt1,
    ilr2_prompt2: test_ilr2_prompt2,
    ilr2plus_prompt1: test_ilr2plus_prompt1,
    ilr2plus_prompt2: test_ilr2plus_prompt2,
    ilr3_prompt1: test_ilr3_prompt1,
    ilr3_prompt2: test_ilr3_prompt2
  }, function (data, status) {
    if (data.status == "false") {
      console.log("Data: " + data.status);
      console.log("Data: " + data.message);
      return;
    } else {
      console.log("Data: " + data.status);
      console.log("Data: " + data.message);
    }
  });

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
    console.log("recording");
    // button.disabled = true;
    // button.nextElementSibling.disabled = false;
  }
  function stopRecording(button) {
    recorder && recorder.stop();
    console.log("finished");
    // button.disabled = true;
    // button.previousElementSibling.disabled = false;

    // create WAV download link using audio data blob
    // createDownloadLink();

    // terminate previous record
    // recordingslist.innerHTML = "";
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
      // var li = document.createElement('li');
      // var p = document.createElement('p');
      //
      // p.innerHTML = name;
      // li.appendChild(p);
      // recordingslist.appendChild(li);
    });

    console.log("form data created");
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


  // record-btn
    function Recording (){

      $( ".response-stop-record" ).hide();

      $('.response-start-record').click(function(){
        $( '.response-start-record').toggle();
        $( '.response-stop-record').toggle();
      });

      $('.response-stop-record').click(function(){
        $('.response-start-record').toggle();
        $('.response-stop-record').toggle();
        $('.response-start-record').addClass("pointer-events-none");
      });

      $('#next').click(function(){
        $('.response-start-record').show();
        $('.response-stop-record').hide();
        $('.response-start-record').removeClass("pointer-events-none");
      });
    }
    Recording ();
