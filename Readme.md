
# module::LoggerToFile [![status](https://github.com/Wandalen/wLoggerToFile/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wLoggerToFile/actions/workflows/StandardPublish.yml) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Class to redirect logging to a file. Logger supports colorful formatting, verbosity control, chaining, combining several loggers/consoles into logging network. Logger provides 10 levels of verbosity [ 0,9 ] any value beyond clamped and multiple approaches to control verbosity. Logger may use console/stream/process/file as input or output. Unlike alternatives, colorful formatting is cross-platform and works similarly in the browser and on the server side. Use the module to make your diagnostic code working on any platform you work with and to been able to redirect your output to/from any destination/source.

The module in JavaScript provides convenient, layered, logging into a file. Logger writes messages( incoming & outgoing ) to file specified by path( outputPath ). Writes each message to the end of a file, creates a new file( outputPath ) if it doesn't exist. Then transfers message to the next output(s) object in the chain if any exists.

### Try out from the repository

```
git clone https://github.com/Wandalen/wLogger
cd wLogger
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wloggertofile@stable'
```

`Willbe` is not required to use the module in your project as submodule.

### Usage
#### Options
* outputPath { string }[ optional ] - output file path, default dirname/output.log.
* output { object }[ optional ] - output object for current logger, null by default.

#### Methods
Output:
* log
* error
* info
* warn

Chaining:
*  Add object to output list - [outputTo](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputTo)
*  Remove object from output list - [outputUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputUnchain)
*  Add current logger to target's output list - [inputFrom](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputFrom)
*  Remove current logger from target's output list - [inputUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputUnchain)

Other:
* Check if object exists in logger's inputs list - [hasInput](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.hasInput)
* Check if object exists in logger's outputs list - [hasOutput](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.hasOutput)

##### Example #1
```javascript
/* Logging to a file */
var l = new wLoggerToFile();
l.log( 'aa\nbb' );
/* output.log gets
aa
bb
*/

```
##### Example #2
```javascript
/* Add console as output and pass custom output path */
var l = new wLoggerToFile
({
  output : console,
  outputPath : 'out2.txt'
});
l.log( 'aa\nbb' );
/* console and out2.txt get
aa
bb
*/
```
##### Example #3
```javascript
/* Console as input for wLoggerToFile to store console output into file */
var l = new wLoggerToFile();
l.inputFrom( console );
console.log( 'aa\nbb' );
/* save console output into file, message by message */
```
