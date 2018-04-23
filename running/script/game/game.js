"use strict";

//var width;
//var height;
var context;
var canvas;
var currentScale;

var FRAMES_PER_SECOND = 30;

var level = null;
var transform = new Transform();
var thisGame; 
var meter;
var lastUpdate = Date.now();
var movingLeft = false;
var movingRight = false; 

var backgroundMusic; 
var emptySound; 
var failSound; 
var footStepSound;
var hitCoinSound;
var hitRockSound; 
var hitSauceSound; 
var carSound;
var spinSound;
var pylonSound;
var loseSauceSound1;
var jumpSound;

var playedEmptySound = false;
//var canvasWidth = 0;
//var soundMuted = false;

var configData; 

var shopScreen;
var loadingScreen;
var startScreen;
var endScreen;

var screenManager;

var touches = [];

var inputType = null;

var language = tortilla.parameters.get("language", "en_GB");
function getLangString(key, fb) {
	var langIndex = LANGUAGES.indexOf(language);
	if (langIndex === -1) langIndex = 10000;
	var mls = LANGUAGE[key];
	if (typeof mls === "undefined") {
		return (typeof fb === "undefined") ? ("?" + key) : fb;
	}
	var val = mls[langIndex];
	if (typeof val === "undefined") {
		return (typeof fb === "undefined") ? ("?" + key + ":" + language) : fb;
	}
	return val;
}

var PACKAGE = "pixelkaiju.runner";

var STOR_LEVEL = "level";
var STOR_EGGS = "eggs";
var STOR_SOUNDMUTED = "soundMuted";
var STOR_POWERUPS = "powerUps";

var highestReachedLevel;
var totalEggs;

var spil = null;
var SPILLOGOSCALE = 0.3;
var SPIL_A10 = true;

tortilla.game = {
	settings: function() {
		return {
			showFps: tortilla.parameters.has("showFps"),
			namespace: PACKAGE
		};
	},
	init: function() {
		init();
	},
	frame: function(c, dt) {
		
		context = c;
	    context.imageSmoothingEnabled = true;
	    context.mozImageSmoothingEnabled = true;
	    context.webkitImageSmoothingEnabled = true;
		
		if (configData)
			gameLoop(dt * 1000);
	}
};

var muteManual = false;

function toggleSound() {
	
	muteManual = !muteManual;
	
	tortilla.storagePut(STOR_SOUNDMUTED, muteManual);
	
	updateMute();
	
}

/*function updateMute() {
	if (!ENABLE_SOUND || muteManual || (spil != null && spil.inAd) || !tortilla.isVisible()) Howler.mute();
	else Howler.unmute();
}*/

function updateMute() {
	if (!ENABLE_SOUND || muteManual || !tortilla.isVisible()) Howler.mute();
	else Howler.unmute();
}

function init()
{
	
//	console.log("VERSION: " + VERSION + " (build " + new Date(tortilla.BUILD_TIME) + ")");
	thisGame = window; // bleh
	
	highestReachedLevel = tortilla.storageGetNumber(STOR_LEVEL, 1);
	totalEggs = tortilla.storageGetNumber(STOR_EGGS, 0);
//	console.log("level", highestReachedLevel, "eggs", totalEggs);
	
	muteManual = tortilla.storageGetBoolean(STOR_SOUNDMUTED, false);
	updateMute();
	
	var powerUps = tortilla.storageGetObject(STOR_POWERUPS, {});
	POWERUPS.forEach(function(powerUp) {
		var sid = ""+powerUp.id;
		if (powerUps.hasOwnProperty(sid)) {
			powerUp.amount = powerUps[sid];
		}
	});
	
	canvas = tortilla.canvas; //document.getElementById('canvas');
	initUserInput();
    updateMute();
    tortilla.addEventListener("visibilityChanged", updateMute);

    if (tortilla.platform == "browser") {// || tortilla.parameters.has("spil")) {
    	spil = {
    			logoImage: null,
    			api: null,
    			showAd: function() {},
    			inAd: false
    	};
    	console.log("Spil Games edition");    	tortilla.loadScript("./game.js", function(success, error) {
    		if (success) {
//  			console.log("Spil game.js loaded");
    			GameAPI.loadAPI (function(api) {
//  				console.log("GameAPI loaded", api);
    				spil.api = api;
    				
    				// determine logo
    				/*var logoData;
    				if (SPIL_A10) { // hardcode A10
    					var goA10 = function() {
							var win = window.open('http://a10.com/', '_blank');
			    			win.focus();
						};
    					logoData = {
    							image: "a10logo.png",
    							action: goA10
    					};
    					spil.moreGamesAction = goA10;
    				} else {
    					logoData=api.Branding.getLogo();
    					spil.moreGamesAction = null; // TODO
    				}*/
    				
    				// set logo
    				/*if (!logoData || logoData.hasOwnProperty("error")) {
    					console.log("No logo");
    				} else {
    					spil.logoAction = logoData.action;
    					
    					// load the logo
	    				var image = new Image();
	    				image.addEventListener("load", function(){
	    					spil.logoImage = image;
						});
	    				image.src = logoData.image;
    				}
    				
    				spil.showAd = function() {
    					api.GameBreak.request(function() {
    						spil.inAd = true;
    						updateMute();
    					}, function() {
    						spil.inAd = false;
    						updateMute();
    					});
    				};*/
    				
    				doLoadConfig();
    			});
    		} else {
//  			console.log("Error loading Spil game.js", error);
    			doLoadConfig();
    		}
    	});
    } else {
    	doLoadConfig();
    }

//  Load config
    function doLoadConfig() {
//	    console.log("Start loading json: ",canvas);
//		loadJSON(CONFIG_PATH, function(data) {
    	needToLoad++;
    	setTimeout(function() {
    		assetLoaded();
//			console.log("JSON LOADED: ",canvas);
			configData = CONFIG;
			canvas.addEventListener('mousemove', onMouseMove, false);
//		    console.log("start loading assets: ", canvas);
			loadAssets();
    	}, 100);
//		});
    }
}

