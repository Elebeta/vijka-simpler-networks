package network;

import common.Point;
import elebeta.ds.tree.Rj1Tree;

class Network {

	public
	var nodes(default,null):NodeCollection;

	public
	var links(default,null):LinkCollection;

	public
	function new( tol:Float ) {
		nodes = new NodeCollection( this, tol );
		links = new LinkCollection( this );
	}

}

class NodeCollection {

	public
	var tol(default,null):Float;

	var ididx:Map<Int,Node>;
	var geoidx:Rj1Tree<Node>;

	public
	function new( network, tol:Float ) {
		this.tol = tol;
		ididx = new Map();
		geoidx = new Rj1Tree();
	}

	public
	function add( node:Node ) {
		if ( getId( node.id ) != null )
			throw 'Cannot add node, ${node.id} already used';
		if ( getPoint( node.point ) != null )
			throw 'Cannot add node, ${node.point} already used';
		ididx.set( node.id, node );
		geoidx.insertPoint( node.point.x, node.point.y, node );
	}

	public
	function remove( node:Node ):Bool {
		if ( ididx.remove( node.id ) ) {
			if ( geoidx.removePoint( node.point.x, node.point.y, node ) == 0  )
				throw 'Failed to remove node ${node.id} from geo index';
			return true;
		}
		return false;
	}

	public
	function getPoint( point:Point ):Null<Node> {
		var res = null;
		for ( node in geoidx.search( point.x-.5*tol, point.y-.5*tol, tol, tol ) )
			if ( dist( node.point, point ) < tol ) {
				if ( res != null )
					throw 'Multiple reuslts';
				res = node;
			}
		return res;
	}

	public
	function getId( id ):Null<Node> {
		return ididx.get( id );
	}

	public
	function searchByBounds( bounds ):Array<Node> {
		return [ for ( x in geoidx.search( bounds.xmin, bounds.ymin, bounds.width, bounds.height ) ) x ];
	}

	function dist( a:Point, b:Point ) {
		return Math.sqrt( (a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y) );
	}

}

class LinkCollection {

	var ididx:Map<Int,Link>;

	public
	function new( network ) {
		ididx = new Map();
	}

	public
	function add( link:Link ) {
		if ( getId( link.id ) != null )
			throw 'Cannot add link, ${link.id} already used';
		ididx.set( link.id, link );
	}

	public
	function remove( link:Link ) {
		return ididx.remove( link.id );
	}

	public
	function getId( id ):Null<Link> {
		return ididx.get( id );
	}

}
