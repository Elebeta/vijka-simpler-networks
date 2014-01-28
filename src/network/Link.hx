package network;

import common.Point;

class Link {

	public
	var from(default,null):Node;

	public
	var to(default,null):Node;

	public
	var id:Int;

	public
	var extension:Float;

	public
	var type:Int;

	public
	var toll:Float;

	public
	var inflections(default,null):InflectionCollection;

	public
	var aliases(default,null):AliasCollection;

	public
	function new( from:Node, to:Node, id, extension, type, toll, ?inflections:Array<Point> ) {
		this.from = from;
		this.to = to;
		this.id = id;
		this.extension = extension;
		this.type = type;
		this.toll = toll;
		this.inflections = new InflectionCollection( inflections != null ? inflections : [] );
		this.aliases = new AliasCollection();
	}

}

class InflectionCollection {

	var inflections:Array<Point>;

	public
	function new( inflections:Array<Point> ) {
		this.inflections = inflections;
	}

	public
	function get( pos:Int ) {
		return inflections[pos];
	}

	public
	function set( pos:Int, point:Point ) {
		return inflections[pos] = point;
	}

	public
	function remove( pos:Int ) {
		inflections.remove( inflections[pos] );
	}

}

class AliasCollection {

	var aliases:Array<String>;

	public
	function new() {

	}

	public
	function add( alias:String ) {

	}

	public
	function remove( alias:String ) {

	}

	public
	function clear() {
		aliases = [];
	}

}
