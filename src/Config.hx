typedef Config = {

	var baseDir:Null<String>;
	var vijka:VijkaIOFiles;
	var edit:EditIOFiles;
	var nodeTolerance:Float;

}

typedef VijkaIOFiles = {
	var nodeFile:String;
	var linkFile:String;
	var linkAliasFile:Null<String>;
	var linkShapeFile:Null<String>;
}

typedef EditIOFiles = {
	var baseFile:String;
	var nodeEtt:Null<String>;
}
