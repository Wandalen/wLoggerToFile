( function _ToFile_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../printer/top/ToFile.ss' );

  var _ = wTools;

  _.include( 'wTesting' );

}

var _ = wTools;
var Parent = wTools.Testing;
var Self = {};

var testRootDirectory;
var filePath;

//

function testDirMake()
{
  testRootDirectory = _.path.dirTempOpen( _.path.join( __dirname, '../../..' ),'PrinterToFile' );
  filePath = _.path.normalize( _.path.join( testRootDirectory, 'out.txt' ) );
}

//

function cleanTestDir()
{
  _.fileProvider.filesDelete(testRootDirectory );
}

//

var toFile = function( test )
{

  test.case = 'case1';
  if( _.fileProvider.fileStat( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var fl = new wPrinterToFile({ outputPath : filePath });
  var l = new _.Logger({ output : console });
  l.outputTo( fl, { combining : 'rewrite' } );
  l.log( 123 )
  var got = _.fileProvider.fileRead( filePath );
  var expected = '123\n';
  test.identical( got, expected );

  test.case = 'case2';
  _.fileProvider.fileDelete( filePath );
  var fl = new wPrinterToFile({ outputPath : filePath });
  var l = new _.Logger({ output : console });
  l.outputTo( fl, { combining : 'rewrite' } );
  l._dprefix = '*';
  l.up( 2 );
  l.log( 'msg' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = '**msg\n';
  test.identical( got, expected );
}

//

var chaining = function( test )
{
  var onTransformEnd = function( o ) { got.push( o.outputForPrinter[ 0 ] ) };

  test.case = 'case1: Logger->LoggerToFile';
  if( _.fileProvider.fileStat( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ outputPath : filePath });
  var l = new _.Logger({ output : loggerToFile });
  if( _.fileProvider.fileStat( filePath ) )
  _.fileProvider.fileDelete( filePath );
  l.log( 'msg' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'msg\n';
  test.identical( got, expected );

  test.case = 'case2: Logger->LoggerToFile->Logger';
  var got = [];
  var loggerToFile = new wPrinterToFile({ outputPath : filePath });
  var l = new _.Logger({ output : loggerToFile });
  var l2 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  loggerToFile.outputTo( l2, { combining : 'rewrite' } );
  l.log( 'msg' );
  var expected = [ 'msg' ]
  test.identical( got, expected );

  test.case = 'case3: LoggerToFile->LoggerToFile';

  var path2 = _.path.join( testRootDirectory, 'out2.txt' );
  if( _.fileProvider.fileStat( filePath ) )
  _.fileProvider.fileDelete( filePath );
  if( _.fileProvider.fileStat( path2 ) )
  _.fileProvider.fileDelete( path2 );
  var loggerToFile = new wPrinterToFile({ outputPath : filePath });
  var loggerToFile2 = new wPrinterToFile({ outputPath : path2 });
  loggerToFile.outputTo( loggerToFile2, { combining : 'rewrite' } );
  loggerToFile.log( 'msg' );
  var got = [ _.fileProvider.fileRead( filePath ), _.fileProvider.fileRead( path2 ) ];
  var expected = [ 'msg\n', 'msg\n' ]
  test.identical( got, expected );

  test.case = 'case4: * -> LoggerToFile';
  var path1 = filePath;
  if( _.fileProvider.fileStat( path1 ) )
  _.fileProvider.fileDelete( path1 );
  var loggerToFile = new wPrinterToFile({ outputPath : path1 });
  var l1 = new _.Logger({ output : loggerToFile });
  var l2 = new _.Logger({ output : loggerToFile });
  l1.log( '1' );
  l2.log( '2' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = '1\n2\n'
  test.identical( got, expected );

  // test.case = 'case5: leveling delta';
  // var path1 = filePath;
  // var loggerToFile = new wPrinterToFile({ outputPath : path1 });
  // var l1 = new _.Logger({ output : console });
  // l.outputTo( loggerToFile, { combining : 'rewrite', leveling : 'delta' } );
  // l.up( 2 );
  // var got = loggerToFile.level;
  // var expected = 2;
  // test.identical( got, expected );
}

//

var inputFrom = function( test )
{
  test.case = 'input from console';

  let consoleWasBarred = _.Logger.consoleIsBarred( console );
  test.suite.consoleBar( 0 );

  if( _.fileProvider.fileStat( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ outputPath : filePath });
  loggerToFile.inputFrom( console );
  console.log( 'something' )
  loggerToFile.inputUnchain( console );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'something\n';
  test.identical( got, expected );

  test.case = 'input from console twice';

  var path2 = _.path.join( testRootDirectory, 'out2.txt' );
  if( _.fileProvider.fileStat( filePath ) )
  _.fileProvider.fileDelete( filePath );
  if( _.fileProvider.fileStat( path2 ) )
  _.fileProvider.fileDelete( path2 );
  var loggerToFile1 = new wPrinterToFile({ outputPath : filePath });
  var loggerToFile2 = new wPrinterToFile({ outputPath : path2 });
  loggerToFile1.inputFrom( console );
  loggerToFile2.inputFrom( console );
  console.log( 'something' )
  loggerToFile1.inputUnchain( console );
  loggerToFile2.inputUnchain( console );
  var got = [ _.fileProvider.fileRead( filePath ), _.fileProvider.fileRead( path2 ) ];
  var expected = [ 'something\n', 'something\n' ];
  test.identical( got, expected );

  if( consoleWasBarred )
  test.suite.consoleBar( 1 );
}

//

var Proto =
{

  name : 'Tools/base/printer/ToFile',
  silencing : 1,
  // enabled : 0, // !!!

  onSuiteBegin : testDirMake,
  onSuiteEnd : cleanTestDir,

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
Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
