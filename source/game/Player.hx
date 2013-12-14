package game;

import flash.display.Bitmap;
import flash.events.Event;
import flash.net.URLRequest;
import flixel.effects.particles.FlxEmitter;
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
import flixel.FlxObject;

import flash.display.Loader;

class Player extends FlxSprite {
	/** test */
	public var tweakable:Array<String>;
	public var derpus:Int = 44;

	public var menuVisible = false;

	private var debuggingMenu:FlxSprite;
	private var debuggingItems:Array<DebugVariable>;

	public function new(x:Int, y:Int) {
		super(x, y);

		this.tweakable = ["x", "y", "velocity", "drag"];

		this.loadGraphic("images/robot.png", true, true, Reg.TILE_WIDTH, Reg.TILE_HEIGHT);

		this.animation.add("idle", [0, 1, 2, 3, 4, 5], 8, true);
		this.animation.play("idle");

		this.drag.x = 2000;

		buildDebuggingMenu();
	}	

	public function buildDebuggingMenu() {
		var currentHeight:Float = this.y;
		var inspectedObject = this;
		var menu:FlxSprite = new FlxSprite(this.x + this.width + 15, this.y - 5);

		this.debuggingMenu = menu;
		this.debuggingItems = [];

		FlxG.state.add(menu);

		for (fieldName in this.tweakable) {
			// Determine the type of the field.
			var value:Dynamic = Reflect.field(inspectedObject, fieldName);
			var variableType = Type.getClassName(Type.getClass(value));
			if (variableType == null) {
				variableType = Std.string(Type.typeof(value));
			}

			var dbg:DebugVariable;

			if (variableType.indexOf("Int") != -1 || variableType.indexOf("String") != -1) {
				 dbg = new DebugNumber(this.x + this.width + 20, currentHeight, fieldName, inspectedObject);
			} else if (variableType.indexOf("FlxPoint") != -1) {
				 dbg = new DebugPoint(this.x + this.width + 20, currentHeight, fieldName, inspectedObject);
			} else {
				continue;
				dbg = null; // catchall for the compiler's sake
			}

			this.debuggingItems.push(dbg);

			trace(dbg.height);

			currentHeight += dbg.height + 10;
		}	

		menu.makeGraphic(Std.int(this.width + 70 + 50), Std.int(currentHeight), 0x66444444);

		hideDebuggingMenu();
	}

	public function hideDebuggingMenu() {
		for (item in this.debuggingItems) {
			item.hide();
		}

		this.debuggingMenu.visible = false;
		this.menuVisible = false;
	}

	public function showDebuggingMenu() {
		// reposition to be in the correct place

		for (dbg in debuggingItems) {
			dbg.reorientTo(this, debuggingMenu);
			dbg.show();
		}

		// update menu last, since the other items currently need to refer to its old position. 
		debuggingMenu.x = this.x + this.width + 15;
		debuggingMenu.y = this.y - 5;

		this.updateDebuggingMenu();

		this.debuggingMenu.visible = true;
		this.menuVisible = true;
	}

	public function updateDebuggingMenu() {
		for (item in this.debuggingItems) {
			item.updateValues();
		}
	}

	public function reloadGraphic() {
		var loader:Loader = new Loader();
		var sprite:Player = this;

		function loadComplete(e:Event) {
		    var loadedBitmap:Bitmap = cast(e.currentTarget.loader.content, Bitmap);
		    sprite.loadGraphic(loadedBitmap.bitmapData);
		}

		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		loader.load(new URLRequest("../../../../../../../assets/images/tileset.png"));
	}

	private var safeLocation:{point:FlxPoint, map:{x:Int, y:Int}};
	private function createRespawnPoint() {
		safeLocation = {point: new FlxPoint(this.x, this.y), map: {x:Reg.mapX, y:Reg.mapY}};
	}

	private function explode() {
		var explosion:FlxEmitter = new FlxEmitter(this.x, this.y, 70);
		explosion.makeParticles("images/boomparticle.png", 20, 0, 2);
		explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.1);
		explosion.start(true, 2);
		FlxG.state.add(explosion);
	}

	private function respawn() {
		explode();

		this.x = safeLocation.point.x;
		this.y = safeLocation.point.y;

		// TODO load map

		// TODO smooth scroll camera back

		flixel.util.FlxSpriteUtil.flicker(this, 1.0);
	}

	private function touchingMap(o1:FlxObject, o2:FlxObject): Void {
		if (this.isTouching(FlxObject.FLOOR)) {
			createRespawnPoint();
		}
	}

	public override function update() {
		super.update();

		if (FlxG.keys.pressed.A) {
			this.velocity.x = -200;
			this.facing = FlxObject.LEFT;
		} 
		if (FlxG.keys.pressed.D) {
			this.velocity.x = 200;
			this.facing = FlxObject.RIGHT;
		}

		if (FlxG.overlap(this, Reg.spikes)) {
			respawn();
		}

		Reg.map.collideWithLevel(this, touchingMap);


		this.velocity.y += 10;
		if (FlxG.keys.pressed.W && this.isTouching(FlxObject.FLOOR)) {
			this.velocity.y = -350;
		}

		if (FlxG.keys.justPressed.R) {
			reloadGraphic();
		}

#if debug
		if (this.menuVisible) {
			updateDebuggingMenu();
		}

		if (FlxG.mouse.justPressed){
			if (this.overlapsPoint(FlxG.mouse)) {
				showDebuggingMenu();
			} else if (!this.debuggingMenu.overlapsPoint(FlxG.mouse)) {
				hideDebuggingMenu();
			}
		}
#end
		// this.acceleration.y = 100;
	}
}
