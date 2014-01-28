import haxe.Json;
import io.VijkaIO;
import io.EditIO;
import network.Network;
import sys.io.File;

class Edit {

	static
	function main() {
		var args = Sys.args();
		if ( args.length != 2 )
			throw "Usage: edit <config_file> edit|save";

		var config:Config = Json.parse( File.getContent( args[0] ) );
		if ( config.baseDir == null || config.baseDir == "./" )
			config.baseDir = getDir( args[0] );

		switch ( args[1] ) {
		case "edit":

			var network = VijkaIO.read( config );
			EditIO.write( network, config );

		case "save":

			var network = EditIO.read( config );
			VijkaIO.write( network, config );

		case all:
			throw 'Unsupported command $all';
		}
	}

	static
	function getDir( path:String ) {
		if ( Sys.systemName() != "Linux" )
			throw 'Missing `getDir` implementation for ${Sys.systemName()}';
		var lastSlash = path.lastIndexOf( "/" );
		if ( lastSlash == -1 )
			return "./";
		else
			return path.substr( 0, lastSlash+1 );
	}

}
