package game;

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

class GirlBot extends game.Interactable {
	private var isFollowingPlayer:Bool = false;
	private var conversations:Array<Array<String>>;

	public function new(x:Int, y:Int) {
		super(x, y);

		conversations = [ [ "1000 HER Someday my true love will come!"
		                  , "1000 YOU Yawn."
		                  ] 
		                  , 
						  [ "1000 HER Be careful!"
		                  ]
						 ];

		this.loadGraphic("images/cutenpc.png", true, false, 25, 25);
		this.animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8);

		Reg.girls.add(this);

		this.animation.play("idle");

		this.scaleBouncer = false;
		this.drag.y = 0;
	}

	public function triggerConversation(conversation:Array<String>) {
		var parts:Array<String> = conversation.splice(0, 1)[0].split(" ");
		trace(parts);
		var delay:Int = Std.parseInt(parts.splice(0, 1)[0]);
		var who:String = parts.splice(0, 1)[0];
		var content = parts.join(" ");
		var target:FlxSprite;

		trace(delay);

		if (who == "HER") {
			target = this;
		} else {
			target = Reg.player;
		}

		var text:game.FollowText = new game.FollowText(target, content);

		FlxG.state.add(text);
		haxe.Timer.delay(function() {
			if (conversation.length > 0) {
				triggerConversation(conversation); // was spliced before.
			}
			text.removeText();
		}, 1000);
	}

	public override function update() {
		super.update();

		trace(this.velocity.y);

		if (!isFollowingPlayer) {
			this.velocity.y += 50;
		}
		this.velocity.y += 10;
		Reg.map.collideWithLevel(this);

		if (this.isTouching(flixel.FlxObject.FLOOR) && game.Interactable.getInteractor() == this && !isFollowingPlayer) {
			this.velocity.y = -500;
		}

		if (isFollowingPlayer) {
			var sign:Int = Reg.player.x - this.x > 0 ? 1 : -1;

			this.velocity.x = sign * 100;

			// attempt to jump if they did.
			if (this.y - Reg.player.y > 100 && this.isTouching(flixel.FlxObject.FLOOR)) {
				this.velocity.y = -350;
			}
		}
	}

	public override function actionString():String {
		if (isFollowingPlayer) {
			return "Z to be shy (Note: This does nothing.)";
		} else {
			return "Z to talk";
		}
	}

	public override function performAction():Void {
		if (isFollowingPlayer) {
			return;
		}
		var dialog = new game.DialogBox(["GIRL: Hello!"]);
		FlxG.state.add(dialog);

		isFollowingPlayer = true;
		this.showBouncer = false;

		dialog.addDoneCB(function() {
			this.triggerConversation(["1000 HER Hello!", "1000 YOU test"]);
		});
	}
}