function loadAssets()
{
	console.log("thisgame: " + thisGame);
//	document.addEventListener("WeixinJSBridgeReady", function () {
//		document.getElementById('audio').load();//load重新加载音频，实现苹果预加载
//		backgroundMusic = loadSound('sounds/runkaijurun.mp3', 'sounds/runkaijurun.ogg', true);
//	    failSound = loadSound('sounds/fail.mp3', 'sounds/fail.ogg', false);
//	    footStepSound = loadSound('sounds/footstep.mp3', 'sounds/footstep.ogg', false);
//	    hitCoinSound = loadSound('sounds/coin.mp3', 'sounds/coin.ogg', false);
//	    hitRockSound = loadSound('sounds/crash.mp3', 'sounds/crash.ogg', false);
//	    hitSauceSound = loadSound('sounds/sauce.mp3', 'sounds/sauce.ogg', false);
//	    spinSound = loadSound('sounds/spin.mp3', 'sounds/spin.ogg', false);
//	    pylonSound = loadSound('sounds/knock.mp3', 'sounds/knock.ogg', false);
//	    carSound = loadSound('sounds/hitcar.mp3', 'sounds/hitcar.ogg', false);
//	    emptySound = loadSound('sounds/empty.mp3', 'sounds/empty.ogg', false);
//	    loseSauceSound1 = loadSound('sounds/throwsauce.mp3', 'sounds/throwsauce.ogg', false);
//	    jumpSound = loadSound('sounds/jump.mp3', 'sounds/jump.ogg', false);
//	}, false);
   
	if ("Safari" != myBrowser()) {
    	console.log("我不是 Safari");
    	backgroundMusic = loadSound('sounds/runkaijurun.mp3', 'sounds/runkaijurun.ogg', true);
	    failSound = loadSound('sounds/fail.mp3', 'sounds/fail.ogg', false);
	    footStepSound = loadSound('sounds/footstep.mp3', 'sounds/footstep.ogg', false);
	    hitCoinSound = loadSound('sounds/coin.mp3', 'sounds/coin.ogg', false);
	    hitRockSound = loadSound('sounds/crash.mp3', 'sounds/crash.ogg', false);
	    hitSauceSound = loadSound('sounds/sauce.mp3', 'sounds/sauce.ogg', false);
	    spinSound = loadSound('sounds/spin.mp3', 'sounds/spin.ogg', false);
	    pylonSound = loadSound('sounds/knock.mp3', 'sounds/knock.ogg', false);
	    carSound = loadSound('sounds/hitcar.mp3', 'sounds/hitcar.ogg', false);
	    emptySound = loadSound('sounds/empty.mp3', 'sounds/empty.ogg', false);
	    loseSauceSound1 = loadSound('sounds/throwsauce.mp3', 'sounds/throwsauce.ogg', false);
	    jumpSound = loadSound('sounds/jump.mp3', 'sounds/jump.ogg', false);
	}else{
		console.log("我是Safari")
	}
    allAssetsLoaded = initialLoadingComplete; 
    
    loadingScreen = new LoadingScreen(context, thisGame);
    loadingScreen.isVisible = true;
 
    console.log("MAKE SCREENS");
    startScreen = new StartScreen(context, thisGame);
    endScreen = new EndScreen(context, thisGame);
    shopScreen = new ShopScreen(context, thisGame);
    
    screenManager = new ScreenManager();
    screenManager.addScreens([startScreen, endScreen, loadingScreen, shopScreen]);
    
//  TODO: dont load level 1 but only the assets that are always used, like the playersprites and the hud
//    console.log("NEW LEVEL");
//    level = new Level(context, thisGame, 1, 10, 1);
    
	
    
};


