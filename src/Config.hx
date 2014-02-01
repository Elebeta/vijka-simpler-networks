typedef Config = {
	var baseDir:Null<String>;
	var nodeTolerance:Float;
	var defaultVehicle:Int;
	var vijka:VijkaIOFiles;
	var edit:EditIOFiles;
	var nodeGen:NodeGenerationSettings;
	var linkGen:LinkGenerationSettings;
}

typedef NodeGenerationSettings = {
	var minId:Int;
	var maxId:Int;
}

typedef LinkGenerationSettings = {
	var minId:Int;
	var maxId:Int;
}

typedef VijkaIOFiles = {
	var nodeFile:String;
	var linkTypeFile:String;
	var linkSpeedFile:String;
	var linkFile:String;
	var linkAliasFile:Null<String>;
	var linkShapeFile:Null<String>;
}

typedef EditIOFiles = {
	var baseFile:String;
	var nodeEtt:Null<String>;
}
