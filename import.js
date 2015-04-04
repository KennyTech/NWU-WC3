var fs = require('fs'),
	path = require('path');

var COMPILE_PATH = 'compiled/';

function GenerateComment(str){
	return "\n/**************************************************************\n"+
	"		"+str.toUpperCase()+"\n"+
	"**************************************************************/\n";
}

/**
 * Replace all @find ocurrences in @str with @replace
 * @param  {String} str     String to parse
 * @param  {String} find    String to replace
 * @param  {String} replace String replacement
 * @return {String}
 */
function str_replace(str,find,replace){
	return str.replace(new RegExp(find, 'g'), replace);
}

/**
 * Generate cjass import text for a specific foolder.
 * @param {String} base foolder path inside NWU's foolder.
 * @param {String} data text containing the cjass code.
 */
function GenerateImportFile(base,data){
	var files = fs.readdirSync(base);
	console.log(files);
	files.forEach( function (filename){
		if(filename != '_include.j'){
			var fullpath = base+'/'+filename;
			var stats = fs.lstatSync(fullpath);
			console.log(fullpath);
			if (stats.isDirectory()) {
				data += GenerateComment(filename);
				data += GenerateImportFile(fullpath,"");
			} else {
				data += 'include "'+str_replace(fullpath,"/","//")+'"\n';
			}
		}
	});
	return data;
}

function compileSingle(base){
	var folder_path = 'src/'+base; // WHICH PROCCESS?

	if(!fs.existsSync(folder_path)){
		console.error("Path ./src/"+base+" doesn't exists");
	} else {
		var data = GenerateImportFile(folder_path,"");
		fs.writeFileSync(COMPILE_PATH+base+'.j',data);
	}
}

function compileMultiple(){
	var dirs = fs.readdirSync('src');
	dirs.forEach( function(dirname){
		if(fs.lstatSync('src/'+dirname).isDirectory()){
			compileSingle(dirname);
		}
	});
}

/******************************************************************
	MAIN
*******************************************************************/

function main(){
	compileMultiple();
}

main();