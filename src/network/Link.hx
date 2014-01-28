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

	public
	var length(get,never):Int;
	function get_length() return inflections.length;

	var inflections:Array<Point>;

	public
	function new( inflections:Array<Point> ) {
		this.inflections = inflections;
	}

	public
	function add( point:Point ) {
		inflections.push( point );
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
		var old = inflections;
		inflections = [];
		for ( i in 0...old.length )
			if ( i != pos )
				inflections.push( old[i] );
		return pos >= 0 && pos < old.length;
	}

	public
	function clear() {
		inflections = [];
	}

	public
	function array() {
		return inflections.copy();
	}

	public
	function iterator() {
		return inflections.iterator();
	}

}

class AliasCollection {

	public
	var length(get,never):Int;
	function get_length() return aliases.length;

	var aliases:Array<String>;

	public
	function new() {
		aliases = [];
	}

	public
	function add( alias ) {
		if ( aliases.indexOf( alias ) == -1 )
			aliases.push( alias );
	}

	public
	function remove( alias ):Bool {
		return aliases.remove( alias );
	}

	public
	function has( alias ):Bool {
		return aliases.indexOf( alias ) > 0;
	}

	public
	function clear() {
		aliases = [];
	}

	public
	function join( sep:String ) {
		return aliases.join( sep );
	}

	public
	function iterator() {
		return aliases.iterator();
	}

}
