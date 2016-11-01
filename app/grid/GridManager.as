package app.grid {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class GridManager extends MovieClip {
		public static const EVT_MOVING_CELL="MovingToNewCell";
		
		public var cntCol:uint;
		public var cntRow:uint;
		
		public var grid_width:uint;
		public var grid_height:uint;
		
		public var grid_x:uint;
		public var grid_y:uint;
		
		public var colX:uint = 0;
		public var rowY:uint = 0;
		public var col:uint = 0;
		public var row:uint = 0;
		public var curMoveCol = -1;
		public var curMoveRow = -1;
		public var prevMoveCol = -1;
		public var prevMoveRow = -1;
		
		public var me:Event;
		
		private var i:uint = 0;
		private var j:uint = 0;
		private var wi:uint = 0;
		private var wk:uint = 0;
		
		private var flWave:Boolean;
		
		private var mxCoords:Array; 
		public var mxWave:Array; 
		private var coords:Object; 
		
		public var mouseClip:MovieClip;

		public function GridManager(cntRowCell:uint = 5,cntColCell:uint = 5,gridW:uint = 10, gridH:uint = 10, gridX:uint = 0, gridY:uint = 0){
			// constructor code
			
			cntCol = cntColCell;
			cntRow = cntRowCell;
			
			grid_width = gridW;
			grid_height = gridH;
			
			grid_x = gridX;
			grid_y = gridY;
						
			mxCoords = new Array();
			for ( i = 0; i < cntRow; i++) {
				mxCoords[i] = new Array();
				for ( j = 0; j < cntCol; j++) {
					coords = new Object();
					coords.x = grid_x + j * grid_width + grid_width / 2;
					coords.y = grid_y + i * grid_height  + grid_height / 2;
					mxCoords[i][j] = coords;
					coords = null;
				}
			}
		}
		
		public function getCoords(i:uint){
			col = i % cntCol;
			row = (i - col) / cntCol;
			
			colX = mxCoords[row][col].x;
			rowY = mxCoords[row][col].y;
		}
		
		public function getIndexColRow(row:Number,col:Number):Number{
			return row*Number(cntCol) + col;
		}
		
		public function getCoordsColRow(row:uint,col:uint){
			colX = mxCoords[row][col].x;
			rowY = mxCoords[row][col].y;
		}
		
		public function getNumCellXY(cx,cy:uint):void {
			col = Math.floor((cx - grid_x) / grid_width);
			row = Math.floor((cy - grid_y) / grid_height);
		}
		/**
		 * Получает экранные координаты, соответствующие ячейкам сетки
		 * @param	cx - произвользная экранная координата X
		 * @param	cy - произвользная экранная координата Y
		 */
		public function getCoordsXY(cx,cy:uint):void {
			var flBorder:Boolean = (cx > grid_x) && (cx < (grid_x + grid_width * cntCol)) && ((cy > grid_y) && (cy < (grid_y + grid_height * cntRow)));
			if(flBorder){
				getNumCellXY(cx,cy);
			
				colX = mxCoords[row][col].x;
				rowY = mxCoords[row][col].y;
			}
		}
		
		public function drawCell():void {
			if(mouseClip!=null){
				var flBorder:Boolean = (stage.mouseX > grid_x) && (stage.mouseX < (grid_x + grid_width * cntCol)) && ((stage.mouseY > grid_y) && (stage.mouseY < (grid_y + grid_height * cntRow)));
				if (flBorder ) {
					;
					getNumCellXY(stage.mouseX,stage.mouseY);
					
					var drawCol = -1;
					var drawRow = -1;
					var flPut:Boolean = row!=drawRow || col!=drawCol; 
					if (flPut) {
							
						mouseClip.x = stage.mouseX - (stage.mouseX - grid_x) % grid_width + grid_width / 2;
						mouseClip.y = stage.mouseY - (stage.mouseY - grid_y) % grid_height + grid_height / 2;
					
						stage.addChild(mouseClip);
						
						drawCol = col;
						drawRow = row;
					}	
				}
			}
		}
		
		public function checkMoveToCell(cx,cy):void {
			getNumCellXY(cx,cy);
				
			var flBorder:Boolean = (cx > grid_x) && (cx < (grid_x + grid_width * cntCol)) && ((cy > grid_y) && (cy < (grid_y + grid_height * cntRow)));
			if (flBorder) {
					
				var flPut:Boolean = (this.row!=curMoveRow || this.col!=curMoveCol); 
					if (flPut) {
							
						prevMoveCol = curMoveCol;
						prevMoveRow = curMoveRow;
						
						curMoveCol = col;
						curMoveRow = row;
						
						me = new Event(EVT_MOVING_CELL,true);
						dispatchEvent(me);
						
						
					}	
				}
			
		}
		
		public function initWave(cntIter:uint):void {
			mxWave = new Array();
			for ( i = 0; i < cntRow; i++) {
				mxWave[i] = new Array();
				for ( j = 0; j < cntCol; j++) {
					mxWave[i][j] = 255;
				}
			}
			wi = 0;
			wk = cntIter;
			flWave = false;
		}
		
		public function getCoordsMinWave(ri,ci:uint):void {
			var min = 256;
			if (ri - 1 >= 0 && mxWave[ri - 1][ci] < min ){
				min = mxWave[ri - 1][ci];
				col = ci;
				row = ri - 1;
			}
			
			if (ri + 1 < cntRow && mxWave[ri + 1][ci] < min) {
				min = mxWave[ri + 1][ci];
				col = ci;
				row = ri + 1;
			}	
			
			if (ci - 1 >=0 && mxWave[ri][ci-1] < min) {
				min = mxWave[ri][ci - 1];
				col = ci - 1;
				row = ri;
			}	
			
			if (ci+1 < cntCol && mxWave[ri][ci+1] < min) {
				min = mxWave[ri][ci + 1];
				col = ci + 1;
				row = ri;
			}
			
			colX = mxCoords[row][col].x;
			rowY = mxCoords[row][col].y;
		}
		
		public function SeachPathWave():Boolean {
			var w;
			for ( i = 0; i < cntRow; i++) {
				for ( j = 0; j < cntCol; j++) {
					
					if (mxWave[i][j] == wi) {
						
						if(i - 1 >= 0){
							if (mxWave[i - 1][j] == 253) {
								flWave = true;
							} else if (mxWave[i - 1][j] == 254) {
								mxWave[i - 1][j] = wi + 1;
							}
						}	
						
						
						if (i + 1 < cntRow) {
							if (mxWave[i + 1][j] == 253) {
								flWave =  true;
							} else if (mxWave[i + 1][j] == 254) {
								mxWave[i + 1][j] = wi + 1;
							}
						}	
						
						if(j - 1 >= 0){
							if (mxWave[i][j-1] == 253) {
								flWave =  true;
							} else if (mxWave[i][j-1] == 254) {
								mxWave[i][j-1] = wi + 1;
							}
						}	
						
						if (j + 1 < cntCol) {
							if (mxWave[i][j+1] == 253) {
								flWave =  true;
							} else if (mxWave[i][j+1] == 254) {
								mxWave[i][j+1] = wi + 1;
							}
						}	
					}
				}
			}
			
			wi++;
			if (wi > wk) {
				flWave = false;
			}
			
			if(!flWave && wi <= wk) SeachPathWave();
			return flWave;
		}
		
		public function initMoving():void {
			curMoveCol = -1;
			curMoveRow = -1;
			
			prevMoveCol = -1;
			prevMoveRow = -1;
		}
		
		/*private function drawRect(event:MouseEvent):void {
			if (rectField.numChildren>0) {
				getNumCell();
				
				var flBorder:Boolean = (stage.mouseX > grid_x) && (stage.mouseX < (grid_x + grid_width * cntCol)) && ((stage.mouseY > grid_y) && (stage.mouseY < (grid_y + grid_height * cntRow)));
				if (flBorder) {
					
					//var flPut:Boolean = (mxField[row+1][col+1] >= 0) && (row!=drawRow || col!=drawCol); 
					//if (flPut) {
							
						fa.x = stage.mouseX - (stage.mouseX - GRID_X) % GRID_WIDTH +GRID_WIDTH / 2;
						fa.y = stage.mouseY - (stage.mouseY - GRID_Y) % GRID_HEIGHT + GRID_HEIGHT / 2;
					
						drawCol = col;
						drawRow = row;
					//}	
				}
			}	
		}*/

	}
	
}
