( function _ToFile_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../l1_logger/ToFile.s' );

  const _ = _global_.wTools;

  _.include( 'wTesting' );

}

const _ = _global_.wTools;
const Parent = wTools.Testing;

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

//

function toFile( test )
{

  test.case = 'case1';
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var fl = new wPrinterToFile({ outputPath : filePath });
  var l = new _.Logger({ name : 'l' });
  l.outputTo( fl, { combining : 'rewrite' } );
  l.log( 123 )
  var got = _.fileProvider.fileRead( filePath );
  var expected = '123\n';
  test.identical( got, expected );

  test.case = 'case2';
  _.fileProvider.fileDelete( filePath );
  var fl = new wPrinterToFile({ outputPath : filePath });
  var l = new _.Logger({ name : 'l' });
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
  var loggerToFile = new wPrinterToFile({ outputPath : filePath });
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
  var l2 = new _.Logger({ onWriteEnd });
  loggerToFile.outputTo( l2, { combining : 'rewrite' } );
  l.log( 'msg' );
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.case = 'case3: LoggerToFile->LoggerToFile';
  var path2 = _.path.join( context.suiteTempPath, 'out2.txt' );
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  if( _.fileProvider.statResolvedRead( path2 ) )
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
  if( _.fileProvider.statResolvedRead( path1 ) )
  _.fileProvider.fileDelete( path1 );
  var loggerToFile = new wPrinterToFile({ outputPath : path1 });
  var l1 = new _.Logger({ output : loggerToFile });
  var l2 = new _.Logger({ output : loggerToFile });
  l1.log( '1' );
  l2.log( '2' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = '1\n2\n'
  test.identical( got, expected );

  test.case = 'case5: LoggerToFile -> *';
  var path1 = filePath;
  if( _.fileProvider.statResolvedRead( path1 ) )
  _.fileProvider.fileDelete( path1 );
  var loggerToFile = new wPrinterToFile({ outputPath : path1 });
  var l1 = new _.Logger({ name : 'l1' });
  var l2 = new _.Logger({ name : 'l2' });
  loggerToFile.outputTo( l1 );
  loggerToFile.outputTo( l2 );
  loggerToFile.log( '1' );
  loggerToFile.log( '2' );
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

  function onWriteEnd( o ) { got.push( o.joinedInput ) };

}

//

function inputFrom( test )
{
  let context = this;

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

function callbacks( test )
{
  let context = this;

  test.case = 'Logger -> LoggerToFile ( with onWriteBegin )';
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ name : 'ltf', outputPath : filePath, onWriteBegin : callback });
  var l = new _.Logger({ name : 'l', output : loggerToFile });
  l.log( 'msg' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'callback.ltf : msg\n';
  test.identical( got, expected );

  /* */

  test.case = 'Logger -> LoggerToFile ( with onWriteEnd )';
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ name : 'ltf', outputPath : filePath, onWriteEnd : callback });
  var l = new _.Logger({ name : 'l', output : loggerToFile });
  l.log( 'msg' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'msg\n';
  test.identical( got, expected );

  /* */

  test.case = 'LoggerToFile ( with onWriteBegin ) -> LoggerToFile ( with onWriteBegin )';
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ name : 'ltf1', outputPath : filePath, onWriteBegin : callback });
  var loggerToFile2 = new wPrinterToFile({ name : 'ltf2', outputPath : filePath, output : loggerToFile, onWriteBegin : callback });
  loggerToFile2.log( 'msg' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'callback.ltf2 : msg\ncallback.ltf1 : msg\n';
  test.identical( got, expected );

  /* */

  test.case = 'Logger -> LoggerToFile ( with onTransformBegin )';
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ name : 'ltf', outputPath : filePath, onTransformBegin : callback });
  var l = new _.Logger({ name : 'l', output : loggerToFile });
  l.log( 'msg' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'msg\n';
  test.identical( got, expected );

  /* */

  test.case = 'Logger -> LoggerToFile ( with onTransformEnd )';
  if( _.fileProvider.statResolvedRead( filePath ) )
  _.fileProvider.fileDelete( filePath );
  var loggerToFile = new wPrinterToFile({ name : 'ltf', outputPath : filePath, onTransformEnd : callback });
  var l = new _.Logger({ name : 'l', output : loggerToFile });
  l.log( 'msg' );
  var got = _.fileProvider.fileRead( filePath );
  var expected = 'msg\n';
  test.identical( got, expected );

  /* - */

  function callback( o )
  {
    o.input[ 0 ] = `callback.${this.name} : ${o.input[ 0 ]}`;
    return o;
  }

}

//

const Proto =
{

  name : 'Tools.logger.ToFile',
  silencing : 1,
  // enabled : 0, // !!!

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
    inputFrom,
    callbacks,

  },

  /* verbose : 1, */

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
