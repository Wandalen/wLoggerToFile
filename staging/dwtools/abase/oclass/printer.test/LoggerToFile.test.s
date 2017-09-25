( function _LoggerToFile_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../printer/LoggerToFile.s' );

  _.include( 'wTesting' );

}

var _ = wTools;
var File = _.FileProvider.HardDrive();
var Parent = wTools.Testing;
var Self = {};

//

var _deleteFile = function( pathFile )
{
  try
  {
    File.fileDeleteAct
    ({
      pathFile : pathFile,
      sync : 1
    });
  } catch( err) {}
}

//

var _readFromFile = function( pathFile )
{
  return File.fileReadAct
  ({
    pathFile : pathFile,
    sync : 1
  });
}

var toFile = function( test )
{
  File.directoryMake({ pathFile : __dirname + '/tmp', sync : 1 });

  test.description = 'case1';
  _deleteFile( __dirname +'/tmp/out.txt' );
  var fl = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger();
  l.outputTo( fl, { combining : 'rewrite' } );
  l.log( '123' );
  var got = _readFromFile( __dirname +'/tmp/out.txt' );
  var expected = '123\n';
  test.identical( got, expected );

  test.description = 'case2';
  _deleteFile( __dirname +'/tmp/out.txt' );
  var fl = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger();
  l.outputTo( fl, { combining : 'rewrite' } );
  l._dprefix = '*';
  l.up( 2 );
  l.log( 'msg' );
  var got = _readFromFile( __dirname +'/tmp/out.txt' );
  var expected = '**msg\n';
  test.identical( got, expected );
}

//

var chaining = function( test )
{
  var _onWrite = function( args ) { got.push( args[ 0 ] ) };

  test.description = 'case1: Logger->LoggerToFile';
  var loggerToFile = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger({ output : loggerToFile });
  _deleteFile( __dirname +'/tmp/out.txt' );
  l.log( 'msg' );
  var got = _readFromFile( __dirname +'/tmp/out.txt' );
  var expected = 'msg\n';
  test.identical( got, expected );

  test.description = 'case2: Logger->LoggerToFile->Logger';
  var got = [];
  var loggerToFile = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger({ output : loggerToFile });
  var l2 = new wLogger({ output : null, onWrite : _onWrite });
  loggerToFile.outputTo( l2, { combining : 'rewrite' } );
  l.log( 'msg' );
  var expected = [ 'msg' ]
  test.identical( got, expected );

  test.description = 'case3: LoggerToFile->LoggerToFile';
  var path1 = __dirname +'/tmp/out.txt';
  var path2 = __dirname +'/tmp/out2.txt';
  _deleteFile( path1 );
  _deleteFile( path2 );
  var loggerToFile = new wLoggerToFile({ outputPath : path1 });
  var loggerToFile2 = new wLoggerToFile({ outputPath : path2 });
  loggerToFile.outputTo( loggerToFile2, { combining : 'rewrite' } );
  loggerToFile.log( 'msg' );
  var got = [ _readFromFile( path1 ), _readFromFile( path2 ) ];
  var expected = [ 'msg\n', 'msg\n' ]
  test.identical( got, expected );

  test.description = 'case4: * -> LoggerToFile';
  var path1 = __dirname +'/tmp/out.txt';
  _deleteFile( path1 );
  var loggerToFile = new wLoggerToFile({ outputPath : path1 });
  var l1 = new wLogger({ output : loggerToFile });
  var l2 = new wLogger({ output : loggerToFile });
  l1.log( '1' );
  l2.log( '2' );
  var got = _readFromFile( path1 );
  var expected = '1\n2\n'
  test.identical( got, expected );

  test.description = 'case5: leveling delta';
  var path1 = __dirname +'/tmp/out.txt';
  var loggerToFile = new wLoggerToFile({ outputPath : path1 });
  var l1 = new wLogger();
  l.outputTo( loggerToFile, { combining : 'rewrite', leveling : 'delta' } );
  l.up( 2 );
  var got = loggerToFile.level;
  var expected = 2;
  test.identical( got, expected );
}

//

var inputFrom = function( test )
{
  test.description = 'input from console';
  var path1 = __dirname +'/tmp/out.txt';
  _deleteFile( path1 );
  var loggerToFile = new wLoggerToFile({ outputPath : path1 });
  loggerToFile.inputFrom( console );
  console.log( 'something' )
  loggerToFile.inputUnchain( console );
  var got = _readFromFile( path1 );
  var expected = 'something\n';
  test.identical( got, expected );

  test.description = 'input from console twice';
  var path1 = __dirname +'/tmp/out.txt';
  var path2 = __dirname +'/tmp/out2.txt';
  _deleteFile( path1 );
  _deleteFile( path2 );
  var loggerToFile1 = new wLoggerToFile({ outputPath : path1 });
  var loggerToFile2 = new wLoggerToFile({ outputPath : path2 });
  loggerToFile1.inputFrom( console );
  loggerToFile2.inputFrom( console );
  console.log( 'something' )
  loggerToFile1.inputUnchain( console );
  loggerToFile2.inputUnchain( console );
  var got = [ _readFromFile( path1 ), _readFromFile( path2 ) ];
  var expected = [ 'something\n', 'something\n' ];
  test.identical( got, expected );
}

//

var Proto =
{

  name : 'LoggerToFile test',

  tests :
  {

   toFile : toFile,
   chaining : chaining,
   inputFrom : inputFrom

  },

  /* verbose : 1, */

}

//

_.mapExtend( Self,Proto );
_.Testing.register( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
