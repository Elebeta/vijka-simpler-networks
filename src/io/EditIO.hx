package io;

import haxe.Json;
import network.Link;
import network.Network;
import network.Node;
import SimpleGeography;
import Sys.println;

class EditIO {

// EditIO: READING

	public static
	function read( config:Config ):Network {
		// TODO
		return null;
	}

	public static
	function readLinks( network:Network, path:String ) {

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
		var str = Json.stringify( json );
		println( "Writing links... Writing to file" );
		File.saveContent( path, str );
	}

	public static
	function linkSet( network:Network ):GeographySet {
		return { features:[ for ( link in network.links ) linkFeature( link ) ] };
	}

	static
	function linkFeature( link:Link ):GeographyFeature {
		return {
			geometry:linkGeometry( link ),
			properties: {
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
