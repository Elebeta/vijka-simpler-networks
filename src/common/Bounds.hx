package common;

class Bounds {

	public
	var xmin(default,null):Float;

	public
	var xmax(default,null):Float;

	public
	var ymin(default,null):Float;

	public
	var ymax(default,null):Float;

	public
	var width(get,never):Float;
	function get_width() return xmax-xmin;

	public
	var heigth(get,never):Float;
	function get_height() return ymax-ymin;

	public
	function new( xmin, xmax, ymin, ymax ) {
		this.xmin = xmin;
		this.xmax = xmax;
		this.ymin = ymin;
		this.ymax = ymax;
	}

}