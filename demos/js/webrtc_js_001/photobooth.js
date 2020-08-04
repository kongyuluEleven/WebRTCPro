'use strict';

function hasUserMedia() {
  return !!(navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);
}

// Put variables in global scope to make them available to the browser console.
const constraints = window.constraints = {
  audio: false,
  video: true
};

function handleSuccess(stream) {
  const video = document.querySelector('video');
  const videoTracks = stream.getVideoTracks();
  console.log('Got stream with constraints:', constraints);
  console.log(`Using video device: ${videoTracks[0].label}`);
  window.stream = stream; // make variable available to browser console
  video.srcObject = stream;
}

function handleError(error) {
  if (error.name === 'ConstraintNotSatisfiedError') {
    const v = constraints.video;
    errorMsg(`The resolution ${v.width.exact}x${v.height.exact} px is not supported by your device.`);
  } else if (error.name === 'PermissionDeniedError') {
    errorMsg('Permissions have not been granted to use your camera and ' +
      'microphone, you need to allow the page access to your devices in ' +
      'order for the demo to work.');
  }
  errorMsg(`getUserMedia error: ${error.name}`, error);
}

function errorMsg(msg, error) {
  const errorElement = document.querySelector('#errorMsg');
  errorElement.innerHTML += `<p>${msg}</p>`;
  if (typeof error !== 'undefined') {
    console.error(error);
  }
}

async function init(e) {
  try {
    const stream = await navigator.mediaDevices.getUserMedia(constraints);
    handleSuccess(stream);
    e.target.disabled = true;
  } catch (e) {
    handleError(e);
  }
}

document.querySelector('#capture').addEventListener('click', e => init(e));

// if (hasUserMedia()) {
//   navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;

//   var video = document.querySelector('video'),
//       canvas = document.querySelector('canvas'),
//       streaming = false;

//   navigator.getUserMedia({
//     video: true,
//     audio: false
//   }, function (stream) {
//     video.src = window.URL.createObjectURL(stream);
//     streaming = true;
//   }, function (error) {
//     console.log("Raised an error when capturing:", error);
//   });

//   var filters = ['', 'grayscale', 'sepia', 'invert'],
//       currentFilter = 0;
//   document.querySelector('#capture').addEventListener('click', function (event) {
//     if (streaming) {
//       canvas.width = video.clientWidth;
//       canvas.height = video.clientHeight;

//       var context = canvas.getContext('2d');
//       context.drawImage(video, 0, 0);

//       currentFilter++;
//       if(currentFilter > filters.length - 1) currentFilter = 0;
//       canvas.className = filters[currentFilter];

//       context.fillStyle = "white";
//       context.fillText("Hello World!", 10, 10);
//     }
//   });
// } else {
//   alert("Sorry, your browser does not support getUserMedia.");
// }
