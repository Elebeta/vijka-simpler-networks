package io;

import common.Point;
import format.ett.Data.Encoding in ETTEncoding;
import format.ett.Data.Field in ETTField;
import format.ett.Reader;
import format.ett.Writer;
import haxe.io.Eof;
import network.Link;
import network.Network;
import network.Node;
import Sys.print;
import Sys.println;

class VijkaIO {

// VijkaIO: READING

	public static
	function read( config:Config ):Network {
		println( "Reading a Vijka Network..." );
		var network = new Network( config.nodeTolerance );
		println( "Reading a Vijka Network... Nodes" );
		readNodes( network, config.baseDir+config.vijka.nodeFile );
		println( "Reading a Vijka Network... Links" );
		readLinks( network, config.baseDir+config.vijka.linkFile );
		if ( config.vijka.linkAliasFile != null ) {
			println( "Reading a Vijka Network... Link aliases" );
			readAliases( network, config.baseDir+config.vijka.linkAliasFile );
		}
		if ( config.vijka.linkShapeFile != null ) {
			println( "Reading a Vijka Network... Link shapes" );
			readShapes( network, config.baseDir+config.vijka.linkShapeFile );
		}
		println( "Reading a Vijka Network... Done!     " );
		return network;
	}

	public static
	function readNodes( network:Network, path:String ) {
		var einp = readEtt( path );
		while ( true ) {
			var vijkaNode = try { einp.fastReadRecord( elebeta.ett.vijka.Node.makeEmpty() ); }
			                catch ( e:Eof ) { null; };
			if ( vijkaNode == null ) break;
			var node = makeNode( network, vijkaNode );
			network.nodes.add( node );
		}
		einp.close();
	}

	static
	function makeNode( network, vijkaNode:elebeta.ett.vijka.Node ) {
		return new Node( vijkaNode.id, makePoint( vijkaNode.point ) );
	}

	static
	function makePoint( vijkaPoint ) {
		return new Point( vijkaPoint.x, vijkaPoint.y );
	}

	public static
	function readLinks( network:Network, path:String ) {
		var einp = readEtt( path );
		while ( true ) {
			var vijkaLink = try { einp.fastReadRecord( elebeta.ett.vijka.Link.makeEmpty() ); }
			                catch ( e:Eof ) { null; };
			if ( vijkaLink == null ) break;
			var link = makeLink( network, vijkaLink );
			network.links.add( link );
		}
		einp.close();
	}

	static
	function makeLink( network:Network, vijkaLink:elebeta.ett.vijka.Link ) {
		var from = network.nodes.getId( vijkaLink.startNodeId );
		if ( from == null )
			throw 'Missing from node ${vijkaLink.startNodeId} for link ${vijkaLink.id}';
		var to = network.nodes.getId( vijkaLink.finishNodeId );
		if ( to == null )
			throw 'Missing to node ${vijkaLink.finishNodeId} for link ${vijkaLink.id}';
		return new Link( from, to, vijkaLink.id, vijkaLink.extension, vijkaLink.typeId, vijkaLink.toll );
	}

	public static
	function readShapes( network:Network, path:String ) {
		var einp = readEtt( path );
		while ( true ) {
			var vijkaShape = try { einp.fastReadRecord( elebeta.ett.vijka.LinkShape.makeEmpty() ); }
			                catch ( e:Eof ) { null; };
			if ( vijkaShape == null ) break;
			var link = network.links.getId( vijkaShape.linkId );
			importShape( link, vijkaShape );
		}
		einp.close();
	}

	static
	function importShape( link:Link, vijkaShape:elebeta.ett.vijka.LinkShape ) {
		link.inflections.clear();
		for ( vp in vijkaShape.shape.array() ) {
			link.inflections.add( makePoint( vp ) );
		}
	}

	public static
	function readAliases( network:Network, path:String ) {
		var einp = readEtt( path );
		while ( true ) {
			var vijkaAlias = try { einp.fastReadRecord( elebeta.ett.vijka.LinkAlias.makeEmpty() ); }
			                catch ( e:Eof ) { null; };
			if ( vijkaAlias == null ) break;
			var link = network.links.getId( vijkaAlias.linkId );
			importAlias( link, vijkaAlias );
		}
		einp.close();
	}

	static
	function importAlias( link:Link, vijkaAlias:elebeta.ett.vijka.LinkAlias ) {
		link.aliases.add( vijkaAlias.name );
	}

