package game;

import flash.display.Bitmap;
import flash.events.Event;
import flash.net.URLRequest;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;

import flixel.addons.ui.FlxInputText;
import flixel.util.FlxPoint;

import flash.display.Loader;
import game.MapAwareSprite;

class FancySprite extends MapAwareSprite {
	public function new(x:Int, y:Int) {
		super(x, y);

		this.drag.x = 2000;
		this.drag.y = 2000;
	}	

	public override function update() {
		super.update();
	}
}
