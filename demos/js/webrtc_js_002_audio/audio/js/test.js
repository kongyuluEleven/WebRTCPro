

'use strict';

// Put variables in global scope to make them available to the browser console.
const audio = document.querySelector('audio');

const constraints = window.constraints = {
  audio: true,  //设置约束，只获取音频
  video: false  //设置约束，只获取音频，不获取视频
};

function handleSuccess(stream) {
  //获取所有音频轨
  const audioTracks = stream.getAudioTracks();
  console.log('Got stream with constraints:', constraints);
  console.log('Using audio device: ' + audioTracks[0].label);
  stream.oninactive = function() {
    console.log('Stream ended');
  };
  window.stream = stream; // make variable available to browser console
  audio.srcObject = stream;
}

function handleError(error) {
  const errorMessage = 'navigator.MediaDevices.getUserMedia error: ' + error.message + ' ' + error.name;
  errorMsgElement.innerHTML = errorMessage;
  console.log(errorMessage);
}

navigator.mediaDevices.getUserMedia(constraints).then(handleSuccess).catch(handleError);
