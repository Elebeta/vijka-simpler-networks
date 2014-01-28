package network;

import common.Point;

class Node {

	public
	var id:Int;

	public
	var point(default,null):Point;

	public
	function new( id, point ) {
		this.id = id;
		this.point = point;
	}

}
