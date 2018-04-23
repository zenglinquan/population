/**
 * Created by Christiaan Duim on 30-9-13.
 */

"use strict";

ShopScreen.prototype = inherit(Screen.prototype);
ShopScreen.prototype.super = Screen.prototype;

//var POWERUP_JUMP_LEVEL = {level:0, maxLevel:5, step:1, price:250, name:"Hoger springen", id:1, button:"addJumpButton"} ; 					//Range 1-5
var MAPSCALE = 0.5;

//TODO: Move this data to json file
var POWERUP_HEAD_START = {amount:0, price:50, activated:0, name:getLangString("powerUps.headstart"), id:3, button:"addHeadStartButton", shopPosX:200, shopPosY:95, alignLeft:true, distance:70};	//distance in meters
var POWERUP_EXTRA_HEALTH = {amount:0, price:75, activated:0, name:getLangString("powerUps.extraLife"), id:4, button:"addHealthButton",  shopPosX:623, shopPosY:100, alignLeft:true};
var POWERUP_MAGNET_LEVEL = {amount:0, price:100, activated:0, name:getLangString("powerUps.magnet"), id:2, button:"addMagnetButton", shopPosX:634, shopPosY:213, alignLeft:false, power:5}; 	//power range 1-5

var POWERUPS = [POWERUP_MAGNET_LEVEL, POWERUP_HEAD_START, POWERUP_EXTRA_HEALTH];

var RETURNSCREEN_STARTSCREEN = "startscreen";
var RETURNSCREEN_ENDSCREEN = "endscreen";
var RETURNSCREEN_MAPSCREEN = "mapscreen";

function ShopScreen(context, game)
{
}

