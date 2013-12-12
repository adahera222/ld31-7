package game;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.util.FlxSave;

/**
* Handy, pre-built Registry class that can be used to store 
* references to objects and other things for quick-access. Feel
* free to simply ignore it or change it in any way you like.
*/
class Reg {
	static public var FPS:Int = 60;

	static public var map:TiledLevel;

	static public var inactives:FlxGroup = new FlxGroup();

	/** Current game state. */
	static public var state:FlxState; 

	static public var player:Player;
	static public var mapX:Int = 0;	
	static public var mapY:Int = 0;	

	static public var mapWidth:Int = 25 * 30;
	static public var mapHeight:Int = 25 * 30;
}