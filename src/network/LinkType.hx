package network;

class LinkType {

	public
	var id(default,null):Int;

	public
	var speeds(default,null):Map<Int,Float>;

	public
	function new( id ) {
		this.id = id;
		speeds = new Map();
	}

}
