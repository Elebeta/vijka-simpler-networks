package io;

import sys.FileSystem;
import Sys.println;

class File {

	public static
	function read( path:String, binary:Bool ) {
		prepareToRead( path );
		return sys.io.File.read( path, binary );
	}

	public static
	function getContent( path:String ) {
		prepareToRead( path );
		return sys.io.File.getContent( path );
	}

	public static
	function write( path:String, binary:Bool ) {
		prepareToWrite( path );
		return sys.io.File.write( path, binary );
	}

	public static
	function saveContent( path:String, contents:String ) {
		prepareToWrite( path );
		sys.io.File.saveContent( path, contents );
	}

	static
	function prepareToRead( path:String ) {
		if ( !FileSystem.exists( path ) )
			throw "File \""+path+"\" does not exist";
		if ( FileSystem.isDirectory( path ) )
			throw "Expected a file but found a folder: \""+path+"\"";
	}

	static
	function prepareToWrite( path:String ) {
		if ( FileSystem.exists( path ) ) {
			if ( FileSystem.isDirectory( path ) )
				throw "Expected a file but found a folder: \""+path+"\"";
			println( "Replacing "+path );
		}
		else {
			try {
				var f = sys.io.File.write( path, false );
				f.close();
			}
			catch ( e:Dynamic ) {
				println( "Cannot write to "+path );
			}
		}
	}

}
