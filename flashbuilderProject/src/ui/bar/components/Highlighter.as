package ui.bar.components
{
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	/** Underlying class for ui elemnts that have certain mouse interactions.
	 * creates a gradiante box that appears and disappears based on mouse interaction
	 */
	public class Highlighter extends MovieClip
	{
		//==============================================
		// Declarations
		//==============================================
		protected var highlight:Sprite;
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function Highlighter() 
		{			
			drawHighlight();		
			buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		//==============================================
		// Protected Methods
		//==============================================
		/** draws the radial gradiant box 
		 * @return void
		 */
		protected function drawHighlight():void 
		{
			highlight = new Sprite();
			highlight.mouseEnabled = false;
			addChild(highlight);
			highlight.visible = false;
			
			// Try to position the highlight automatically based on contents size
			highlight.x = width / 2;
			highlight.y = height / 2;
			
			var _myMatrix:Matrix = new Matrix();
			_myMatrix.createGradientBox(38, 38, 0, -19, -19);			
			var _colors:Array = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
			var _alphas:Array = [.8, .18, 0];
			var _ratios:Array = [40, 170, 245];
			highlight.graphics.beginGradientFill(GradientType.RADIAL, _colors, _alphas, _ratios, _myMatrix);
			highlight.graphics.drawRect(-19, -19, 38, 38);
		}
		
		/** on mouse roll over handler
		 * @param e	MouseEvent
		 * @return void
		 */
		protected function onRollOver(e:MouseEvent):void 
		{ 
			highlight.visible = true; 
		}
		
		/** on mouse roll out handler
		* @param	 e		MouseEvent
		 * @return 	void
		*/
		protected function onRollOut(e:MouseEvent):void { 
			highlight.visible = false; 
		}
		
	}// Class
}