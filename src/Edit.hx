import haxe.Json;
import io.VijkaIO;
import network.Network;
import sys.io.File;

class Edit {

	static
	function main() {
		var args = Sys.args();
		if ( args.length != 2 )
			throw "Usage: edit <config_file> edit|save";

		var config:Config = Json.parse( File.getContent( args[0] ) );
		Sys.setCwd( getDir( args[0] ) );

		switch ( args[1] ) {
		case "edit":

			var network = VijkaIO.read( config );
			// TODO save as editing network

		case "save":

			// TODO read as editing netwokr
			// TODO save as Vijka network

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
			return ".";
		else
			return path.substr( 0, lastSlash );
	}

}
