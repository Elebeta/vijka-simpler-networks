package common;

class Point {

	public
	var x(default,null):Float;

	public
	var y(default,null):Float;

	public
	function new( x, y ) {
		this.x = x;
		this.y = y;
	}

	public
	function distanceTo( p:Point ) {
		return distance( this, p );
	}

	public
	function toString() {
		return '[ $x, $y ]';
	}

	public static
	function distance( a:Point, b:Point ) {
		return 1e-3*jonas.MathExtension.earth_distance_haversine( a.y, a.x, b.y, b.x );
	}

}