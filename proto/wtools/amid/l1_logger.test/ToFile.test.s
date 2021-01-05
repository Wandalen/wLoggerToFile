( function _ToFile_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  // require( '../../l9/logger/ToFile.s' );
  require( '../l1_logger/ToFile.s' );

  let _ = _global_.wTools;

  _.include( 'wTesting' );

}

let _ = _global_.wTools;
let Parent = wTools.Testing;
let Self = {};

var filePath;

//

function onSuiteBegin()
{
  let context = this;
  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'LoggetToFile' );
  filePath = _.path.normalize( _.path.join( context.suiteTempPath, 'out.txt' ) );
}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, '/LoggetToFile-' ) )
  _.path.tempClose( context.suiteTempPath );
}

// function testDirMake()
// {
//   suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../../..' ), 'PrinterToFile' );
//   filePath = _.path.normalize( _.path.join( suiteTempPath, 'out.txt' ) );
// }

// //

// function cleanTestDir()
// {
//   _.fileProvider.filesDelete( suiteTempPath );
// }

//

function toFile( test )
{

  test.case = 'case1';
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var fl = new wPrinterToFile({ output : console, outputPath : filePath });
  var l = new _.Logger({ output : console });
  l.outputTo( fl, { combining : 'rewrite' } );
  l.log( 123 )
  var got = _.fileProvider.fileRead( filePath );
  var expected = '123\n';
  test.identical( got, expected );

  test.case = 'case2';
  _.fileProvider.fileDelete( filePath );
  var fl = new wPrinterToFile({ outputPath : filePath, output : console });
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

function chaining( test )
{
  let context = this;

  test.case = 'case1: Logger->LoggerToFile';
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ outputPath : filePath, output : console });
  var l = new _.Logger({ output : loggerToFile });
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  l.log( 'msg' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'msg\n';
  test.identical( got, expected );

  test.case = 'case2: Logger->LoggerToFile->Logger';
  var got = [];
  var loggerToFile = new wPrinterToFile({ outputPath : filePath });
  var l = new _.Logger({ output : loggerToFile });
  var l2 = new _.Logger({ output : console, onTransformEnd });
  loggerToFile.outputTo( l2, { combining : 'rewrite' } );
  l.log( 'msg' );
  var expected = [ 'msg' ]
  test.identical( got, expected );

  test.case = 'case3: LoggerToFile->LoggerToFile';
  var path2 = _.path.join( context.suiteTempPath, 'out2.txt' );
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  if( _.fileProvider.statResolvedRead( path2 ) )
  _.fileProvider.fileDelete( path2 );
  var loggerToFile = new wPrinterToFile({ outputPath : filePath });
  var loggerToFile2 = new wPrinterToFile({ outputPath : path2, output : console });
  loggerToFile.outputTo( loggerToFile2, { combining : 'rewrite' } );
  loggerToFile.log( 'msg' );
  var got = [ _.fileProvider.fileRead( filePath ), _.fileProvider.fileRead( path2 ) ];
  var expected = [ 'msg\n', 'msg\n' ]
  test.identical( got, expected );

  test.case = 'case4: * -> LoggerToFile';
  var path1 = filePath;
  if( _.fileProvider.statResolvedRead( path1 ) )
  _.fileProvider.fileDelete( path1 );
  var loggerToFile = new wPrinterToFile({ outputPath : path1, output : console });
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

  /* - */

  function onTransformEnd( o ) { got.push( o._outputForTerminal[ 0 ] ) };

}

//

function inputFrom( test )
{
  var context = this;

  test.case = 'input from console';

  let consoleWasBarred = _.Logger.ConsoleIsBarred( console );
  test.suite.consoleBar( 0 );

  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ outputPath : filePath });
  loggerToFile.inputFrom( console );
  console.log( 'something' )
  loggerToFile.inputUnchain( console );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'something\n';
  test.identical( got, expected );

  test.case = 'input from console twice';

  var path2 = _.path.join( context.suiteTempPath, 'out2.txt' );
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  if( _.fileProvider.statResolvedRead( path2 ) )
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

  name : 'Tools.logger.ToFile',
  silencing : 1,
  // enabled : 0, // !!!

  // onSuiteBegin : testDirMake,
  // onSuiteEnd : cleanTestDir,
  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    suiteTempPath : null
  },

  tests :
  {

    toFile,
    chaining,
    inputFrom

  },

  /* verbose : 1, */

}

//

_.mapExtend( Self, Proto );
Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