function pointToTransformedPoint(x, y)
{
	var inverted = transform.clone();
	inverted.invert();
	var point = inverted.transformPoint(x, y);
	
	return new Point(point[0], point[1]);
}

function initUserInput() {
	
	canvas.addEventListener("touchstart", saveTouches);
    canvas.addEventListener("touchend", saveTouches);
	canvas.addEventListener("touchmove", saveTouches);
    canvas.addEventListener("touchenter", saveTouches);
    canvas.addEventListener("touchleave", saveTouches);
    canvas.addEventListener("touchcancel", saveTouches);
	
	var hammer = Hammer(document.body, {
		swipe_time: 1000,
		swipe_min_distance: 1,
		swipe_velocity: 0
	});
	
	if (tortilla.platform == "cocoonjs") {
		
		canvas.addEventListener("touchstart", function(e) {
			if (inputType == null) {
				inputType = "touch";
				console.log("Input type: " + inputType);
			}
			var t = e.changedTouches[0];
			click(t.clientX, t.clientY);
		});
		
	} else {
		
		hammer.on("tap", function(event) {
			
			if (inputType == null) {
				inputType = event.gesture.pointerType == Hammer.POINTER_MOUSE ? "keyboard" : "touch";
				console.log("Input type: " + inputType);
			}
			
	//		console.log("tap", transformedCoordinates);
			
			click(event.gesture.center.pageX, event.gesture.center.pageY);
		});
		
	}
	
	function click(x,y) {
		var canvasCoordinates  = tortilla.windowToCanvas(x, y);
		var transformedCoordinates = pointToTransformedPoint(canvasCoordinates.x, canvasCoordinates.y);
		
		if (!playedEmptySound){
	        playedEmptySound = true;
	        if ("Safari" != myBrowser()) {
    			emptySound.play();
    		}
	    }
		
		if (isSpilLogo(transformedCoordinates)) {
			spil.logoAction();
			return;
		}
		
		screenManager.handleTap(transformedCoordinates);

		if (level != null && level.isVisible){
//			console.log("tap level");
			level.handleTap(transformedCoordinates);
		}
	}
	
}

function startLevel(levelID)
{
	levelID = (levelID == -1?level.levelID:levelID);
	
	console.log( "startlevel: " + levelID);
	
	screenManager.hideAllScreens();
	
	allAssetsLoaded = levelLoadingComplete;
	loadingScreen.isVisible = true;
    console.log("NEW LEVEL");
	level = new Level(context, thisGame, levelID, getLevelTime(levelID), getLevelSpeed(levelID) * (inputType == "touch" ? 0.75 : 1));
}
//TODO: as level gets more attributes, change this to getLevelData
function getLevelTime(levelID)
{
	
	return 360000; // i.e. no time limit
	
//	for(var i = 0; i < configData.levels.length; i++)
//	{
//		if (configData.levels[i].id == levelID){
//			return configData.levels[i].time;
//		}
//	}
//	
//	return null;
}
function getLevelSpeed(levelID)
{
	for(var i = 0; i < configData.levels.length; i++)
	{
		if (configData.levels[i].id == levelID){
			var l = configData.levels[i];
			return l.hasOwnProperty("speed") ? l.speed : 1;
		}
	}
	
	return null;
}

function showStartScreen()
{
	screenManager.hideAllScreens();
    startScreen.isVisible = true;
//  var ww_start=window.innerWidth;
//  var hh_start=window.innerHeight;
//  if(ww_start<hh_start){
//	    $('#picture').css({'opacity':'1'});
//  }else{
//  	$('#picture').css({'opacity':'0'});
//  }
}

function showEndScreen(eggs, score, hits,distance, succes, resultString)
{
	//console.log("resultString: " + resultString)
	
	//Reset activated powerups
	 for (var i = 0; i < POWERUPS.length; i++)
	 {
		 POWERUPS[i].activated = 0;
	 }
	
	//submitScore(eggs, resultString);
	endScreen.isVisible = true;
	
	if (eggs != undefined){
		endScreen.setResult(eggs, score, hits,distance,succes);
	}
}

function completedLevel(eggs, levelID)
{
	totalEggs += eggs;
	highestReachedLevel = clamp(levelID + 1, highestReachedLevel, configData.levels.length); 
	writeProgress();
}