	static
	function readEtt( path:String ) {
		return new ETTReader( File.read( path, true ) );
	}


// VijkaIO: WRITING

	public static
	function write( network:Network, config:Config ) {
		println( "Writing the Vijka Network..." );
		println( "Writing the Vijka Network... Nodes" );
		writeNodes( network, config.baseDir+config.vijka.nodeFile );
		println( "Writing the Vijka Network... Links" );
		writeLinks( network, config.baseDir+config.vijka.linkFile );
		if ( config.vijka.linkAliasFile != null ) {
			println( "Writing the Vijka Network... Link aliases" );
			writeAliases( network, config.baseDir+config.vijka.linkAliasFile );
		}
		if ( config.vijka.linkShapeFile != null ) {
			println( "Writing the Vijka Network... Link shapes" );
			writeShapes( network, config.baseDir+config.vijka.linkShapeFile );
		}
		println( "Writing the Vijka Network... Done" );
	}

	public static
	function writeNodes( network:Network, path:String ) {
		var nodes:Iterable<elebeta.ett.vijka.Node> = [ for ( node in network.nodes ) makeVijkaNode( node ) ];
		return genericEtt( path, nodes, elebeta.ett.vijka.Node, "Writing nodes", "No nodes" );
	}

	static
	function makeVijkaNode( node:Node ):elebeta.ett.vijka.Node {
		return elebeta.ett.vijka.Node.make( node.id, makeVijkaPoint( node.point ) );
	}

	static
	function makeVijkaPoint( point:Point ):format.ett.Geometry.Point {
		return new format.ett.Geometry.Point( point.x, point.y );
	}

	public static
	function writeLinks( network:Network, path:String ) {
		var links:Iterable<elebeta.ett.vijka.Link> = [ for ( link in network.links ) makeVijkaLink( link ) ];
		return genericEtt( path, links, elebeta.ett.vijka.Link, "Writing links", "No links" );
	}

	static
	function makeVijkaLink( link:Link ):elebeta.ett.vijka.Link {
		return elebeta.ett.vijka.Link.make( link.id, link.from.id, link.to.id, link.extension, link.type, link.toll );
	}

	public static
	function writeAliases( network:Network, path:String ) {
		var aliases = [];
		for ( link in network.links )
			if ( link.aliases.length > 0 )
				for ( alias in link.aliases )
					aliases.push( makeVijkaAlias( link, alias ) );
		return genericEtt( path, aliases, elebeta.ett.vijka.LinkAlias, "Writing aliases", "No aliases" );
	}

	static
	function makeVijkaAlias( link:Link, alias:String ) {
		return elebeta.ett.vijka.LinkAlias.make( alias, link.id );
	}

	public static
	function writeShapes( network:Network, path:String ) {
		var shapes:Iterable<elebeta.ett.vijka.LinkShape> = [ for ( link in network.links ) makeVijkaShape( link ) ];
		return genericEtt( path, shapes, elebeta.ett.vijka.LinkShape, "Writing shapes", "No shapes" );
	}

	static
	function makeVijkaShape( link:Link ) {
		var ls = [];
		ls.push( makeVijkaPoint( link.from.point ) );
		ls = ls.concat( link.inflections.array().map( makeVijkaPoint ) );
		ls.push( makeVijkaPoint( link.to.point ) );
		return elebeta.ett.vijka.LinkShape.make( link.id, new format.ett.Geometry.LineString( ls ) );
	}

	static
	function genericEtt( path:String, table:Iterable<Dynamic>, cl:Dynamic
	, status:Null<String>, notAvailable:Null<String> ) {
		if ( status != null ) println( status );
		if ( table == null )
			throw notAvailable != null ? notAvailable : "Table not available";
		var eout = writeEtt( cl, cl.ettFields(), path );
		for ( r in table )
			eout.write( r );
		eout.close();
	}

	static
	function writeEtt( cl:Class<Dynamic>, fields:Array<ETTField>, outputPath:String ):ETTWriter {
		var fout = File.write( outputPath, true );
		var finfo = new format.ett.Data.FileInfo( "\n", ETTEncoding.UTF8, "\t", "\""
		, Type.getClassName( cl ), fields );
		var w = new ETTWriter( finfo );
		w.prepare( fout );
		return w;
	}

}
