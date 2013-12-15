package game;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;

import flixel.addons.ui.FlxInputText;
import flixel.util.FlxPoint;
import game.Interactable;

class HUD extends FlxObject {
	var zAction:FlxText;

	public function new() {
		super(0, 0);

		zAction = new FlxText(0, 0, 300, "Z: Do absolutely nothing.", 14);
		FlxG.state.add(zAction);
		zAction.scrollFactor.x = 0;
		zAction.scrollFactor.y = 0;
	}

	public override function update() {
		super.update();

		var selectedInteractor:game.Interactable = null;

		for (interactor in Reg.interactors.members) {
			var i:game.Interactable = cast(interactor, Interactable);
			if (FlxMath.distanceBetween(i, Reg.player) <= Interactable.VISIBLE_RANGE) {
				selectedInteractor = i;
				break;
			}
		}

		if (selectedInteractor != null) {
			zAction.text = selectedInteractor.actionString();
		} else {
			zAction.text = "Press z to do literally nothing.";
		}
	}
}