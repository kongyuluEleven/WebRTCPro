'use strict';

 
var audioSource = document.querySelector('select#audioSource');
var audioOutput = document.querySelector('select#audioOutput');
var videoSource = document.querySelector('select#videoSource');
// 获取video标签
var videoplay = document.querySelector('video#player');
 
// deviceInfos是设备信息的数组
function gotDevices(deviceInfos){
  // 遍历设备信息数组， 函数里面也有个参数是每一项的deviceinfo， 这样我们就拿到每个设备的信息了
  deviceInfos.forEach(function(deviceinfo){
    // 创建每一项
    var option = document.createElement('option');
    option.text = deviceinfo.label;
    option.value = deviceinfo.deviceId;
  
    if(deviceinfo.kind === 'audioinput'){ // 音频输入
      audioSource.appendChild(option);
    }else if(deviceinfo.kind === 'audiooutput'){ // 音频输出
      audioOutput.appendChild(option);
    }else if(deviceinfo.kind === 'videoinput'){ // 视频输入
      videoSource.appendChild(option);
    }
  })
}
 
// 获取到流做什么， 在gotMediaStream方面里面我们要传人一个参数，也就是流，
// 这个流里面实际上包含了音频轨和视频轨，因为我们通过constraints设置了要采集视频和音频
// 我们直接吧这个流赋值给HTML中赋值的video标签
// 当时拿到这个流了，说明用户已经同意去访问音视频设备了
function gotMediaStream(stream){  
  videoplay.srcObject = stream; // 指定数据源来自stream,这样视频标签采集到这个数据之后就可以将视频和音频播放出来
  // 当我们采集到音视频的数据之后，我们返回一个Promise
  return navigator.mediaDevices.enumerateDevices();
}
 
function handleError(err){
  console.log('getUserMedia error:', err);
}
 
// 判断浏览器是否支持
if(!navigator.mediaDevices ||
  !navigator.mediaDevices.getUserMedia){
  console.log('getUserMedia is not supported!');
}else{
  var constraints = { // 表示同时采集视频金和音频
    video : true,
    audio : false 
  }
  navigator.mediaDevices.getUserMedia(constraints)
    .then(gotMediaStream)  // 使用Promise串联的方式，获取流成功了
    .then(gotDevices)
    .catch(handleError);
}