function writeProgress() {
	console.log("save; level", highestReachedLevel, "eggs", totalEggs);
		
	tortilla.storagePut(STOR_LEVEL, highestReachedLevel);
	tortilla.storagePut(STOR_EGGS, totalEggs);
	
	var powerUps = {};
	POWERUPS.forEach(function(powerUp) {
		powerUps[""+powerUp.id] = powerUp.amount;
	});		
	tortilla.storagePut(STOR_POWERUPS, powerUps);
	
}

function endLevel()
{
	showMapScreen();
	level.isVisible = false;
}

function submitScore(score, resultString)
{
	//TODO: Submit score to database
	//alert("TODO: submitscore" + score);
}

function stopAllMusic()
{
	backgroundMusic.stop();
}

function levelLoadingComplete()
{
	allAssetsLoaded = function(){};
	loadingScreen.isVisible = false;
	level.isVisible = true;
}

function initialLoadingComplete()
{
	allAssetsLoaded = function(){};
	console.log("starting game");
	if ("Safari" != myBrowser()) {
   	 	startMusic();
   	}
    console.log("music started");

    showStartScreen();
    startScreen.animateScreen();
    //gameOverlay.isVisible = true;
    loadingScreen.isVisible = false;
    console.log("startscreen visible");
}

function startMusic() {
	stopAllMusic();
	backgroundMusic.play();
}

function onMouseMove(e) {
	var canvasCoordinates  = tortilla.windowToCanvas(e.pageX, e.pageY);
	var transformedCoordinates = pointToTransformedPoint(canvasCoordinates.x, canvasCoordinates.y);
	screenManager.checkMouseOver(transformedCoordinates); //mouseToCanvasCoordinates(transformedTap.x, transformedTap.y));
	
	if (isSpilLogo(transformedCoordinates)) {
		showHandCursor();
	}
	
}

function saveTouches(e) {
	touches = e.touches;
}

function isSpilLogo(c) {
	if (spil != null && spil.logoImage != null) {
    	var l = spil.logoImage;
    	var lx = GAME_WIDTH - (l.width*SPILLOGOSCALE) - 20;
    	var ly = GAME_HEIGHT - (l.height*SPILLOGOSCALE) - 20;
    	
    	var isIt = 
    		c.x > lx &&
    		c.x < lx + l.width &&
    		c.y > ly &&
    		c.y < ly + l.height;
    	return isIt;
    } else return false;
}

function gameLoop(timePast) {
	transform.reset();
	 
	context.fillStyle = "rgba(255, 255, 255, 0)";
	context.fillRect(0, 0, canvas.width, canvas.height);
	
	context.save();
	try {
		
		var ratioGame = GAME_WIDTH / GAME_HEIGHT;
		var ratioCanvas = canvas.width / canvas.height;
		
		var scaleHor = ratioCanvas < ratioGame;
		if (scaleHor) {
			transform.translate(0, (canvas.height / 2));
			currentScale = canvas.width/GAME_WIDTH;
			transform.scale(currentScale, currentScale);
			transform.translate(0, (-GAME_HEIGHT / 2));
		} else {
			transform.translate((canvas.width / 2), 0); 
			currentScale = canvas.height/GAME_HEIGHT;
			transform.scale(currentScale, currentScale);
			transform.translate((-GAME_WIDTH / 2), 0);
		}
		
		transform.applyToContext(context);
		
		if (ratioCanvas != ratioGame){
			context.beginPath();
			context.rect(0, 0, GAME_WIDTH, GAME_HEIGHT);
			context.clip();
		}
		
	    //FUCKUP framerate
	//    if (getRandomInt(0, 3) != 3){
	//        requestAnimFrame(gameLoop);
	//        return;
	//    }
	
	    //draw(); 
	    
	    //The factor of expected time past. The game expects 60 frames p/s, witch is 16,667 miliseconds.
	    var timeFactor = (timePast / MAX_SPF);
	
	    if (level != null && level.isVisible){
	        level.update(timeFactor, timePast);
	    }
	    
	    if (screenManager){
	    	screenManager.updateScreens(timeFactor);
	    }
	    
	    
/*	    if (spil != null && spil.logoImage != null) {
	    	var l = spil.logoImage;
	    	drawImageScaled(context, l, GAME_WIDTH - (l.width*SPILLOGOSCALE) - 20, GAME_HEIGHT - (l.height*SPILLOGOSCALE) - 20, SPILLOGOSCALE);
//	    	context.drawImage(l, GAME_WIDTH - l.width - 20, GAME_HEIGHT - l.height - 20);
	    }*/
    
	} finally {
		context.restore();
	}
}

