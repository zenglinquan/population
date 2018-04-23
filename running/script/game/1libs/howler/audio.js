/** 音乐播放器 
* @param obj  播放器id 
* @param file  音频文件 mp3: ogg: 
* @param loop  是否循环 
*/
function audioplayer(id, file, loop){ 
  var audioplayer = document.getElementById(id); 
  if(audioplayer!=null){ 
    document.body.removeChild(audioplayer); 
  } 
  
  if(typeof(file)!='undefined'){ 
    if(navigator.userAgent.indexOf("MSIE")>0){// IE 
    
    var player = document.createElement('bgsound'); 
    player.id = id; 
    player.src = file['mp3']; 
    player.setAttribute('autostart', 'true'); 
    if(loop){ 
      player.setAttribute('loop', 'infinite'); 
    } 
    document.body.appendChild(player); 
      
    }else{ // Other FF Chome Safari Opera 
    
    var player = document.createElement('audio'); 
    player.id = id; 
    player.setAttribute('autoplay','autoplay'); 
    if(loop){ 
      player.setAttribute('loop','loop'); 
    } 
    document.body.appendChild(player); 
      
    var mp3 = document.createElement('source'); 
    mp3.src = file['mp3']; 
    mp3.type= 'audio/mpeg'; 
    player.appendChild(mp3); 
      
    var ogg = document.createElement('source'); 
    ogg.src = file['ogg']; 
    ogg.type= 'audio/ogg'; 
    player.appendChild(ogg); 
      
    } 
  } 
} 