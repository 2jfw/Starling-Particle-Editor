/**
 *	Copyright (c) 2014 Devon O. Wolfgang
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */


package com.onebyonedesign.particleeditor
{
	import flash.display.BitmapData;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;


	/**
	 * The Starling particle system view
	 * @author Devon O.
	 */
	public class ParticleView extends Sprite implements SettingsListener
	{

		[Embed(source="../../../../assets/fire_particle.png")]
		public static const DEFAULT_PARTICLE : Class;

		[Embed(source="../../../../assets/blob.png")]
		private const BLOB : Class;

		[Embed(source="../../../../assets/star.png")]
		private const STAR : Class;

		[Embed(source="../../../../assets/heart.png")]
		private const HEART : Class;

		public static var CIRCLE_DATA : BitmapData;
		public static var STAR_DATA : BitmapData;
		public static var BLOB_DATA : BitmapData;
		public static var CUSTOM_DATA : BitmapData;
		public static var SELECTED_DATA : BitmapData;
		public static var HEART_DATA : BitmapData;

		/** the particle system */
		private var mParticleSystem : PDParticleSystem;

		/** Particle texture */
		private var mTexture : Texture;

		/** Settings */
		private var mSettings : SettingsModel;

		/** Particle Config */
		private var mParticleConfig : ParticleConfiguration;


		public function ParticleView()
		{
			CIRCLE_DATA = new DEFAULT_PARTICLE().bitmapData;
			STAR_DATA   = new STAR().bitmapData;
			BLOB_DATA   = new BLOB().bitmapData;
			HEART_DATA  = new HEART().bitmapData;
			CUSTOM_DATA = new BitmapData(64,
			                             64,
			                             true,
			                             0x00000000);

			SELECTED_DATA = CIRCLE_DATA;
		}


		/** Set the Settings Model */
		public function set settings(value : SettingsModel) : void
		{
			mSettings = value;
			mSettings.addListener(this);
		}


		/** Set the bitmap data for the particle system particle */
		public function set particleData(value : BitmapData) : void
		{
			SELECTED_DATA = value;
			recreateSystem();
		}


		/** Set the particle system config */
		public function set particleConfig(value : ParticleConfiguration) : void
		{
			this.mParticleConfig = value;
			init(mParticleConfig.xml);
		}


		/** get the particle system particle bitmap data */
		public function get particleData() : BitmapData
		{
			return SELECTED_DATA;
		}


		/* INTERFACE com.onebyonedesign.particleeditor.SettingsListener */

		public function updateXPosVariance(value : Number) : void
		{
			mParticleSystem.emitterXVariance = value;
		}


		public function updateYPosVariance(value : Number) : void
		{
			mParticleSystem.emitterYVariance = value;
		}


		// This function seems to be obsolete
		//		public function updateMaxParticles(value : Number) : void
		//		{
		//			mParticleSystem.mMaxNumParticles = value;
		//			mParticleSystem.emissionRate     = mParticleSystem.mMaxNumParticles / mParticleSystem.mLifespan;
		//		}


		public function updateLifeSpan(value : Number) : void
		{
			mParticleSystem.lifespan = value;
		}


		public function updateLifeSpanVariance(value : Number) : void
		{
			mParticleSystem.lifespanVariance = value;
		}


		public function updateStartSize(value : Number) : void
		{
			mParticleSystem.startSize = value;
		}


		public function updateStartSizeVariance(value : Number) : void
		{
			mParticleSystem.startSizeVariance = value;
		}


		public function updateFinishSize(value : Number) : void
		{
			mParticleSystem.endSize = value;
		}


		public function updateFinishSizeVariance(value : Number) : void
		{
			mParticleSystem.endSizeVariance = value;
		}


		public function updateEmitAngle(value : Number) : void
		{
			mParticleSystem.emitAngle = value * Math.PI / 180;
		}


		public function updateEmitAngleVariance(value : Number) : void
		{
			mParticleSystem.emitAngleVariance = value * Math.PI / 180;
		}


		public function updateStartRotation(value : Number) : void
		{
			mParticleSystem.startRotation = value * Math.PI / 180;
		}


		public function updateStartRotationVariance(value : Number) : void
		{
			mParticleSystem.startRotationVariance = value * Math.PI / 180;
		}


		public function updateEndRotation(value : Number) : void
		{
			mParticleSystem.endRotation = value * Math.PI / 180;
		}


		public function updateEndRotationVariance(value : Number) : void
		{
			mParticleSystem.endRotationVariance = value * Math.PI / 180;
		}


		public function updateSpeed(value : Number) : void
		{
			mParticleSystem.speed = value;
		}


		public function updateSpeedVariance(value : Number) : void
		{
			mParticleSystem.speedVariance = value;
		}


		public function updateGravityX(value : Number) : void
		{
			mParticleSystem.gravityX = value;
		}


		public function updateGravityY(value : Number) : void
		{
			mParticleSystem.gravityY = value;
		}


		public function updateTanAcceleration(value : Number) : void
		{
			mParticleSystem.tangentialAcceleration = value;
		}


		public function updateTanAccelerationVariance(value : Number) : void
		{
			mParticleSystem.tangentialAccelerationVariance = value;
		}


		public function updateRadialAcceleration(value : Number) : void
		{
			mParticleSystem.radialAcceleration = value;
		}


		public function updateRadialAccelerationVariance(value : Number) : void
		{
			mParticleSystem.radialAccelerationVariance = value;
		}


		public function updateEmitterType(value : int) : void
		{
			mParticleSystem.emitterType = value;
		}


		public function updateMaxRadius(value : Number) : void
		{
			mParticleSystem.maxRadius = value;
		}


		public function updateMaxRadiusVariance(value : Number) : void
		{
			mParticleSystem.maxRadiusVariance = value;
		}


		public function updateMinRadius(value : Number) : void
		{
			mParticleSystem.minRadius = value;
		}


		public function updateMinRadiusVariance(value : Number) : void
		{
			mParticleSystem.minRadiusVariance = value;
		}


		public function updateDegreesPerSecond(value : Number) : void
		{
			mParticleSystem.rotatePerSecond = value * Math.PI / 180;
		}


		public function updateDegreesPerSecondVariance(value : Number) : void
		{
			mParticleSystem.rotatePerSecondVariance = value * Math.PI / 180;
		}


		public function updateStartRed(value : Number) : void
		{
			mParticleSystem.startColor.red = value;
		}


		public function updateStartGreen(value : Number) : void
		{
			mParticleSystem.startColor.green = value;
		}


		public function updateStartBlue(value : Number) : void
		{
			mParticleSystem.startColor.blue = value;
		}


		public function updateStartAlpha(value : Number) : void
		{
			mParticleSystem.startColor.alpha = value;
		}


		public function updateFinishRed(value : Number) : void
		{
			mParticleSystem.endColor.red = value;
		}


		public function updateFinishGreen(value : Number) : void
		{
			mParticleSystem.endColor.green = value;
		}


		public function updateFinishBlue(value : Number) : void
		{
			mParticleSystem.endColor.blue = value;
		}


		public function updateFinishAlpha(value : Number) : void
		{
			mParticleSystem.endColor.alpha = value;
		}


		public function updateStartRedVariance(value : Number) : void
		{
			mParticleSystem.startColorVariance.red = value;
		}


		public function updateStartGreenVariance(value : Number) : void
		{
			mParticleSystem.startColorVariance.green = value;
		}


		public function updateStartBlueVariance(value : Number) : void
		{
			mParticleSystem.startColorVariance.blue = value;
		}


		public function updateStartAlphaVariance(value : Number) : void
		{
			mParticleSystem.startColorVariance.alpha = value;
		}


		public function updateFinishRedVariance(value : Number) : void
		{
			mParticleSystem.endColorVariance.red = value;
		}


		public function updateFinishGreenVariance(value : Number) : void
		{
			mParticleSystem.endColorVariance.green = value;
		}


		public function updateFinishBlueVariance(value : Number) : void
		{
			mParticleSystem.endColorVariance.blue = value;
		}


		public function updateFinishAlphaVariance(value : Number) : void
		{
			mParticleSystem.endColorVariance.alpha = value;
		}


		public function updateSourceBlend(value : uint) : void
		{
			recreateSystem();
		}


		public function updateDestinationBlend(value : uint) : void
		{
			recreateSystem();
		}


		/** Initialize the particle system */
		private function init(cfg : XML) : void
		{
			mTexture                 = Texture.fromBitmapData(SELECTED_DATA);
			mParticleSystem          = new PDParticleSystem(cfg,
			                                                mTexture);
			mParticleSystem.emitterX = 200;
			mParticleSystem.emitterY = 300;
			addChild(mParticleSystem);

			startSystem();
		}


		/** Start the particle system */
		private function startSystem() : void
		{
			stage.addEventListener(TouchEvent.TOUCH,
			                       onTouch);
			Starling.juggler.add(mParticleSystem);
			mParticleSystem.start();
		}


		/** Move the particle system with mouse click and drag */
		private function onTouch(event : TouchEvent) : void
		{
			var touch : Touch = event.getTouch(stage);
			if (touch && touch.phase != TouchPhase.HOVER)
			{
				if (touch.globalX <= 400 && touch.globalY <= 500)
				{
					mParticleSystem.emitterX = touch.globalX;
					mParticleSystem.emitterY = touch.globalY;
				}
			}
		}


		/** destroy then recreate particle system from updated config */
		private function recreateSystem() : void
		{
			var ex : Number = mParticleSystem.emitterX;
			var ey : Number = mParticleSystem.emitterY;
			mParticleSystem.stop();
			Starling.juggler.remove(mParticleSystem);
			removeChild(mParticleSystem);
			mParticleSystem.dispose();

			mTexture.dispose();

			mTexture                 = Texture.fromBitmapData(SELECTED_DATA);
			mParticleSystem          = new PDParticleSystem(mParticleConfig.xml,
			                                                mTexture);
			mParticleSystem.emitterX = ex;
			mParticleSystem.emitterY = ey;
			mParticleSystem.start();
			Starling.juggler.add(mParticleSystem);
			addChild(mParticleSystem);
		}
	}

}