package io;

import haxe.Json;
import network.Link;
import network.Network;
import network.Node;
import SimpleGeography;
import Sys.println;
using Lambda;

class EditIO {

// EditIO: READING

	public static
	function read( config:Config ):Network {
		println( "Reading an editing network..." );
		var network = new Network( config.nodeTolerance );
		if ( config.edit.nodeEtt != null ) {
			// TODO
			println( "Reading an editing network... Restoring nodes" );
		}
		println( "Reading an editing network... Reading links" );
		readLinks( network, config.baseDir+config.edit.baseFile );
		println( "Reading an editing network... Done" );
		return network;
	}

	public static
	function readLinks( network:Network, path:String ) {
		println( "Reading links... Fetching file content" );
		var text = File.getContent( path );
		println( "Reading links... Parsing JSON" );
		var json = Json.parse( text );
		println( "Reading links... Generating geography" );
		var set = SimpleGeography.fromGeoJson( json );
		println( "Reading links... Importing links" );
		set.features.iter( importLinkFeature.bind( network ) );
	}

	static
	function importLinkFeature( network:Network, feature:GeographyFeature ) {
		switch ( feature.geometry ) {
		case LineString( points ):

			var from = getOrAddNode( network, points[0] );
			var to = getOrAddNode( network, points[points.length-1] );

			var data:LinkFeatureProperties = feature.properties;

			// TODO validate data

			var inflections = points.slice( 1, points.length-2 ).map( cpoint );

			var link = new Link( from, to, data.id, data.length, data.type, data.toll, inflections );

			for ( alias in data.aliases.split( "," ) )
				link.aliases.add( alias );

			network.links.add( link );

		case all:
			throw 'Unexpected feature $all';
		}
	}

	static
	function getOrAddNode( network:Network, point:Point ) {
		var cp = cpoint( point );
		var node = network.nodes.getPoint( cp );
		while ( node == null ) {
			var id = Std.random( 1000000000 );
			if ( network.nodes.getId( id ) == null ) {
				// trace( "New node "+id );
				node = new Node( id, cp );
				network.nodes.add( node );
			}
		}
		return node;
	}

	static
	function cpoint( point:Point ):common.Point {
		return new common.Point( point.x, point.y );
	}

// EditIO: WRITING

	public static
	function write( network:Network, config:Config ) {
		println( "Writing the editing network..." );
		if ( config.edit.nodeEtt != null ) {
			println( "Writing the editing network... Nodes" );
			keepNodes( network, config.edit.nodeEtt );
		}
		println( "Writing the editing network... Links" );
		writeLinks( network, config.baseDir+config.edit.baseFile );
		println( "Writing the editing network... Done" );
	}

	public static
	function keepNodes( network:Network, path ) {
		// TODO
	}

	public static
	function writeLinks( network:Network, path:String ) {
		println( "Writing links... Generating geography objects" );
		var set = linkSet( network );
		println( "Writing links... Creating GeoJSON objects" );
		var json = SimpleGeography.toGeoJson( set );
		println( "Writing links... Stringifying GeoJSON" );
		var text = Json.stringify( json );
		println( "Writing links... Writing to file" );
		File.saveContent( path, text );
	}

	public static
	function linkSet( network:Network ):GeographySet {
		return { features:[ for ( link in network.links ) linkFeature( link ) ] };
	}

	static
	function linkFeature( link:Link ):GeographyFeature {
		return {
			geometry:linkGeometry( link ),
			properties:{
				id:link.id,
				length:link.extension,
				type:link.type,
				toll:link.toll,
				aliases:link.aliases.join( "," )
			}
		}
	}

	static
	function linkGeometry( link:Link ) {
		var points = [];
		points.push( sgpoint( link.from.point ) );
		points = points.concat( link.inflections.array().map( sgpoint ) );
		points.push( sgpoint( link.to.point ) );
		return LineString( points );
	}

	static
	function sgpoint( point:common.Point ):Point {
		return { x:point.x, y:point.y };
	}

	static
	function keepNode( node:Node ) {
		// TODO
	}

}

private
typedef LinkFeatureProperties = {
	var id:Int;
	var length:Float;
	var type:Int;
	var toll:Float;
	var aliases:String;
}
