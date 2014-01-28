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

// EditIO: WRITING

	public static
	function write( network:Network, config:Config ) {
		println( "Writing the editing network..." );
		println( "Writing the editing network... Generating geography objects" );
		var set = writeLinks( network );
		println( "Writing the editing network... Creating GeoJSON objects" );
		var json = SimpleGeography.toGeoJson( set );
		println( "Writing the editing network... Stringifying GeoJSON" );
		var str = Json.stringify( json );
		println( "Writing the editing network... Writing to file" );
		File.saveContent( config.baseDir+config.edit.baseFile, str );
		println( "Writing the editing network... Done" );
	}

	public static
	function writeLinks( network:Network ):GeographySet {
		return { features:[ for ( link in network.links ) writeLink( link ) ] };
	}

	static
	function writeLink( link:Link ):GeographyFeature {
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

	public static
	function keepNode( node:Node ) {
		// TODO
	}

}
