package cratis.network;

class Link<A> {

	public
	var id(get,set):Int;
	var _id:Int;
	function get_id() return _id;
	function set_id(id) return _id = id;

	public
	var length(get,set):Float;

	public
	var dir(get,set):Float;

	public
	var from(default,null):Node;

	public
	var to(default,null):Node;

	public
	var data(get,set):A;

}
